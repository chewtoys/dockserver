#!/usr/bin/with-contenv bash
# shellcheck shell=bash
#####################################
# All rights reserved.              #
# started from Zero                 #
# Docker owned dockserver           #
# Docker Maintainer dockserver      #
#####################################
#####################################
# THIS DOCKER IS UNDER LICENSE      #
# NO CUSTOMIZING IS ALLOWED         #
# NO REBRANDING IS ALLOWED          #
# NO CODE MIRRORING IS ALLOWED      #
#####################################
# shellcheck disable=SC2086
# shellcheck disable=SC2006
appstartup() {
if [[ $EUID -ne 0 ]];then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  You must execute as a SUDO user (with sudo) or as ROOT!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
exit 0
fi
while true;do
  $(command -v apt) update -yqq && $(command -v apt) upgrade -yqq
  if [[ ! -x $(command -v docker) ]];then 
     clear && LOCATION=preinstall && selection
  else
     clear && headinterface
  fi
done
}
updatecompose() {
   if [[ -f ~/.docker/cli-plugins/docker-compose ]]; then
      rm -f ~/.docker/cli-plugins/docker-compose
   fi
   if [[ ! -f /usr/local/bin/docker-compose ]]; then
      curl -L --fail https://github.com/linuxserver/docker-docker-compose/releases/download/1.29.2-ls51/docker-cli-amd64 -o /usr/local/bin/docker-compose
      chmod +x /usr/local/bin/docker-compose
   fi
}
updatebin() {
file=/opt/dockserver/.installer/dockserver
store=/bin/dockserver
store2=/usr/bin/dockserver
if [[ -f "/bin/dockserver" ]];then
   $(command -v rm) $store
   $(command -v rsync) $file $store -aqhv
   $(command -v rsync) $file $store2 -aqhv
   $(command -v chown) -R 1000:1000 $store $store2
   $(command -v chmod) -R 755 $store $store2
fi
}
selection() {
LOCATION=${LOCATION}
cd /opt/dockserver/${LOCATION} && $(command -v bash) install.sh
}
headinterface() {
##updatecompose
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀 DockServer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    [ 1 ] DockServer - Traefik + Authelia
    [ 2 ] DockServer - Applications

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    [ EXIT or Z ] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -erp "↘️  Type Number and Press [ENTER]: " headsection </dev/tty
  case $headsection in
    1) clear && LOCATION=traefik && selection ;;
    2) clear && LOCATION=apps && selection ;;
    Z|z|exit|EXIT|Exit|close) updatebin && exit ;;
    *) clear && appstartup ;;
  esac
}
appstartup
#EOF
## REWORK FOR KEY MOUNTING
    ##[ 3 ] DockServer - Google Service Key Builder
    ##3) clear && LOCATION=gdsa && selection ;;
    ##4) clear && LOCATION=rclone && selection ;;
    ##[ 4 ] DockServer - Rclone Builder
## REWORK FOR KEY MOUNTING
