#!/usr/bin/env bash
# wine-hidfix.sh - make Windows HID config apps (keyboard/mouse/controller drivers) find their device under Wine/Proton/umu.
#
#   ./wine-hidfix.sh [install|uninstall|status|source] [wineprefix]
#
# Default: install into ~/Games/umu/umu-default. Builds the proxy from the C source embedded below (`source` prints it).
# Compiler: x86_64-w64-mingw32-gcc if present, otherwise fetched with nix-build (NixOS). Re-run after a Proton update.
# For the app: PROTON_ENABLE_HIDRAW=0x<VID>/0x<PID>, and a hidraw node you can access.
# Env: PROTONPATH (GE-Proton), GAMEID (umu-default), HIDFIX_ORIG=<genuine cfgmgr32.dll>, HIDFIX_SKIP_REG=1, HIDFIX_LOG=1
set -euo pipefail
die() { echo "error: $*" >&2; exit 1; }
embedded() { sed -n "/^#__$1_BEGIN__\$/,/^#__$1_END__\$/p" "$0" | sed '1d;$d'; }

case "${1:-}" in -h|--help|help) sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'; exit 0;; esac
cmd=install
case "${1:-}" in install|uninstall|status|source) cmd=$1; shift;; esac
[ "$cmd" = source ] && { embedded SRC; exit 0; }
prefix_arg=${1:-$HOME/Games/umu/umu-default}

prefix=""
for cand in "$prefix_arg" "$prefix_arg/pfx"; do
  if [ -d "$cand/drive_c/windows/system32" ]; then prefix=$cand; break; fi
done
[ -n "$prefix" ] || die "no drive_c/windows/system32 under '$prefix_arg'"
sys32="$prefix/drive_c/windows/system32"
dll="$sys32/cfgmgr32.dll"; real="$sys32/cfgmgr32_real.dll"

# any proxy (this tool's or an older hand-made one) forwards to "cfgmgr32_real."; the genuine Wine DLL never does
is_proxy() { [ -f "$1" ] && grep -aq 'HIDFIX_PROXY\|cfgmgr32_real\.' "$1"; }

find_builtin() {  # genuine Wine cfgmgr32.dll from a Proton install
  local f
  if [ -n "${HIDFIX_ORIG:-}" ]; then echo "$HIDFIX_ORIG"; return 0; fi
  while read -r f; do
    [ "$(stat -c %s "$f")" -gt 100000 ] && ! is_proxy "$f" && { echo "$f"; return 0; }
  done < <(find "$HOME/.local/share/Steam/compatibilitytools.d" "$HOME/.steam" "$HOME/.local/share/umu" /usr/share/steam /opt \
             -path '*x86_64-windows/cfgmgr32.dll' 2>/dev/null | sort -r)
  return 1
}

reg() {
  if command -v umu-run >/dev/null 2>&1; then
    WINEPREFIX="$prefix" PROTONPATH="${PROTONPATH:-GE-Proton}" GAMEID="${GAMEID:-umu-default}" umu-run reg "$@" >/dev/null 2>&1
  elif command -v wine >/dev/null 2>&1; then
    WINEPREFIX="$prefix" wine reg "$@" >/dev/null 2>&1
  else
    return 1
  fi
}

# ---- compiler: system mingw, or the nixpkgs cross toolchain located by nix-build (no nix-shell) ----
CC=${CC:-x86_64-w64-mingw32-gcc}; OBJDUMP=${OBJDUMP:-x86_64-w64-mingw32-objdump}; CFLAGS_EXTRA=()
setup_cc() {
  command -v "$CC" >/dev/null 2>&1 && return 0
  command -v nix-build >/dev/null 2>&1 || die "$CC not found, and no nix-build to fetch one (install mingw-w64)"
  local nb='nix-build <nixpkgs> --no-out-link -A' gccp hdr crt all inc lib
  echo "fetching the mingw-w64 toolchain with nix-build..."
  gccp=$($nb pkgsCross.mingwW64.buildPackages.gcc | head -1)
  hdr=$($nb pkgsCross.mingwW64.windows.mingw_w64_headers)
  crt=$($nb pkgsCross.mingwW64.windows.mingw_w64)
  CC="$gccp/bin/x86_64-w64-mingw32-gcc"; OBJDUMP="$gccp/bin/x86_64-w64-mingw32-objdump"
  [ -x "$CC" ] || die "nix gcc not found at $CC"
  all=$(printf '%s\n%s\n' "$hdr" "$crt")
  # the nix gcc wrapper does not reliably expose the Windows headers/import libs: find them in the store ourselves
  inc=$(find $all -name windows.h 2>/dev/null | head -1)
  [ -n "$inc" ] || die "windows.h not found in: $(echo $all)"
  CFLAGS_EXTRA+=(-idirafter "$(dirname "$inc")")
  for l in libkernel32.a libuser32.a libmsvcrt.a; do
    lib=$(find $all -name "$l" 2>/dev/null | head -1)
    [ -n "$lib" ] && CFLAGS_EXTRA+=(-L "$(dirname "$lib")")
  done
  echo "headers: $(dirname "$inc")"
}

export_names() {  # exported function names of the genuine DLL
  if command -v "$OBJDUMP" >/dev/null 2>&1; then
    "$OBJDUMP" -p "$1" | awk '/Ordinal\/Name Pointer\] Table/{f=1;next} f && /^[[:space:]]*\[ *[0-9]+\]/ {print $NF}' | grep -E '^[A-Za-z_][A-Za-z0-9_@?$]*$' | sort -u
  else
    grep -aoE 'CMP?_[A-Za-z0-9_]+' "$1" | sort -u   # export names are plain strings in the DLL
  fi
}

do_install() {
  [ -f "$dll" ] || die "$dll missing"
  if is_proxy "$dll"; then
    if [ ! -f "$real" ] || is_proxy "$real"; then
      orig=$(find_builtin) || die "$real is missing or itself a proxy and no genuine Proton cfgmgr32.dll was found; set HIDFIX_ORIG=/path/to/x86_64-windows/cfgmgr32.dll"
      echo "restoring original from $orig"; cp -f "$orig" "$real"
    fi
  else
    cp -f "$dll" "$real"        # Wine/Proton just (re)wrote the builtin: keep it as the forwarding target
  fi
  setup_cc
  local tmp; tmp=$(mktemp -d); trap "rm -rf '$tmp'" EXIT
  embedded SRC > "$tmp/hidfix.c"
  export_names "$real" > "$tmp/names.txt"
  [ "$(wc -l < "$tmp/names.txt")" -gt 100 ] || die "could not read exports of $real"
  grep -qx CM_Get_DevNode_PropertyW "$tmp/names.txt" || die "$real has no CM_Get_DevNode_PropertyW export"
  { echo 'LIBRARY cfgmgr32.dll'; echo EXPORTS
    while read -r n; do
      if [ "$n" = CM_Get_DevNode_PropertyW ]; then echo "  $n = my_$n"; else echo "  $n = cfgmgr32_real.$n"; fi
    done < "$tmp/names.txt"; } > "$tmp/hidfix.def"
  # -nostdlib: only kernel32/user32/msvcrt are needed, no libgcc/mcfgthread (missing from the nix toolchain)
  "$CC" "${CFLAGS_EXTRA[@]}" -O1 -Wall -shared -o "$tmp/cfgmgr32.dll" "$tmp/hidfix.c" "$tmp/hidfix.def" \
      -nostdlib -nostartfiles -Wl,--entry=DllMain -lkernel32 -luser32 -lmsvcrt 2>&1 | head -15
  [ -s "$tmp/cfgmgr32.dll" ] || die "build failed (see compiler output above)"
  cp -f "$tmp/cfgmgr32.dll" "$dll"
  echo "installed proxy -> $dll  (original kept as cfgmgr32_real.dll)"
  if [ "${HIDFIX_SKIP_REG:-0}" = 1 ]; then echo "skipped registry step"; else
    if reg add 'HKCU\Software\Wine\DllOverrides' /v cfgmgr32 /d native,builtin /f; then echo "registry override set (cfgmgr32=native,builtin)"
    else echo "COULD NOT set the DLL override. Run once:  WINEPREFIX=$prefix wine reg add 'HKCU\\Software\\Wine\\DllOverrides' /v cfgmgr32 /d native,builtin /f"; fi
  fi
  echo
  echo "Launch the app with:  PROTON_ENABLE_HIDRAW=0x<VID>/0x<PID> pine <app.exe>   (hidraw node must be accessible at plug-in)"
}

do_uninstall() {
  if is_proxy "$dll" && [ -f "$real" ] && ! is_proxy "$real"; then cp -f "$real" "$dll" && rm -f "$real"; echo "restored original cfgmgr32.dll"
  else echo "nothing to restore (proxy not installed, or no genuine original saved)"; fi
  reg delete 'HKCU\Software\Wine\DllOverrides' /v cfgmgr32 /f || true
}

do_status() {
  if is_proxy "$dll"; then echo "proxy: installed ($(stat -c %s "$dll") bytes), original: $( [ -f "$real" ] && ! is_proxy "$real" && echo present || echo MISSING )"
  else echo "proxy: not installed ($(stat -c %s "$dll") bytes)"; fi
}

case "$cmd" in install) do_install;; uninstall) do_uninstall;; status) do_status;; esac
exit 0

: <<'__HIDFIX_DATA__'
#__SRC_BEGIN__
/* wine-hidfix: cfgmgr32.dll proxy that makes Windows HID config apps (hidapi based) work under Wine/Proton.
 *
 * Fix 1  Wine gives HID parent devices only WINEBUS\WINE_COMP_HID as CompatibleIds. hidapi finds the bus type
 *        and interface number through "USB\Class_03..." entries there, so it reports bus=unknown, iface=-1
 *        and apps skip the device. We append the generic USB HID class IDs for device nodes whose id is USB\...
 *
 * Fix 2  winebus (hidraw backend) returns count+1 as Information for report-ID-0 feature reads (HIDIOCGFEATURE(len+1)
 *        return value, ID byte not in the data). Windows returns len. hidapi returns Information+1, apps slice with
 *        it and panic/overrun. For non-system processes we hook DeviceIoControl/GetOverlappedResult imports and
 *        subtract 1 from IOCTL_HID_GET_FEATURE results.
 *
 * Everything else in cfgmgr32 is forwarded to the original, renamed cfgmgr32_real.dll. Set HIDFIX_LOG=1 for C:\hidfix.log */
#include <windows.h>
#include <cfgmgr32.h>
#include <devpropdef.h>

__attribute__((used)) static const char g_marker[] = "HIDFIX_PROXY_V2";

/* ---------- logging (opt-in) ---------- */
static int g_log;
static void hlog(const char *m)
{
    if (!g_log) return;
    HANDLE h = CreateFileW(L"C:\\hidfix.log", GENERIC_WRITE, FILE_SHARE_READ|FILE_SHARE_WRITE, NULL, OPEN_ALWAYS, 0, NULL);
    if (h == INVALID_HANDLE_VALUE) return;
    char b[400]; DWORD w; int n = wsprintfA(b, "[pid %lu] %s\r\n", GetCurrentProcessId(), m);
    SetFilePointer(h, 0, NULL, FILE_END); WriteFile(h, b, n, &w, NULL); CloseHandle(h);
}

/* ---------- Fix 1: CompatibleIds ---------- */
typedef CONFIGRET (WINAPI *PFN_Prop)(DEVINST, const DEVPROPKEY *, DEVPROPTYPE *, PBYTE, PULONG, ULONG);
typedef CONFIGRET (WINAPI *PFN_ID)(DEVINST, PWSTR, ULONG, ULONG);
static HMODULE g_real; static PFN_Prop g_prop; static PFN_ID g_id;
static const wchar_t kExtra[] = L"USB\\Class_03&SubClass_01&Prot_01\0USB\\Class_03&SubClass_01\0USB\\Class_03\0";
#define EXTRA_CHARS ((sizeof(kExtra) / sizeof(wchar_t)) - 1)

static int init(void)
{
    if (g_prop) return 1;
    g_real = LoadLibraryW(L"cfgmgr32_real.dll");
    if (!g_real) return 0;
    g_prop = (PFN_Prop)GetProcAddress(g_real, "CM_Get_DevNode_PropertyW");
    g_id = (PFN_ID)GetProcAddress(g_real, "CM_Get_Device_IDW");
    return g_prop != NULL;
}

CONFIGRET WINAPI my_CM_Get_DevNode_PropertyW(DEVINST dn, const DEVPROPKEY *key, DEVPROPTYPE *type, PBYTE buf, PULONG size, ULONG flags)
{
    static const GUID g = {0xa45c254e,0xdf1c,0x4efd,{0x80,0x20,0x67,0xd1,0x46,0xa8,0x50,0xe0}};
    if (!init()) return CR_FAILURE;
    if (!key || key->pid != 4 || memcmp(&key->fmtid, &g, sizeof g) != 0 || !size)
        return g_prop(dn, key, type, buf, size, flags);
    wchar_t id[300] = {0};
    if (!g_id || g_id(dn, id, 300, 0) != CR_SUCCESS || wcsncmp(id, L"USB\\", 4) != 0)
        return g_prop(dn, key, type, buf, size, flags);

    ULONG user_size = *size; DEVPROPTYPE t = 0;
    CONFIGRET cr = g_prop(dn, key, &t, buf, size, flags);
    if (type) *type = t;
    ULONG extra_bytes = (ULONG)(EXTRA_CHARS * sizeof(wchar_t));
    if (cr == CR_BUFFER_SMALL) { *size += extra_bytes; return CR_BUFFER_SMALL; }
    if (cr != CR_SUCCESS || !buf) return cr;
    ULONG real_size = *size, new_size = real_size + extra_bytes;
    if (user_size < new_size) { *size = new_size; return CR_BUFFER_SMALL; }
    wchar_t *w = (wchar_t *)buf; size_t max = real_size / sizeof(wchar_t), p = 0;
    while (p < max && w[p]) p += wcslen(w + p) + 1;
    memcpy(w + p, kExtra, EXTRA_CHARS * sizeof(wchar_t));
    w[p + EXTRA_CHARS] = 0;
    *size = (ULONG)((p + EXTRA_CHARS + 1) * sizeof(wchar_t));
    return CR_SUCCESS;
}

/* ---------- Fix 2: feature report byte count ---------- */
typedef BOOL (WINAPI *PFN_DIOC)(HANDLE,DWORD,LPVOID,DWORD,LPVOID,DWORD,LPDWORD,LPOVERLAPPED);
typedef BOOL (WINAPI *PFN_GOR)(HANDLE,LPOVERLAPPED,LPDWORD,BOOL);
typedef HMODULE (WINAPI *PFN_LLW)(LPCWSTR);
typedef HMODULE (WINAPI *PFN_LLEXW)(LPCWSTR,HANDLE,DWORD);
static PFN_DIOC real_dioc; static PFN_GOR real_gor; static PFN_LLW real_llw; static PFN_LLEXW real_llexw;
#define IOCTL_HID_GET_FEATURE_ 0xb0192
#define NPEND 256
static LPOVERLAPPED volatile g_pend[NPEND];

static void pend_add(LPOVERLAPPED ov)
{
    for (int i = 0; i < NPEND; i++)
        if (InterlockedCompareExchangePointer((PVOID volatile *)&g_pend[i], ov, NULL) == NULL) return;
}
static int pend_take(LPOVERLAPPED ov)
{
    for (int i = 0; i < NPEND; i++)
        if (g_pend[i] == ov && InterlockedCompareExchangePointer((PVOID volatile *)&g_pend[i], NULL, ov) == ov) return 1;
    return 0;
}
static BOOL WINAPI my_DeviceIoControl(HANDLE h, DWORD code, LPVOID in, DWORD insz, LPVOID out, DWORD outsz, LPDWORD ret, LPOVERLAPPED ov)
{
    if (code == IOCTL_HID_GET_FEATURE_ && ov) pend_add(ov);
    return real_dioc(h, code, in, insz, out, outsz, ret, ov);
}
static BOOL WINAPI my_GetOverlappedResult(HANDLE h, LPOVERLAPPED ov, LPDWORD n, BOOL wait)
{
    BOOL r = real_gor(h, ov, n, wait);
    if (r && ov && n && pend_take(ov) && *n > 0) { (*n)--; hlog("feature report byte count adjusted by -1"); }
    return r;
}

static int is_system_path(const wchar_t *p)
{
    return p && (!_wcsnicmp(p, L"C:\\windows\\", 11) || !_wcsnicmp(p, L"\\\\?\\C:\\windows\\", 15));
}
static void patch_iat(HMODULE m);
static HMODULE patch_loaded(HMODULE h, LPCWSTR name)
{
    wchar_t path[MAX_PATH] = {0};
    if (!h || (ULONG_PTR)h & 3) return h;
    if (GetModuleFileNameW(h, path, MAX_PATH) && !is_system_path(path)) patch_iat(h);
    (void)name; return h;
}
static HMODULE WINAPI my_LoadLibraryW(LPCWSTR n) { HMODULE h = real_llw(n); return patch_loaded(h, n); }
static HMODULE WINAPI my_LoadLibraryExW(LPCWSTR n, HANDLE f, DWORD fl)
{
    HMODULE h = real_llexw(n, f, fl);
    if (fl & (LOAD_LIBRARY_AS_DATAFILE | LOAD_LIBRARY_AS_IMAGE_RESOURCE | LOAD_LIBRARY_AS_DATAFILE_EXCLUSIVE)) return h;
    return patch_loaded(h, n);
}

static void patch_iat(HMODULE m)
{
    BYTE *base = (BYTE *)m;
    IMAGE_DOS_HEADER *dos = (IMAGE_DOS_HEADER *)base;
    if (dos->e_magic != IMAGE_DOS_SIGNATURE) return;
    IMAGE_NT_HEADERS *nt = (IMAGE_NT_HEADERS *)(base + dos->e_lfanew);
    if (nt->Signature != IMAGE_NT_SIGNATURE) return;
    IMAGE_DATA_DIRECTORY dd = nt->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT];
    if (!dd.VirtualAddress) return;
    int patched = 0;
    for (IMAGE_IMPORT_DESCRIPTOR *imp = (IMAGE_IMPORT_DESCRIPTOR *)(base + dd.VirtualAddress); imp->Name; imp++) {
        ULONG_PTR *thunk = (ULONG_PTR *)(base + imp->FirstThunk);
        ULONG_PTR *names = (ULONG_PTR *)(base + (imp->OriginalFirstThunk ? imp->OriginalFirstThunk : imp->FirstThunk));
        for (; *names; names++, thunk++) {
            if (*names & IMAGE_ORDINAL_FLAG) continue;
            const char *nm = (const char *)((IMAGE_IMPORT_BY_NAME *)(base + *names))->Name;
            void *repl = NULL; void **slot = NULL;
            if (!lstrcmpA(nm, "DeviceIoControl")) { repl = (void *)my_DeviceIoControl; slot = (void **)&real_dioc; }
            else if (!lstrcmpA(nm, "GetOverlappedResult")) { repl = (void *)my_GetOverlappedResult; slot = (void **)&real_gor; }
            else if (!lstrcmpA(nm, "LoadLibraryW")) { repl = (void *)my_LoadLibraryW; slot = (void **)&real_llw; }
            else if (!lstrcmpA(nm, "LoadLibraryExW")) { repl = (void *)my_LoadLibraryExW; slot = (void **)&real_llexw; }
            if (!repl || (void *)*thunk == repl) continue;
            DWORD old;
            if (!VirtualProtect(thunk, sizeof(*thunk), PAGE_READWRITE, &old)) continue;
            if (!*slot) *slot = (void *)*thunk;
            *thunk = (ULONG_PTR)repl;
            VirtualProtect(thunk, sizeof(*thunk), old, &old);
            patched++;
        }
    }
    if (patched) { char b[120]; wsprintfA(b, "IAT hooks installed in module %p: %d", (void *)m, patched); hlog(b); }
}

BOOL WINAPI DllMain(HINSTANCE h, DWORD reason, LPVOID r)
{
    (void)h; (void)r;
    if (reason == DLL_PROCESS_ATTACH) {
        wchar_t path[MAX_PATH] = {0};
        g_log = GetEnvironmentVariableA("HIDFIX_LOG", NULL, 0) > 0;
        GetModuleFileNameW(NULL, path, MAX_PATH);
        if (!is_system_path(path)) { hlog("proxy active in non-system process"); patch_iat(GetModuleHandleW(NULL)); }
    }
    return TRUE;
}
#__SRC_END__
__HIDFIX_DATA__
