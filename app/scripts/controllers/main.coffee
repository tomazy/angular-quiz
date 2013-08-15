angular.module('quizApp')

  .controller 'MainCtrl', ($scope, currentUser, DB, $log) ->
    $scope.questions = []
    $scope.db = DB.conn
    $scope.user = currentUser
    $scope.status = "Loading questions. Please wait..."

    DB.requestQuestions().then (questions) ->
      $scope.questions = questions
      $scope.status = null

    $scope.submitResponse = ->
      $scope.processing = true

      response = {}
      for q in $scope.questions
        response[q.name] = {}
        for o in q.options
          response[q.name][o.value] = o.checked || false

      DB.submitResponse(currentUser.id, response)
        .then ->
          $scope.success = "Thanks for submitting the response!"
        , (error) ->
          $scope.error = "Failed to save the response: #{error}"
          $log.error(error)

      $scope
