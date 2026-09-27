# Client demonstration guide

## Objective

Demonstrate that the framework produces fast business feedback, protects shared environments, captures known defects, and reuses the same Karate journeys for functional and performance evidence.

## Before the meeting

```bash
docker info
./mvnw --version
make demo
```

Keep the parallel Karate report, serial Karate report, and latest Gatling report open in browser tabs.

## Suggested 15-minute walkthrough

1. **Business language (2 minutes)** — open an owner or pet feature and show `Given`, `When`, and `Then`, plus `@req` and `@risk` traceability.
2. **Architecture (2 minutes)** — explain that Gherkin owns behavior, Java owns execution, JavaScript owns configuration/data/schema helpers, and Scala owns load shape only.
3. **Fast feedback (2 minutes)** — run `make smoke` and open the parallel report.
4. **Isolation (2 minutes)** — show unique data generation, scenario-owned cleanup, localhost destructive-test protection, and the `@serial` treatment of shared catalog mutations.
5. **Defect evidence (2 minutes)** — show the coverage matrix and one `@known-defect` scenario. Explain why known defects are executable but excluded from the default green gate.
6. **Performance (3 minutes)** — show the two Gatling journeys, 100 requests, zero failures, p95 threshold, and HTML report.
7. **Delivery (2 minutes)** — show the pinned Docker image, Maven Wrapper, Makefile, and GitHub Actions artifact uploads.

## Useful commands

```bash
make smoke
make test
make performance
./mvnw test -Dkarate.tags=@req=PC-OWN-001
./mvnw test -Dkarate.tags=@known-defect
./mvnw test-compile gatling:test -Dgatling.users=50 -Dgatling.rampSeconds=30
```

The known-defect command is intentionally expected to fail while those product defects remain unresolved.
