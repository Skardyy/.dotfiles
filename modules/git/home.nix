{ osConfig, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = osConfig.networking.hostName;
        email = "meronbssn@gmail.com";
      };
      alias = {
        s = "status -sb";
        st = "status";
        b = "branch -vv";
        cb = "checkout -b";
        c = "commit";
        ca = "commit --amend";
        a = "add";
        aa = "add -A";
        l = "log -8 --graph --oneline --decorate";
        ll = "log --stat --decorate";
        p = "push";
        pf = "push --force-with-lease";
        pl = "pull";
        plr = "pull --rebase";
        sp = "stash pop";
        sps = "stash push --";
        t = "tag";
        td = "tag -d";
        tdr = "push origin -d";
        co = ''
          !f() {
            q="$1"
            matches=$(git for-each-ref --format='%(refname:short)' refs/heads refs/remotes | sed 's,^origin/,,' | grep -v '^HEAD$' | sort -u | grep -i -- "$q")
            count=$(printf '%s\n' "$matches" | grep -c .)
            case "$count" in
              0) echo "no branch matching '$q'" >&2; exit 1 ;;
              1) git checkout $matches ;;
              *) echo "multiple matches:" >&2; printf '  %s\n' $matches >&2; exit 1 ;;
            esac
          }; f
        '';
      };
    };
  };
}
