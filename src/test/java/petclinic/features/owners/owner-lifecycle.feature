@owners
Feature: Pet owners can be managed without affecting unrelated records

  Background:
    * url baseUrl
    * assert allowDestructive
    * def data = call read('classpath:petclinic/support/data.js')
    * def schemas = call read('classpath:petclinic/support/schemas.js')
    * def ownedOwnerIds = []
    * configure afterScenario = function(){ karate.call('classpath:petclinic/support/cleanup.feature', { baseUrl: baseUrl, ownerIds: ownedOwnerIds }) }

  @req=PC-OWN-001 @risk=high @smoke @regression @destructive
  Scenario: A receptionist can register and retrieve a new owner
    * def newOwner = data.owner()
    Given path 'owners'
    And request newOwner
    When method post
    Then status 201
    And match response == schemas.owner
    And match response contains newOwner
    And match response.pets == []
    * def ownerId = response.id
    * eval ownedOwnerIds.push(ownerId)

    Given path 'owners', ownerId
    When method get
    Then status 200
    And match response == schemas.owner
    And match response contains newOwner

  @req=PC-OWN-002 @risk=high @regression @destructive
  Scenario: An owner's contact details can be corrected and found by surname
    * def original = data.owner()
    Given path 'owners'
    And request original
    When method post
    Then status 201
    * def ownerId = response.id
    * eval ownedOwnerIds.push(ownerId)

    * def updated = data.owner()
    * set updated.firstName = original.firstName
    * set updated.lastName = original.lastName
    * set updated.city = 'Cambridge'
    * set updated.telephone = '0207946000'
    Given path 'owners', ownerId
    And request updated
    When method put
    Then status 204
    And match response == ''

    Given path 'owners'
    And param lastName = updated.lastName
    When method get
    Then status 200
    And match response == '#[1]'
    And match response[0] contains updated
    And match response[0].id == ownerId

  @req=PC-OWN-003 @risk=high @regression @destructive
  Scenario: Removing an owner makes that exact owner unavailable
    * def newOwner = data.owner()
    Given path 'owners'
    And request newOwner
    When method post
    Then status 201
    * def ownerId = response.id
    * eval ownedOwnerIds.push(ownerId)

    Given path 'owners', ownerId
    When method delete
    Then status 204
    And match response == ''

    Given path 'owners', ownerId
    When method get
    Then status 404
    And match response == ''
