@pets @visits @serial
Feature: Pets and visits can be queried and maintained through their standalone resources

  Background:
    * url baseUrl
    * def data = call read('classpath:petclinic/support/data.js')
    * def schemas = call read('classpath:petclinic/support/schemas.js')
    * def ownedOwnerIds = []
    * def ownedResources = []
    * configure afterScenario = function(){ karate.call('classpath:petclinic/support/cleanup.feature', { baseUrl: baseUrl, ownerIds: ownedOwnerIds }); karate.call('classpath:petclinic/support/resource-cleanup.feature', { baseUrl: baseUrl, resources: ownedResources }) }

  @req=PC-PET-003 @risk=medium @smoke @regression
  Scenario: The standalone pet collection satisfies its contract
    Given path 'pets'
    When method get
    Then status 200
    And match each response == schemas.pet

  @req=PC-VIS-002 @risk=medium @regression @destructive
  Scenario: A created visit appears in the standalone visit collection
    * assert allowDestructive
    Given path 'owners'
    And request data.owner()
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
    * def petId = response.id

    Given path 'owners', ownerId, 'pets', petId, 'visits'
    And request data.visit()
    When method post
    Then status 201
    * def visitId = response.id

    Given path 'visits'
    When method get
    Then status 200
    And match each response == schemas.visit
    And match response[*].id contains visitId

  @req=PC-PAGE-004 @risk=medium @regression
  Scenario: Consumers can request a bounded page of pets
    Given path 'v2', 'pets'
    And param page = 0
    And param size = 3
    When method get
    Then status 200
    And match response == schemas.page
    And match response.page == 0
    And match response.size == 3
    And assert response.content.length <= 3

  @req=PC-PET-004 @risk=high @regression @destructive
  Scenario: A pet can be corrected without affecting its owner association
    * assert allowDestructive
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
    * def petId = response.id

    * def correctedPet = { name: 'Corrected', birthDate: '2021-02-16', type: '#(petType)' }
    Given path 'owners', ownerId, 'pets', petId
    And request correctedPet
    When method put
    Then status 204

    Given path 'pets', petId
    When method get
    Then status 200
    And match response contains correctedPet
    And match response.ownerId == ownerId

    Given path 'owners', ownerId
    When method get
    Then status 200
    And match response.pets[*].id contains petId

  @req=PC-PET-005 @risk=high @known-defect @destructive
  Scenario: Removing a pet should not remove its pet type
    * assert allowDestructive
    * def temporaryType = data.petType()
    Given path 'pettypes'
    And request temporaryType
    When method post
    Then status 201
    * def typeId = response.id
    * def petType = response
    * eval ownedResources.push({ path: 'pettypes', id: typeId })

    Given path 'owners'
    And request data.owner()
    When method post
    Then status 201
    * def ownerId = response.id
    * eval ownedOwnerIds.push(ownerId)

    Given path 'owners', ownerId, 'pets'
    And request data.pet(petType)
    When method post
    Then status 201
    * def petId = response.id

    Given path 'pets', petId
    When method delete
    Then status 204

    Given path 'pettypes', typeId
    When method get
    Then status 200
    And match response.id == typeId

  @req=PC-VIS-003 @risk=high @known-defect @destructive
  Scenario: A corrected visit should remain retrievable from its pet
    * assert allowDestructive
    Given path 'owners'
    And request data.owner()
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
    * def petId = response.id

    Given path 'owners', ownerId, 'pets', petId, 'visits'
    And request data.visit()
    When method post
    Then status 201
    * def visitId = response.id

    * def correctedVisit = { date: '2024-07-01', description: 'Corrected visit reason' }
    Given path 'visits', visitId
    And request correctedVisit
    When method put
    Then status 204
    And match response == ''

    Given path 'visits', visitId
    When method get
    Then status 200
    And match response contains correctedVisit
    And match response.petId == petId

    Given path 'visits', visitId
    When method delete
    Then status 204
    And match response == ''

    Given path 'visits', visitId
    When method get
    Then status 404

  @req=PC-VIS-004 @risk=high @known-defect @destructive
  Scenario: Removing a visit should not remove its pet or owner
    * assert allowDestructive
    Given path 'owners'
    And request data.owner()
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
    * def petId = response.id

    Given path 'owners', ownerId, 'pets', petId, 'visits'
    And request data.visit()
    When method post
    Then status 201
    * def visitId = response.id

    Given path 'visits', visitId
    When method delete
    Then status 204
    And match response == ''

    Given path 'visits', visitId
    When method get
    Then status 404

    Given path 'pets', petId
    When method get
    Then status 200
    And match response.ownerId == ownerId
