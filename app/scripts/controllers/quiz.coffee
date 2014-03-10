angular.module('quizApp')
  .controller 'QuizCtrl', ($scope, $routeParams, currentUser, Quiz, Flash) ->
    quiz = $scope.quiz ||= {}
    quizId = $routeParams.quizId ||= 0

    $scope.status = "Loading questions. Please wait..."

    Quiz.loadResponse(currentUser.id).then (response) ->
      if response?
        quiz.response = response
        quiz.disabled = true
      $scope.status = null
      quiz.ready = true

    Quiz.loadQuiz(quizId).then (response) ->
      if response?
        $scope.quiz.description = response.description
        $scope.quiz.options = response.options
        $scope.quiz.questions = response.questions
        $scope.quiz.ready = true
      $scope.status = null

    $scope.submitResponse = ->
      $scope.processing = true

      Flash.now.reset()

      succBack = ->
        Flash.now.success "Thanks for submitting the response!"
        quiz.disabled = true

      errBack = (error) ->
        Flash.now.error "Failed to save the response: #{error}"

      Quiz.submitResponse(currentUser.id, quiz.response).then(succBack, errBack)

      null

    $scope.showCorrectAnswers = ->
      quiz.correct = {}
      Quiz.loadAnswers().then (correctAnswers) ->
        for own qName, answers of quiz.response
          qq = quiz.correct[qName] =
            answers: {}

          for own aName, correctValue of correctAnswers[qName]
            aValue = answers[aName]

            correct = if correctValue
              correctValue == aValue
            else
              !!correctValue == !!aValue

            if not correct
              qq.invalid = true

            qq.answers[aName] =
              correct: correct
              correctValue: correctValue
              invalid: aValue and not correct
        null
      null
