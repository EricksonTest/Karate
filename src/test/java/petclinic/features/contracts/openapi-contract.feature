@contracts @openapi
Feature: The deployed service publishes the API surface expected by consumers

  Background:
    * def apiDocsUrl = baseUrl.replace(/\/api$/, '/v3/api-docs')

  @req=PC-CONTRACT-001 @risk=high @smoke @regression
  Scenario: The live OpenAPI document contains every tested resource
    Given url apiDocsUrl
    When method get
    Then status 200
    And match response.openapi == '#regex 3\\..+'
    * def expectedPaths = ['/api/owners', '/api/v2/owners', '/api/owners/{ownerId}', '/api/owners/{ownerId}/pets', '/api/owners/{ownerId}/pets/{petId}', '/api/owners/{ownerId}/pets/{petId}/visits', '/api/pets', '/api/v2/pets', '/api/pets/{petId}', '/api/visits', '/api/visits/{visitId}', '/api/pettypes', '/api/pettypes/{petTypeId}', '/api/specialties', '/api/specialties/{specialtyId}', '/api/vets', '/api/vets/{vetId}', '/api/users']
    * def missingPaths = karate.filter(expectedPaths, function(p){ return response.paths[p] == null })
    And match missingPaths == []
