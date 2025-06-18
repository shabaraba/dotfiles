# for genie (run systemctl as root)
# wslかどうか
if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
    echo "in wsl"
    # genie(systemdをwslで使用できるようにする)を起動するかどうか
    if command -v ps >/dev/null 2>&1; then
        # Ubuntu/Linux用のpsコマンド構文
        if [ "$(ps -eo pid,comm | grep systemd | grep -v grep | sort -n -k 1 | awk 'NR==1 { print $1 }')" != "1" ]; then
            echo "genie is running..."
            if command -v genie >/dev/null 2>&1; then
                genie -s
            else
                echo "genie not found, skipping..."
            fi
        fi
    fi
fi