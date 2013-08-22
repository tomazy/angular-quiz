angular.module('quizApp')
  .factory 'CredentialsValidator', ->

    service =
      validate: (data, onError) ->
        result = true

        unless data.email
          onError "Invalid email"
          result = false

        unless data.password
          onError "Invalid password"
          result = false

        result

