@pets @visits
Feature: A pet and its visits remain associated with the correct owner

  Background:
    * url baseUrl
    * assert allowDestructive
    * def data = call read('classpath:petclinic/support/data.js')
    * def schemas = call read('classpath:petclinic/support/schemas.js')
    * def ownedOwnerIds = []
    * def ownedResources = []
    * configure afterScenario = function(){ karate.call('classpath:petclinic/support/cleanup.feature', { baseUrl: baseUrl, ownerIds: ownedOwnerIds }); karate.call('classpath:petclinic/support/resource-cleanup.feature', { baseUrl: baseUrl, resources: ownedResources }) }

  @req=PC-PET-001 @req=PC-VIS-001 @risk=high @smoke @regression @destructive
  Scenario: A receptionist can add a pet and record its veterinary visit
    * def newOwner = data.owner()
    Given path 'owners'
    And request newOwner
    When method post
    Then status 201
    * def ownerId = response.id
    * eval ownedOwnerIds.push(ownerId)

    Given path 'pettypes'
    And request data.petType()
    When method post
    Then status 201
    * def petType = response
    * eval ownedResources.push({ path: 'pettypes', id: petType.id })

    * def newPet = data.pet(petType)
    Given path 'owners', ownerId, 'pets'
    And request newPet
    When method post
    Then status 201
    And match response == schemas.pet
    And match response contains newPet
    And match response.ownerId == ownerId
    * def petId = response.id

    * def newVisit = data.visit()
    Given path 'owners', ownerId, 'pets', petId, 'visits'
    And request newVisit
    When method post
    Then status 201
    And match response == schemas.visit
    And match response contains newVisit
    And match response.petId == petId
    * def visitId = response.id

    Given path 'owners', ownerId
    When method get
    Then status 200
    And match response.pets[*].id contains petId
    * def savedPet = karate.filter(response.pets, function(x){ return x.id == petId })[0]
    And match savedPet.ownerId == ownerId
    And match savedPet.visits[*].id contains visitId
    And match savedPet.visits[*].description contains newVisit.description

  @req=PC-PET-002 @risk=medium @regression @destructive
  Scenario: A pet cannot be added for an owner that does not exist
    Given path 'pettypes'
    When method get
    Then status 200
    And assert response.length > 0
    * def seededType = karate.filter(response, function(x){ return x.id <= 6 })[0]
    * def newPet = data.pet(seededType)

    Given path 'owners', 99999999, 'pets'
    And request newPet
    When method post
    Then status 404
    And match response == ''
