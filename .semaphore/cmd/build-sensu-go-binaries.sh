git -c advice.detachedHead=false clone --branch ${SENSU_GO_VERSION} --depth 1 https://github.com/sensu/sensu-go

pushd sensu-go

go build -ldflags '-X "github.com/sensu/sensu-go/version.Version='${SENSU_GO_VERSION}'" -X "github.com/sensu/sensu-go/version.BuildDate='$(date +%Y-%m-%d)'" -X "github.com/sensu/sensu-go/version.BuildSHA='$(git rev-parse HEAD)'"' -o bin/sensu-agent ./cmd/sensu-agent
artifact push workflow --expire-in 1d bin/sensu-agent

go build -ldflags '-X "github.com/sensu/sensu-go/version.Version='${SENSU_GO_VERSION}'" -X "github.com/sensu/sensu-go/version.BuildDate='$(date +%Y-%m-%d)'" -X "github.com/sensu/sensu-go/version.BuildSHA='$(git rev-parse HEAD)'"' -o bin/sensu-backend ./cmd/sensu-backend
artifact push workflow --expire-in 1d bin/sensu-backend

go build -ldflags '-X "github.com/sensu/sensu-go/version.Version='${SENSU_GO_VERSION}'" -X "github.com/sensu/sensu-go/version.BuildDate='$(date +%Y-%m-%d)'" -X "github.com/sensu/sensu-go/version.BuildSHA='$(git rev-parse HEAD)'"' -o bin/sensuctl ./cmd/sensuctl
artifact push workflow --expire-in 1d bin/sensuctl
