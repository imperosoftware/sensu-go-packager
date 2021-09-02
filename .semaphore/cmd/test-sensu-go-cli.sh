artifact pull workflow sensuctl
chmod +x sensuctl
# Belt & braces checks
./sensuctl version | grep sensuctl
./sensuctl version | grep "built $(date +%Y-%m-%d)"
./sensuctl version | grep "version v${SENSU_GO_VERSION}+ce, community edition"
# Includes a SHA
./sensuctl version | grep ', build '
