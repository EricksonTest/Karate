.DEFAULT_GOAL := help

MVNW := ./mvnw
HEALTH_URL := http://localhost:9966/petclinic/actuator/health

.PHONY: help up wait smoke test performance demo down reports

help:
	@echo "make up           Start the pinned PetClinic container"
	@echo "make smoke        Run the fast smoke suite"
	@echo "make test         Run all default functional coverage"
	@echo "make performance  Run the Gatling performance gate"
	@echo "make demo         Start PetClinic and run both gates"
	@echo "make down         Stop PetClinic"
	@echo "make reports      Print generated report locations"

up:
	docker compose up -d --wait

wait:
	@./scripts/wait-for-petclinic.sh "$(HEALTH_URL)"

smoke: wait
	$(MVNW) test -Dkarate.tags=@smoke

test: wait
	$(MVNW) clean test

performance: wait
	$(MVNW) test-compile gatling:test

demo: up test performance reports

down:
	docker compose down

reports:
	@echo "Karate parallel: target/karate-reports/parallel/karate-summary.html"
	@echo "Karate serial:   target/karate-reports/serial/karate-summary.html"
	@echo "Gatling: target/gatling/<latest-run>/index.html"
