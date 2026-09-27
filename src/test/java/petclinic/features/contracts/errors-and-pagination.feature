@contracts
Feature: Consumers receive bounded collections and diagnostic error responses

  Background:
    * url baseUrl
    * def data = call read('classpath:petclinic/support/data.js')
    * def schemas = call read('classpath:petclinic/support/schemas.js')

  @req=PC-PAGE-001 @risk=medium @smoke @regression
  Scenario: Consumers can request a bounded page of owners
    Given path 'v2', 'owners'
    And param page = 0
    And param size = 3
    When method get
    Then status 200
    And match response ==
      """
      {
        content: '#[]',
        page: 0,
        size: 3,
        totalElements: '#number',
        totalPages: '#number'
      }
      """
    * assert response.content.length <= 3
    * assert response.totalElements >= response.content.length
    * assert response.totalPages == Math.ceil(response.totalElements / response.size)

  @req=PC-ERR-001 @risk=high @smoke @regression
  Scenario: Looking up an unknown owner signals absence without exposing data
    Given path 'owners', 99999999
    When method get
    Then status 404
    And match response == ''
    And match header Content-Length == '0'

  @req=PC-ERR-002 @risk=high @known-defect
  Scenario: Looking up an unknown owner should return the documented diagnostic contract
    Given path 'owners', 99999999
    When method get
    Then status 404
    And match response == schemas.problem
    And match response.status == 404

  @req=PC-VAL-001 @risk=high @regression @destructive
  Scenario: Invalid owner data is rejected with validation evidence
    * assert allowDestructive
    * def invalidOwner = data.owner()
    * set invalidOwner.firstName = ''
    * set invalidOwner.telephone = 'not-a-number'
    Given path 'owners'
    And request invalidOwner
    When method post
    Then status 400
    And match response == schemas.problem
    And match response.status == 400
    And assert response.schemaValidationErrors.length > 0

  @req=PC-PAGE-002 @risk=medium @known-defect
  Scenario: An invalid page size is rejected instead of returning an unbounded result
    Given path 'v2', 'owners'
    And param page = 0
    And param size = 101
    When method get
    Then status 400
    And match response == schemas.problem
    And match response.status == 400
