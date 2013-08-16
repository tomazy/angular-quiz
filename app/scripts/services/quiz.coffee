angular.module('quizApp')
  .factory 'Quiz', (DB, $q) ->
    answers = null
    responses = {}

    quiz =
      loadQuestions: ->
        DB.read('questions')

      loadAnswers: ->
        return $q.when(answers) if answers

        DB.read('answers').then (data) ->
          answers = data

      loadResponse: (id) ->
        return $q.when(responses[id]) if responses[id]

        DB.read("responses/#{id}").then (data) ->
          responses[id] = data

      submitResponse: (id, response) ->
        DB.write("responses/#{id}", response)
