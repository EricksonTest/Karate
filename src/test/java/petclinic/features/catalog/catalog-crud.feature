@catalog @destructive @serial
Feature: Administrators can safely maintain PetClinic reference data

  Background:
    * url baseUrl
    * assert allowDestructive
    * def data = call read('classpath:petclinic/support/data.js')
    * def schemas = call read('classpath:petclinic/support/schemas.js')
    * def ownedResources = []
    * configure afterScenario = function(){ karate.call('classpath:petclinic/support/resource-cleanup.feature', { baseUrl: baseUrl, resources: ownedResources }) }

  @req=PC-TYPE-001 @risk=medium @regression
  Scenario: A pet type can be created, renamed, retrieved and removed
    * def createdType = data.petType()
    Given path 'pettypes'
    And request createdType
    When method post
    Then status 201
    And match response == schemas.petType
    And match response.name == createdType.name
    * def typeId = response.id
    * eval ownedResources.push({ path: 'pettypes', id: typeId })

    * def renamedType = { id: '#(typeId)', name: '#("renamed" + createdType.name)' }
    Given path 'pettypes', typeId
    And request renamedType
    When method put
    Then status 204
    And match response == ''

    Given path 'pettypes', typeId
    When method get
    Then status 200
    And match response == renamedType

    Given path 'pettypes', typeId
    When method delete
    Then status 204
    And match response == ''

    Given path 'pettypes', typeId
    When method get
    Then status 404

  @req=PC-SPEC-001 @risk=medium @regression
  Scenario: A veterinary specialty can be created, renamed and removed
    * def createdSpecialty = data.specialty()
    Given path 'specialties'
    And request createdSpecialty
    When method post
    Then status 201
    And match response == schemas.specialty
    * def specialtyId = response.id
    * eval ownedResources.push({ path: 'specialties', id: specialtyId })

    * def renamedSpecialty = { id: '#(specialtyId)', name: '#("renamed" + createdSpecialty.name)' }
    Given path 'specialties', specialtyId
    And request renamedSpecialty
    When method put
    Then status 204
    And match response == ''

    Given path 'specialties', specialtyId
    When method get
    Then status 200
    And match response == renamedSpecialty

    Given path 'specialties', specialtyId
    When method delete
    Then status 204
    And match response == ''

  @req=PC-VET-001 @risk=high @regression
  Scenario: A veterinarian can be created, updated and removed with a valid specialty
    Given path 'specialties'
    When method get
    Then status 200
    And assert response.length > 0
    * def specialty = karate.filter(response, function(x){ return x.id <= 3 })[0]
    * def createdVet = data.vet([specialty])

    Given path 'vets'
    And request createdVet
    When method post
    Then status 201
    And match response == schemas.vet
    And match response contains createdVet
    * def vetId = response.id
    * eval ownedResources.push({ path: 'vets', id: vetId })

    * def updatedVet = { id: '#(vetId)', firstName: 'Karate', lastName: 'Updated', specialties: '#([specialty])' }
    Given path 'vets', vetId
    And request updatedVet
    When method put
    Then status 204
    And match response == ''

    Given path 'vets', vetId
    When method get
    Then status 200
    And match response == updatedVet

    Given path 'vets', vetId
    When method delete
    Then status 204
    And match response == ''
