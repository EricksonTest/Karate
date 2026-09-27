@owners @validation
Feature: Owner input boundaries are rejected with useful diagnostics

  Background:
    * url baseUrl
    * assert allowDestructive
    * def data = call read('classpath:petclinic/support/data.js')
    * def schemas = call read('classpath:petclinic/support/schemas.js')

  @req=PC-VAL-002 @risk=high @regression @destructive
  Scenario Outline: Invalid owner field <field> is rejected
    * def invalidOwner = data.owner()
    * def invalidValues = { firstName: '', lastName: 'Owner123', address: '' }
    * eval invalidOwner[field] = invalidValues[field]
    Given path 'owners'
    And request invalidOwner
    When method post
    Then status 400
    And match response == schemas.problem
    And match response.status == 400
    And assert response.schemaValidationErrors.length > 0

    Examples:
      | field       |
      | firstName   |
      | lastName    |
      | address     |

  @req=PC-VAL-003 @risk=high @known-defect @destructive
  Scenario: An invalid telephone should be rejected as a client error
    * def invalidOwner = data.owner()
    * set invalidOwner.telephone = '123'
    Given path 'owners'
    And request invalidOwner
    When method post
    Then status 400
    And match response == schemas.problem
    And match response.status == 400
