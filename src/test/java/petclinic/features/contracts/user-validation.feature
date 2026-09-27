@users @validation
Feature: User administration validates identity data before persistence

  Background:
    * url baseUrl
    * assert allowDestructive
    * def data = call read('classpath:petclinic/support/data.js')
    * def schemas = call read('classpath:petclinic/support/schemas.js')

  @req=PC-USER-001 @risk=medium @regression @destructive
  Scenario: A blank username is rejected without creating a user
    * def invalidUser = data.user()
    * set invalidUser.username = ''
    Given path 'users'
    And request invalidUser
    When method post
    Then status 400
    And match response == schemas.problem
