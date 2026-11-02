set -l __bpfrelay_src (path dirname (path resolve (status filename)))/bpfrelay.go

function bpfrelay --description 'Relay UDP ports to 127.0.0.1 via in-process BPF (Go)' --inherit-variable __bpfrelay_src
    set -l dir (set -q XDG_CACHE_HOME; and echo $XDG_CACHE_HOME; or echo ~/.cache)/bpfrelay

    mkdir -p $dir
    # refresh source only when it changed
    if not cmp -s $__bpfrelay_src $dir/main.go
        cp $__bpfrelay_src $dir/main.go
    end

    if not test -f $dir/go.sum
        go -C $dir mod init bpfrelay 2>/dev/null
        go -C $dir mod tidy; or return
    end

    go -C $dir run -exec sudo . $argv
end
