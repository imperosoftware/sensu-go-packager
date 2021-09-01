pushd /mnt

SENSU_GO_PKG_NAME=$(curl -sL https://packagecloud.io/sensu/stable/debian/dists/stretch/main/binary-amd64/Packages | awk '($1 ~ /Filename/) && ($2 ~ /sensu-go-cli_'${SENSU_GO_VERSION#v}'/) { n = split($2, bits, "/"); print bits[n] }')
SENSU_CE_PKG_NAME=$(echo $SENSU_GO_PKG_NAME | sed -re 's/('${SENSU_GO_VERSION#v}'-[0-9]+)/\1-ce/')

# Grab & unpack the deb
curl -sfL -o ${SENSU_GO_PKG_NAME} https://packagecloud.io/sensu/stable/packages/debian/stretch/${SENSU_GO_PKG_NAME}/download.deb
dpkg-deb --vextract ${SENSU_GO_PKG_NAME} sensu-go-cli
dpkg-deb --control ${SENSU_GO_PKG_NAME} sensu-go-cli/DEBIAN

pushd sensu-go-cli

# Swap out the binary
rm usr/sbin/sensuctl
artifact pull workflow sensuctl --destination usr/sbin/sensuctl

# Update md5sum with new binary's hash
sed '/usr\/sbin\/sensuctl/d' -i'' DEBIAN/md5sums
md5sum usr/sbin/sensuctl >> DEBIAN/md5sums

# Update the version (append ~ce)
sed -re 's/^(Version: .+)$/\1~ce/' -e 's#^(Homepage:).+$#\1 https://github.com/sensu/sensu-go#' -e 's/^(Maintainer:).+$/\1 Caius <sensu-go-oss@caius.name>/' -e 's/^(Installed-Size:).+$/\1 '$(du -sk . | awk '{ print $1 }')'/' -i'' DEBIAN/control

# dpkg-deb whinges if we don't do this first
chmod 755 DEBIAN/{postinst,postrm,preinst,prerm}

popd

# Package everything back up, add -ce after version in deb filename
dpkg-deb --build sensu-go-cli $SENSU_CE_PKG_NAME
artifact push workflow --expire-in 1w $SENSU_CE_PKG_NAME
