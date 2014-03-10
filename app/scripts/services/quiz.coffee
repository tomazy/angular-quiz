angular.module('quizApp')
  .factory 'Quiz', (DB, $q) ->
    answers = {}
    questions = {}
    responses = {}
    currentQuiz = {}

    quiz =
      loadQuestions: ->
        id = currentQuiz.id or 0
        return $q.when(questions[id]) if questions[id]

        DB.read("Quizes/#{id}/questions").then (data) ->
          questions[id] = data

      loadAnswers: ->
        id = currentQuiz.id or 0
        return $q.when(answers[id]) if answers[id]

        DB.read("Quizes/#{id}/answers").then (data) ->
          answers[id] = data

      loadQuiz: (id) ->
        return $q.when(currentQuiz) if currentQuiz.id is id

        DB.read("Quizes/#{id}").then (data) ->
          currentQuiz.courseId = data.courseId
          currentQuiz.id = data.id
          currentQuiz.options = data.options
          currentQuiz.title = data.title

      loadResponse: (id) ->
        return $q.when(responses[id]) if responses[id]

        DB.read("responses/#{id}").then (data) ->
          responses[id] = data

      submitResponse: (id, response) ->
        DB.write("responses/#{id}", response)
