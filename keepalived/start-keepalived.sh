#!/bin/bash

function replace_vars() {
  eval "cat <<EOF
$(<$2)
EOF
  " > $1
}

replace_vars '/keepalived/keepalived.conf' '/keepalived/keepalived.conf.templ'
replace_vars '/keepalived/chk_haproxy.sh' '/keepalived/chk_haproxy.sh.templ'

chmod +x /keepalived/*.sh

/usr/sbin/keepalived --dont-fork --dump-conf --log-console --log-detail --log-facility 7 --vrrp -f /keepalived/keepalived.conf
