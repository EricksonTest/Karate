# Spring PetClinic REST — Karate Test Framework

Risk-focused functional and performance coverage for [Spring PetClinic REST](https://github.com/spring-petclinic/spring-petclinic-rest).

The repository is designed as a reproducible client demonstration: PetClinic is pinned to version `4.0.2`, Maven is supplied through the Wrapper, test data is scenario-owned, shared-state scenarios are isolated, known product defects remain executable, and CI publishes both Karate and Gatling evidence.

| Language | Responsibility |
|---|---|
| Gherkin | Business behavior and requirement/risk metadata |
| Java | JUnit execution policy and parallel/serial orchestration |
| JavaScript | Environment configuration, data builders and response schemas |
| Scala | Gatling user injection and performance thresholds only |

## Prerequisites

- JDK 17 or newer
- Docker Desktop with Compose
- `curl`

You do not need to install Maven separately.

## One-command demonstration

Start the pinned application, wait for readiness, execute 23 functional scenarios, run the 100-request performance gate, and print the report locations:

```bash
make demo
```

Stop the application afterward:

```bash
make down
```

## Individual commands

```bash
make up
make smoke
make test
make performance
```

Equivalent direct commands are:

```bash
docker compose up -d --wait
./mvnw clean test
./mvnw test -Dkarate.tags=@smoke
./mvnw test -Dkarate.tags=@req=PC-OWN-001
./mvnw test-compile gatling:test
```

The Java runner automatically executes parallel-safe coverage on four threads, then executes `@serial` shared-state scenarios on one thread.

## Known defects

Ten specifications capture intended behavior that PetClinic `4.0.2` currently violates. They are excluded from the normal green gate. Execute them deliberately with:

```bash
./mvnw test -Dkarate.tags=@known-defect
```

This command is expected to fail until the corresponding application defects are fixed. See [the coverage map](docs/COVERAGE.md) for the exact discrepancies.

## Performance profiles

The default Scala simulation runs two journeys concurrently:

- Reference data: pet types and veterinarians
- Browsing: paged owners, paged pets and specialties

Each journey ramps 20 users over 10 seconds, producing 100 requests. The gate requires zero failed requests and a global p95 below 750 ms.

Override the profile without editing source:

```bash
./mvnw test-compile gatling:test \
  -Dgatling.users=50 \
  -Dgatling.rampSeconds=30
```

## Reports

- Parallel functional report: `target/karate-reports/parallel/karate-summary.html`
- Serial functional report: `target/karate-reports/serial/karate-summary.html`
- JUnit XML: `target/surefire-reports/`
- Gatling: `target/gatling/<latest-run>/index.html`

## Environment configuration

The default target is `http://localhost:9966/petclinic/api`.

Read-only coverage can target another environment without source changes:

```bash
PETCLINIC_BASE_URL=https://petclinic.test.example/api \
./mvnw test -Dkarate.tags=@smoke
```

Mutating scenarios refuse non-local targets unless the caller explicitly identifies the target as disposable:

```bash
PETCLINIC_BASE_URL=https://disposable.example/api \
PETCLINIC_ALLOW_DESTRUCTIVE=true \
./mvnw test
```

## Rider

Open the repository root, select JDK 17 or newer, and let Rider import `pom.xml`. Run `PetClinicRunner` for functional coverage or use the terminal commands above. The Maven Wrapper ensures Rider, local terminals and CI use the same Maven version.

## Documentation

- [Risk and requirement coverage](docs/COVERAGE.md)
- [Architecture and contribution rules](docs/ARCHITECTURE.md)
- [Client demonstration guide](docs/CLIENT-DEMO.md)

Karate `1.5.2` is intentional because this project demonstrates a Scala-based Gatling simulation. Karate 2.x uses Java-based performance profiles; migrate when Scala is no longer a requirement.
