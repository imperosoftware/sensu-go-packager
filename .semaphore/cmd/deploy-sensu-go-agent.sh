SENSU_GO_PKG_NAME=$(curl -sL https://packagecloud.io/sensu/stable/debian/dists/stretch/main/binary-amd64/Packages | awk '($1 ~ /Filename/) && ($2 ~ /sensu-go-agent_'${SENSU_GO_VERSION}'/) { n = split($2, bits, "/"); print bits[n] }')
SENSU_CE_PKG_NAME=$(echo $SENSU_GO_PKG_NAME | sed -re 's/('${SENSU_GO_VERSION}'-[0-9]+)/\1-ce/')

artifact pull workflow $SENSU_CE_PKG_NAME
curl -F package=@$SENSU_CE_PKG_NAME --user "${GEMFURY_TOKEN}:" https://push.fury.io/impero/
