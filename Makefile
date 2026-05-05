include .env
export

export PROJECT_ROOT=$(shell pwd)

.PHONY: setUp tearDown clear

setUp:
	docker compose up -d

tearDown:
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