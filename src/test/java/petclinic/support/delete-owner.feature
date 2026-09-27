Feature: Owner cleanup infrastructure client

  Scenario:
    Given url baseUrl
    And path 'owners', ownerId
    When method delete

