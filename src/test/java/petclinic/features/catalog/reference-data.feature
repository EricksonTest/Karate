@catalog @readonly
Feature: Clinical reference data is complete and structurally usable

  Background:
    * url baseUrl
    * def data = call read('classpath:petclinic/support/data.js')
    * def schemas = call read('classpath:petclinic/support/schemas.js')

  @req=PC-CAT-001 @risk=high @smoke @regression
  Scenario: Supported pet types have valid unique identities and names
    Given path 'pettypes'
    When method get
    Then status 200
    And match response == '#[]'
    And assert response.length > 0
    And match each response == schemas.petType
    * def ids = karate.map(response, function(x){ return x.id })
    * def names = karate.map(response, function(x){ return x.name })
    * assert data.distinct(ids)
    * assert data.distinct(names)

  @req=PC-CAT-002 @risk=medium @regression
  Scenario: Veterinary specialties have valid unique identities and names
    Given path 'specialties'
    When method get
    Then status 200
    And match response == '#[]'
    And assert response.length > 0
    And match each response == schemas.specialty
    * def ids = karate.map(response, function(x){ return x.id })
    * def names = karate.map(response, function(x){ return x.name })
    * assert data.distinct(ids)
    * assert data.distinct(names)

  @req=PC-CAT-003 @risk=high @smoke @regression
  Scenario: Every listed veterinarian has an identity and valid specialties
    Given path 'vets'
    When method get
    Then status 200
    And match response == '#[]'
    And assert response.length > 0
    And match each response == schemas.vet
    And match each response[*].specialties[*] == schemas.specialty
    * def ids = karate.map(response, function(x){ return x.id })
    * assert data.distinct(ids)
