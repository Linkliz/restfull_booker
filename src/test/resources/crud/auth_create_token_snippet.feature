Feature: Be able to generate a token for updating a booker

  Background:
    * def jsonRequest = read('classpath:json_base/request.json')

  @GenerateToken
  Scenario: Generate Token for to use for access to the put booking
    When url 'https://restful-booker.herokuapp.com/auth'
    And request jsonRequest[1]
    When method post
    Then status 200
