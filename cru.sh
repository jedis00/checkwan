#!/bin/sh
D="/var/spool/cron/crontabs"
U="$D/cron.update"
F="$D/root"
N="$F.new"
L="/var/lock/cron.lock"

if [ $# -gt 1 -a "$1" = "a" -o "$1" = "d" ]; then
        if [ -f $L ];
        then
                I=$((($$ % 25) + 5))
                while ! rm $L 2>/dev/null; do
                        I=$(($I - 1))
                        [ $I -lt 0 ] && break
                        sleep 1
                done
        fi

        ID=$2
        grep -v "#$ID#\$" $F >$N 2>/dev/null
        if [ "$1" = "a" ]; then
                shift
                shift
                echo -e "$* #$ID#\n" >>$N
        fi
        mv $N $F
        echo root >>$U

        echo >$L
        exit 0
fi

if [ "$1" = "l" ]; then
        cat $F 2>/dev/null
        exit 0
fi

cat <<END

Cron Utility
add:    cru a <unique id> <"min hour day month week command">
delete: cru d <unique id>
list:   cru l

END
exit 0
