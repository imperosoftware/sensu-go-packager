cd /
artifact pull workflow sensu-agent
chmod +x sensu-agent
# Belt & braces checks
./sensu-agent version | grep sensu-agent
./sensu-agent version | grep "built $(date +%Y-%m-%d)"
./sensu-agent version | grep "version ${SENSU_GO_VERSION}+ce, community edition"
# Includes a SHA
./sensu-agent version | grep ', build '
