@performance
Feature: Read-only reference endpoints remain responsive under representative load

  Background:
    * url baseUrl

  @req=PC-PERF-001 @risk=high
  Scenario: A consumer reads the reference data needed to book care
    Given path 'pettypes'
    When method get
    Then status 200
    And match response == '#[]'
    And assert response.length > 0

    Given path 'vets'
    When method get
    Then status 200
    And match response == '#[]'
    And assert response.length > 0
