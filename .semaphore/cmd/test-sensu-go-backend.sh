artifact pull workflow sensu-backend
chmod +x sensu-backend
# Belt & braces checks
./sensu-backend version | grep sensu-backend
./sensu-backend version | grep "built $(date +%Y-%m-%d)"
./sensu-backend version | grep "version ${SENSU_GO_VERSION}+ce, community edition"
# Includes a SHA
./sensu-backend version | grep ', build '
