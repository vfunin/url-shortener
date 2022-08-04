FLAGS:= GOOS=linux GOARCH=amd64 CGO_ENABLED=0
CMD:= ./cmd/url-shortener
BIN:= ${PWD}/bin

.PHONY: build
build:
	$(info Start build)
	$(FLAGS) go build -a -tags netgo -ldflags="-w -extldflags '-static'" -o ./main $(CMD)

.PHONY: install-tools
install-tools:
	$(info Install oapi-codegen into ./bin folder)
	@mkdir -p ./bin
	@GOBIN=${BIN} go install github.com/deepmap/oapi-codegen/cmd/oapi-codegen@v1.11.0
	@GOBIN=${BIN} go install github.com/pressly/goose/v3/cmd/goose@v3.6.1

.PHONY: run
run:
	$(info Start application)
	docker-compose up -d

.PHONY: docker-build
docker-build:
	$(info Build docker)
	docker-compose build

.PHONY: stop
stop:
	$(info Stop application)
	docker-compose down

.PHONY: test
test:
	$(info Start tests)
	go test -race -coverprofile=coverage.txt -covermode=atomic --tags=integration ./...

.PHONY: lint
lint:
	$(info Start lint)
	golangci-lint run
