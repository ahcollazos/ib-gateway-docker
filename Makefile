# Variables principales
IMAGE_NAME=ib-gateway-local
DOCKERFILE=stable/Dockerfile
CONTEXT=stable
CONTAINER_NAME=ib-gateway
PORT=4002
COMPOSE_FILE=docker-compose.yml

.PHONY: build run stop clean logs shell compose-up compose-down compose-logs purge show-dirs

## Build la imagen local usando el Dockerfile en stable/
build:
	@echo "🔨 Construyendo imagen Docker desde $(DOCKERFILE)..."
	docker buildx build --platform=linux/amd64 -t $(IMAGE_NAME) -f $(DOCKERFILE) $(CONTEXT)


## Ejecuta el contenedor en modo local (detached)
run: stop
	@echo "🚀 Ejecutando contenedor en el puerto $(PORT)..."
	docker run -d --rm \
		--name $(CONTAINER_NAME) \
		-p 127.0.0.1:$(PORT):$(PORT) \
		-e TWS_USERID=andresco2024 \
		-e TWS_PASSWORD=1nt3r4ct1v3+2024 \
		-e TRADING_MODE=paper \
		-e READ_ONLY_API=no \
		-e TWOFA_TIMEOUT_ACTION=restart \
		-e RELOGIN_AFTER_2FA_TIMEOUT=yes \
		-e TIME_ZONE=America/Bogota \
		-e IB_GATEWAY_RELEASE_CHANNEL=stable \
		$(IMAGE_NAME)

## Detiene el contenedor (si está corriendo)
stop:
	@echo "🛑 Deteniendo y eliminando contenedor si existe..."
	-@docker rm -f $(CONTAINER_NAME) 2>/dev/null || true

## Elimina la imagen local
clean: stop
	@echo "🧹 Eliminando imagen local..."
	-@docker rmi $(IMAGE_NAME) 2>/dev/null || true

## Muestra los logs del contenedor en tiempo real
logs:
	docker logs -f $(CONTAINER_NAME)

## Abre una shell interactiva dentro del contenedor
shell:
	docker exec -it $(CONTAINER_NAME) /bin/bash

## Ejecuta docker-compose con el archivo por defecto (en la raíz)
compose-up:
	docker-compose -f $(COMPOSE_FILE) up --build -d

compose-down:
	docker-compose -f $(COMPOSE_FILE) down

compose-logs:
	docker-compose -f $(COMPOSE_FILE) logs -f

## Limpiar todo: contenedor, imagen y docker-compose
purge: compose-down clean

# Atajos útiles para desarrollo
show-dirs:
	@echo "Archivos de configuración:"
	@ls -lh stable/config/ibc/config.ini.tmpl
	@ls -lh stable/config/ibgateway/jts.ini.tmpl
	@echo "Scripts disponibles:"
	@ls -lh scripts/ || true
	@ls -lh tws-scripts/ || true
