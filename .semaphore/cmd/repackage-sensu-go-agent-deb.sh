cd /
mkdir sensu-go-agent

# Grab & unpack the deb
curl -sfL -o ${SENSU_GO_PKG_NAME} https://packagecloud.io/sensu/stable/packages/debian/stretch/${SENSU_GO_PKG_NAME}/download.deb
dpkg-deb -x ${SENSU_GO_PKG_NAME} sensu-go-agent

pushd sensu-go-agent

# Swap out the binary
rm usr/sbin/sensu-agent
artifact pull workflow sensu-agent --destination usr/sbin/sensu-agent

# Update md5sum with new binary's hash
sed -e '/usr\\/sbin\\/sensu-agent/ d' -i '' md5sum
md5sum usr/sbin/sensu-agent >> md5sum

# Package everything back up, add -ce after version in deb filename
dpkg-deb --build sensu-go-agent ${SENSU_GO_PKG_NAME/${SENSU_GO_VERSION#v}/${SENSU_GO_VERSION#v}-ce}
artifact push workflow ${SENSU_GO_PKG_NAME/${SENSU_GO_VERSION#v}/${SENSU_GO_VERSION#v}-ce}
