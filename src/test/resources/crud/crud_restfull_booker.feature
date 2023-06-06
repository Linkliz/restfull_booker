Feature: Use the paths for creating, reading and updating the restful-booker rest api

  Background:
    Given url basePath = "https://restful-booker.herokuapp.com/booking"
    * def jsonRequest = read('classpath:json_base/request.json')
    * def jsonResponse = read('classpath:json_base/response.json')

  @CreateBooker
  Scenario:  successfully create a booker
    Given url basePath
    And request jsonRequest[0]
    And header Accept = 'application/json'
    When method post
    Then status 200
    And match response == jsonResponse[0]

  @CreateRemoveAcceptBooker
  Scenario:  Validate an erroneous response by removing the Accept header field
    Given url basePath
    And request jsonRequest[0]
    When method post
    Then status 418
    And match response == "I'm a Teapot"

  @CreateNotSendBodyRequestBooker
  Scenario:  Validate an erroneous response by removing the body request field from the request
    Given url basePath
    And header Accept = 'application/json'
    When method post
    Then status 500
    And match response == "Internal Server Error"

  @GetBooker
  Scenario:  successfully read a booker
    * def resultCreate = call read('/crud_restfull_booker.feature@CreateBooker')

    Given url basePath + '/'+ resultCreate.response.bookingid
    And header Accept = 'application/json'
    When method get
    Then status 200
    And match response == jsonResponse[2]

  @GetRemoveHeaderAcceptBooker
  Scenario: Validate an erroneous response by removing the Accept header field in the get method
    * def resultCreate = call read('/crud_restfull_booker.feature@CreateBooker')

    Given url basePath + '/'+ resultCreate.response.bookingid
    When method get
    Then status 418
    And match response == "I'm a Teapot"

  @GetRemoveParamBooker
  Scenario: Validate an response alternative by removing the param in the path
    * def resultCreate = call read('/crud_restfull_booker.feature@CreateBooker')

    Given url basePath
    And header Accept = 'application/json'
    When method get
    Then status 200
    And match response contains {"bookingid":'#number'}

  @GetBookerWhitIdNotExist
  Scenario Outline:  Validate a wrong response when sending non-existing ids
    * def resultCreate = call read('/crud_restfull_booker.feature@CreateBooker')

    Given url basePath + '/' + '<id>'
    And header Accept = 'application/json'
    When method get
    Then status 404
    And match response == "Not Found"

    Examples:
      | id        |
      | 0         |
      | 100000000 |

  @UpdateBooker
  Scenario:  successfully update a booker
    * def result = call read('/auth_create_token_snippet.feature@GenerateToken')
    * def resultCreate = call read('/crud_restfull_booker.feature@CreateBooker')

    Given url basePath + '/'+ resultCreate.response.bookingid
    And request jsonRequest[2]
    And header Accept = 'application/json'
    And header Cookie = 'token=' + result.response.token
    When method put
    Then status 200
    And match response == jsonResponse[1]

  @UpdateWrongTokenBooker
  Scenario:  Validate a wrong response by sending a wrong token
    * def resultCreate = call read('/crud_restfull_booker.feature@CreateBooker')

    Given url basePath + '/'+ resultCreate.response.bookingid
    And request jsonRequest[2]
    And header Accept = 'application/json'
    And header Cookie = 'token=' + '156946325'
    When method put
    Then status 403
    And match response == "Forbidden"

  @UpdateRemoveAcceptHeaderBooker
  Scenario: Validate an erroneous response by removing the Accept header field in the put request
    * def result = call read('/auth_create_token_snippet.feature@GenerateToken')
    * def resultCreate = call read('/crud_restfull_booker.feature@CreateBooker')

    Given url basePath + '/'+ resultCreate.response.bookingid
    And request jsonRequest[2]
    And header Cookie = 'token=' + result.response.token
    When method put
    Then status 418
    And match response == "I'm a Teapot"

  @UpdateSendNotExistIdBooker
  Scenario: Validate a wrong response when sending a non-existing id in the put request
    * def result = call read('/auth_create_token_snippet.feature@GenerateToken')
    * def resultCreate = call read('/crud_restfull_booker.feature@CreateBooker')

    Given url basePath + '/10000000'
    And request jsonRequest[2]
    And header Accept = 'application/json'
    And header Cookie = 'token=' + result.response.token
    When method put
    Then status 405
    And match response == "Method Not Allowed"

