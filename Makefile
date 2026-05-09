include .env
export

export PROJECT_ROOT=$(shell pwd)

UID := $(shell id -u)
GID := $(shell id -g)

.PHONY: setUp tearDown clear

setup:
	@if [ -z "$(name)" ]; then \
		echo "❌ Ошибка: необходимо указать имя сервиса"; \
		echo "Пример: make setup name=postgres-port-forwarder"; \
		exit 1; \
	fi
	docker compose up -d $(name)

teardown:
	docker compose down

clearPgData:
	@read -p "Вы уверены, что хотите удалить папку out/pgData? (y/N): " confirm; \
	if [ "$$confirm" = "y" ]; then \
		echo "Удаление out/pgData..."; \
		sudo rm -rf out/pgData; \
		echo "Папка out/pgData удалена."; \
	else \
		echo "Удаление отменено."; \
	fi \

port-forward:
	docker compose up -d postgres-port-forwarder

port-close:
	docker compose down

migrate-create:
	@if [ -z "$(name)" ]; then \
		echo "❌ Ошибка: необходимо указать имя миграции"; \
		echo "Пример: make migrate-create name=create_users_table"; \
		exit 1; \
	fi
	@mkdir -p ./migrations
	docker compose run --rm --user "$(UID):$(GID)" todo-app-postgres-migrate create -ext sql -dir /migrations -seq $(name)

migrate-action:
	docker compose run --rm todo-app-postgres-migrate -path /migrations -database "postgresql://$(POSTGRES_USER):$(POSTGRES_PASSWORD)@todo-app-postgres:5432/$(POSTGRES_DB)?sslmode=disable" $(action)