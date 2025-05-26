# Variables principales
IMAGE_NAME=ib-gateway-local
DOCKERFILE=stable/Dockerfile
CONTEXT=stable
CONTAINER_NAME=ib-gateway
PORT=4002
COMPOSE_FILE=docker-compose.yml

.PHONY: compose-up compose-down compose-logs purge show-dirs

compose-up:
	docker compose -f $(COMPOSE_FILE) up --build -d

compose-down:
	docker compose -f $(COMPOSE_FILE) down

compose-logs:
	docker compose -f $(COMPOSE_FILE) logs -f

purge: compose-down
	docker system prune -af

show-dirs:
	@echo "Archivos de configuración:"
	@ls -lh stable/config/ibc/config.ini.tmpl
	@ls -lh stable/config/ibgateway/jts.ini.tmpl
	@echo "Scripts disponibles:"
	@ls -lh scripts/ || true
	@ls -lh tws-scripts/ || true