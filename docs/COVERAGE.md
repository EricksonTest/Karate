# Risk and coverage map

| Requirement | Risk | Evidence | Suite |
|---|---|---|---|
| PC-OWN-001 | High | Register and retrieve the exact owner | Smoke, regression |
| PC-OWN-002 | High | Update contact data and find the owner by surname | Regression |
| PC-OWN-003 | High | Delete the owned record and verify it is unavailable | Regression |
| PC-PET-001 | High | Add a pet to the correct owner | Smoke, regression |
| PC-PET-002 | Medium | Reject a pet for an unknown owner | Regression |
| PC-PET-003 | Medium | Standalone pet collections satisfy their contracts | Smoke, regression |
| PC-PET-004 | High | Correct an owned pet without changing its owner | Serial regression |
| PC-PET-005 | High | Pet deletion should preserve its pet type; currently removes it | Known defect |
| PC-VIS-001 | High | Record and retrieve a visit through its pet relationship | Smoke, regression |
| PC-VIS-002 | Medium | A created visit appears in the global visit collection | Serial regression |
| PC-VIS-003 | High | Updated visits should remain retrievable; currently disappear | Known defect |
| PC-VIS-004 | High | Visit deletion should preserve parent records; currently removes the pet | Known defect |
| PC-CAT-001 | High | Pet-type identities and names are valid and unique | Smoke, regression |
| PC-CAT-002 | Medium | Specialty identities and names are valid and unique | Regression |
| PC-CAT-003 | High | Veterinarians and their specialty collections are valid | Smoke, regression |
| PC-TYPE-001 | Medium | Pet-type create, update, retrieve and delete lifecycle | Serial regression |
| PC-SPEC-001 | Medium | Specialty create, update, retrieve and delete lifecycle | Serial regression |
| PC-VET-001 | High | Veterinarian create, update, retrieve and delete lifecycle | Serial regression |
| PC-PAGE-001 | Medium | Owner results respect requested page bounds | Smoke, regression |
| PC-PAGE-002 | Medium | Oversized page requests should be rejected; currently returns 500 | Known defect |
| PC-PAGE-003 | Medium | Zero page sizes should return 400; currently returns 500 | Known defect |
| PC-PAGE-004 | Medium | Pet results respect requested page bounds | Regression |
| PC-ERR-001 | High | Unknown owners signal absence without returning data | Smoke, regression |
| PC-ERR-002 | High | Unknown owners should return the documented diagnostic body | Known defect |
| PC-VAL-001 | High | Invalid owner identity/contact fields produce validation evidence | Regression |
| PC-VAL-002 | High | Owner field boundary violations produce validation evidence | Regression |
| PC-VAL-003 | High | Invalid telephone length should return 400; currently returns 500 | Known defect |
| PC-HTTP-001 | High | Malformed JSON should return 400; currently returns 500 | Known defect |
| PC-HTTP-002 | Medium | Unsupported media types should return 415; currently returns 500 | Known defect |
| PC-HTTP-003 | Medium | Unsupported methods should return 405; currently returns 500 | Known defect |
| PC-USER-001 | Medium | Blank usernames are rejected without persistence | Regression |
| PC-CONTRACT-001 | High | The deployed OpenAPI document contains every tested resource | Smoke, regression |
| PC-PERF-001 | High | Reference-data reads meet failure and p95 thresholds | Performance |
| PC-PERF-002 | High | Common browsing reads meet failure and p95 thresholds | Performance |

The default gate contains 23 green scenarios. Ten additional `@known-defect` scenarios preserve evidence of contract discrepancies without making every normal build red.

## Observed specification drift

The current implementation returns `201` for several creates and `204 No Content` for several updates and deletes although its OpenAPI document describes `200` responses with bodies. The regression suite verifies deployed behavior and then confirms resulting state. Error-body, protocol-status, telephone-validation, oversized-page, and visit-update discrepancies remain executable `@known-defect` specifications.
