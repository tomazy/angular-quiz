angular.module('quizApp')

  .controller 'MainCtrl', ($scope, currentUser, Quiz, Flash, $q, $log) ->
    $scope.disabled = false
    $scope.questions = false

    $scope.status = "Loading questions. Please wait..."

    init = []
    init.push Quiz.loadQuestions().then (questions) ->
      $scope.questions = questions

    init.push Quiz.loadResponse(currentUser.id).then (response) ->
      $scope.response = response
      $scope.disabled = response != null

    $q.all(init)
      .then ->
        if response = $scope.response
          for q in $scope.questions
            if r = response[q.name]
              for o in q.options
                o.checked = r[o.value]
        null

      .then ->
        $scope.status = null

    $scope.showCorrectAnswers = ->
      Quiz.loadAnswers().then (answers) ->
        for q in $scope.questions
          if correct = answers[q.name]
            for o in q.options
              o.correct = correct[o.value]
              if o.checked and !o.correct
                o.invalid = true
              if !!o.checked != o.correct
                q.invalid = true
        $scope

    $scope.submitResponse = ->
      $scope.processing = true

      Flash.now.reset()

      response = {}
      for q in $scope.questions
        response[q.name] = {}
        for o in q.options
          response[q.name][o.value] = o.checked || false

      Quiz.submitResponse(currentUser.id, response)
        .then ->
          Flash.now.success "Thanks for submitting the response!"
          $scope.response = response
          $scope.disabled = true
        , (error) ->
          Flash.now.error "Failed to save the response: #{error}"
          $log.error(error)

      $scope
