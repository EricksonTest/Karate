@performance
Feature: Common browsing endpoints remain responsive under representative load

  Background:
    * url baseUrl

  @req=PC-PERF-002 @risk=high
  Scenario: A consumer browses owners, pets and specialties
    Given path 'v2', 'owners'
    And param page = 0
    And param size = 5
    When method get
    Then status 200
    And match response.content == '#[]'

    Given path 'v2', 'pets'
    And param page = 0
    And param size = 5
    When method get
    Then status 200
    And match response.content == '#[]'

    Given path 'specialties'
    When method get
    Then status 200
    And match response == '#[]'
    And assert response.length > 0
