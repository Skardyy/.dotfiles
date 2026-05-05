{ user, ... }:
{
  home-manager.users.${user} = { osConfig, ... }: {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = osConfig.networking.hostName;
          email = "meronbssn@gmail.com";
        };
        alias = {
          s = "status -sb";
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
              if [ -z "$1" ]; then
                echo "usage: git co <branch|hash> | <remote> <branch>" >&2
                exit 1
              fi

              if [ -z "$2" ] && git rev-parse --verify --quiet "$1^{commit}" >/dev/null; then
                exec git checkout "$1"
              fi

              if [ -n "$2" ]; then
                remote="$1"
                branch_q="$2"
                if ! git remote | grep -qx "$remote"; then
                  echo "no remote named '$remote'" >&2
                  exit 1
                fi
                matches=$(git for-each-ref --format='%(refname:short)' "refs/remotes/$remote" \
                  | sed "s,^$remote/,," \
                  | grep -v '^HEAD$' \
                  | grep -i -- "$branch_q")
                count=$(printf '%s\n' "$matches" | grep -c .)
                case "$count" in
                  0) echo "no branch matching '$branch_q' on $remote" >&2; exit 1 ;;
                  1) exec git checkout "$matches" ;;
                  *) echo "multiple matches on $remote:" >&2; printf '  %s\n' $matches >&2; exit 1 ;;
                esac
              fi

              matches=$(git for-each-ref --format='%(refname:short)' refs/heads | grep -i -- "$1")
              count=$(printf '%s\n' "$matches" | grep -c .)
              case "$count" in
                0) echo "no branch matching '$1'" >&2; exit 1 ;;
                1) exec git checkout "$matches" ;;
                *) echo "multiple matches:" >&2; printf '  %s\n' $matches >&2; exit 1 ;;
              esac
            }; f "$@"
          '';
        };
      };
    };
  };
}
