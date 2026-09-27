Feature: Generic owned-resource cleanup client

  Scenario:
    Given url baseUrl
    And path resourcePath, resourceId
    When method delete
