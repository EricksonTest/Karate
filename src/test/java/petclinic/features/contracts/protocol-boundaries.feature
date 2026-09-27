@contracts @negative
Feature: The API rejects malformed and unsupported requests predictably

  Background:
    * url baseUrl
    * def schemas = call read('classpath:petclinic/support/schemas.js')

  @req=PC-HTTP-001 @risk=high @known-defect
  Scenario: Malformed JSON is rejected as a client error
    Given path 'owners'
    And header Content-Type = 'application/json'
    And request '{ "firstName": "Broken" '
    When method post
    Then status 400
    And match response.status == 400

  @req=PC-HTTP-002 @risk=medium @known-defect
  Scenario: Unsupported request media types are rejected
    Given path 'owners'
    And header Content-Type = 'text/plain'
    And request 'plain text is not an owner'
    When method post
    Then status 415
    And match response.status == 415

  @req=PC-PAGE-003 @risk=medium @known-defect
  Scenario: A zero page size is rejected
    Given path 'v2', 'owners'
    And param page = 0
    And param size = 0
    When method get
    Then status 400
    And match response == schemas.problem

  @req=PC-HTTP-003 @risk=medium @known-defect
  Scenario: Unsupported HTTP methods are rejected
    Given path 'owners'
    When method patch
    Then status 405
    And match response.status == 405
