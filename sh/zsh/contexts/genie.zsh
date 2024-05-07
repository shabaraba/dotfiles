# for genie (run systemctl as root)
# wslかどうか
if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
    echo "in wsl"
    #genie(systemdをwslで使用できるようにする)を起動するかどうか
    if [ "`ps -eo pid,cmd | grep systemd | grep -v grep | sort -n -k 1 | awk 'NR==1 { print $1 }'`" != "1" ]; then
      echo "genie is running..."
      genie -s
    fi
fi


