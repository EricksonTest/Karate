# Framework architecture

## Design intent

The framework converts PetClinic risks into independent executable evidence. Feature files describe domain outcomes; support features own infrastructure operations; Java owns execution policy; JavaScript owns data construction and boundary schemas; Scala owns only the load profile.

## Layers

```text
Risk and requirement tags
        ↓
Business feature scenarios
        ↓
Domain data and assertions
        ↓
Reusable cleanup/infrastructure features
        ↓
Spring PetClinic REST API
```

The layers are deliberately small. Karate already supplies the HTTP client, scenario context, assertions, and reporting, so wrapping those stable capabilities would add indirection without reducing risk.

## Decisions

- Every mutating scenario creates uniquely named records and registers them for `afterScenario` cleanup.
- Cleanup deletes only IDs created by that scenario and accepts successful `200`/`204` responses plus `404` to remain idempotent. Owner cleanup has one bounded retry for a demonstrated PetClinic cascade race.
- Destructive tests are allowed automatically only for localhost. A remote disposable target requires `PETCLINIC_ALLOW_DESTRUCTIVE=true`.
- Fixed domain dates are used because the tested behavior is unrelated to the current clock.
- Generated identifiers are visible in Karate request/response reports and correlated by `X-Test-Run-Id`.
- Read-only smoke and performance tests are separated from destructive regression coverage.
- Parallel-safe scenarios run on four threads. Catalog CRUD and global pet/visit mutation carry `@serial` and run afterward on one thread because the demo application mutates shared reference state.
- Pet scenarios select seeded reference IDs instead of collection position, preventing temporary parallel test data from becoming a dependency.
- `@known-defect` scenarios express the intended contract and remain excluded from the default green build.
- Retrying failed assertions is intentionally unsupported. Eventual consistency should use bounded polling only when the product contract requires it.

## Adding coverage

1. Start from a requirement and product risk.
2. Add `@req=...`, `@risk=...`, and an execution-suite tag.
3. Express an observable domain outcome, not a generic HTTP procedure.
4. Create the minimum data the scenario owns.
5. Assert identity, state, relationships, and non-effects where relevant.
6. Register owned mutable records for cleanup before making further assertions.
7. Run the scenario alone and then with four parallel threads.
