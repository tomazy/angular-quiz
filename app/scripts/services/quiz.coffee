angular.module('quizApp')
  .factory 'Quiz', (DB, $q) ->
    answers = null
    responses = {}
    currentQuiz = {}

    quiz =
      loadQuestions: ->
        DB.read('questions')

      loadAnswers: ->
        return $q.when(answers) if answers

        DB.read('answers').then (data) ->
          answers = data

      loadQuiz: (id) ->
        return $q.when(currentQuiz) if currentQuiz.id is id

        DB.read("Quizes/#{id}").then (data) ->
          currentQuiz = data

      loadResponse: (id) ->
        return $q.when(responses[id]) if responses[id]

        DB.read("responses/#{id}").then (data) ->
          responses[id] = data

      submitResponse: (id, response) ->
        DB.write("responses/#{id}", response)
