help:
	@echo "\nCommands:"
	@echo "\t help \t show help"
	@echo "\t kong-db \t make kong database"
	@echo "\t kong-migration \t make kong migration"
	@echo "\t kong-app \t make kong application"
	@echo "\t kong-build \t to build all konga enviroment"
	@echo "\t grafana-build \t to build prometheus + grafana"

kong-db:
	@docker-compose up -d kong-db

kong-migration:
	@docker-compose up kong-migration
	@docker-compose up konga-migration
	@docker rm kong-migration
	@docker rm konga-migration

kong-app:
	@docker-compose up -d kong-app
	@docker-compose up -d konga-app

kong-build:
	@make kong-db
	@make kong-migration
	@make kong-app

grafana-build:
	@curl -s -X POST http://localhost:9001/plugins/ --data "name=prometheus" --data "config.per_consumer=true" --data "config.status_code_metrics=true" --data "config.latency_metrics=true" --data "config.bandwidth_metrics=true" --data "config.upstream_health_metrics=true"
	@docker-compose up -d prometheus-app
	@docker-compose up -d grafana-app