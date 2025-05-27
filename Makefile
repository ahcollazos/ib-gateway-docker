.PHONY: compose-up compose-down compose-logs purge show-dirs

compose-up:
	docker compose -f docker-compose.yml up --build -d

compose-down:
	docker compose -f docker-compose.yml down

compose-logs:
	docker compose -f docker-compose.yml logs -f

purge: compose-down
	docker system prune -af

show-dirs:
	@echo "Archivos de configuración:"
	@ls -lh stable/config/ibc/config.ini.tmpl
	@ls -lh stable/config/ibgateway/jts.ini.tmpl
	@echo "Scripts disponibles:"
	@ls -lh scripts/ || true
	@ls -lh tws-scripts/ || true