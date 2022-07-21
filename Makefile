.PHONY: all
all: lint test run

.PHONY: run
run:
	@echo 'Start app'
	docker-compose up -d
	@echo 'App started at http://localhost'

.PHONY: stop
stop:
	@echo 'Stop app'
	docker-compose down

.PHONY: test
test:
	@echo 'Start tests'
	go test -race -coverprofile=coverage.txt -covermode=atomic --tags=integration ./...

.PHONY: lint
lint:
	@echo 'Start lint'
	golangci-lint run
