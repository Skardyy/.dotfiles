function svc --description 'launchctl wrapper (4 verbs: enable disable start stop + restart status list)'
    set -l uid (id -u)
    set -l gui "gui/$uid"
    set -l sys system
    set -l cmd $argv[1]
    set -l label $argv[2]

    # locate plist across user + system paths
    function __svc_find_plist -a label
        for dir in ~/Library/LaunchAgents /Library/LaunchAgents /Library/LaunchDaemons
            if test -f $dir/$label.plist
                echo $dir/$label.plist
                return 0
            end
        end
        return 1
    end

    # pick the launchd domain for a given plist path
    function __svc_domain_for_plist -a plist uid
        switch (dirname $plist)
            case /Library/LaunchDaemons
                echo system
            case /Library/LaunchAgents
                echo system
            case '*'
                echo "gui/$uid"
        end
    end

    # figure out which domain a currently loaded label is in
    function __svc_domain -a label uid
        if launchctl print gui/$uid/$label >/dev/null 2>&1
            echo gui/$uid
        else if sudo -n launchctl print system/$label >/dev/null 2>&1
            echo system
        else
            return 1
        end
    end

    # run `launchctl $args` with sudo if domain=system, else without
    function __svc_run -a d
        set -l rest $argv[2..]
        if test $d = system
            sudo launchctl $rest
        else
            launchctl $rest
        end
    end

    switch $cmd
        case enable
            set -l plist (__svc_find_plist $label); or begin
                echo "no plist for $label" >&2
                return 1
            end
            set -l d (__svc_domain_for_plist $plist $uid)
            __svc_run $d enable $d/$label
            __svc_run $d bootstrap $d $plist
        case disable
            set -l d (__svc_domain $label $uid)
            if test -z "$d"
                set -l plist (__svc_find_plist $label); or begin
                    echo "no plist for $label" >&2
                    return 1
                end
                set d (__svc_domain_for_plist $plist $uid)
            end
            __svc_run $d disable $d/$label
            __svc_run $d bootout $d/$label 2>/dev/null
        case start
            set -l d (__svc_domain $label $uid); or begin
                echo "not loaded: $label (enable first)" >&2
                return 1
            end
            __svc_run $d kickstart $d/$label
        case stop
            set -l d (__svc_domain $label $uid); or begin
                echo "not loaded: $label" >&2
                return 1
            end
            __svc_run $d kill TERM $d/$label
        case restart reload
            set -l d (__svc_domain $label $uid); or begin
                echo "not loaded: $label" >&2
                return 1
            end
            __svc_run $d kickstart -k $d/$label
        case status
            set -l d (__svc_domain $label $uid); or begin
                echo "not loaded: $label" >&2
                return 1
            end
            __svc_run $d print $d/$label 2>&1 | grep -E 'state|last exit|program|path' | head
        case list ls
            echo "# user (gui/$uid)"
            launchctl list | grep -v -e ^- -e com.apple -e application\\.
            echo "# system"
            sudo launchctl list 2>/dev/null | grep -v -e ^- -e com.apple -e application\\.
        case '' -h --help help
            echo 'usage: svc <enable|disable|start|stop|restart|status|list> [label]'
        case '*'
            echo "unknown: $cmd" >&2
            return 1
    end
end

complete -c svc -f
complete -c svc -n __fish_use_subcommand \
    -a 'enable disable start stop restart status list' -d subcommand

# completions scoped to verb:
#   enable           -> any plist on disk (loaded or not)
#   disable          -> currently loaded labels (start/stop/restart/status share this)
#   list / status    -> same as above

# all plist-on-disk labels for `enable`
complete -c svc -n '__fish_seen_subcommand_from enable' \
    -a '(for d in ~/Library/LaunchAgents /Library/LaunchAgents /Library/LaunchDaemons \
                "/Library/Application Support"/*/*/*.app/Contents/Library/LaunchAgents \
                "/Library/Application Support"/*/*/*.app/Contents/Library/LaunchDaemons
                ls $d 2>/dev/null | string replace -r "\.plist\$" ""
             end | grep -v ^com.apple | sort -u)' \
    -d 'enable (plist on disk)'

# loaded labels for disable/start/stop/restart/status
complete -c svc -n '__fish_seen_subcommand_from disable start stop restart reload status' \
    -a '(launchctl list | awk "NR>1 {print \$3}" | grep -v -e ^- -e com.apple -e application\\. | sort -u; \
             sudo -n launchctl list 2>/dev/null | awk "NR>1 {print \$3}" | grep -v -e ^- -e com.apple -e application\\. | sort -u)' \
    -d 'loaded label'
