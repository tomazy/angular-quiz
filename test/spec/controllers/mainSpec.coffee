describe 'Controller: MainCtrl', ->

  beforeEach(module('quizApp'));

  MainCtrl = null
  scope = null
  Quiz = null
  currentUser = null
  Flash = null

  deferredQuestions = null
  deferredResponse = null
  deferredAnswers = null
  deferredSubmitResponse = null

  resolve = (deferred, result) ->
    deferred.resolve(result)
    scope.$apply()

  reject = (deferred, result) ->
    deferred.reject(result)
    scope.$apply()

  beforeEach ->

    inject ($q) ->
      deferredQuestions = $q.defer()
      deferredResponse = $q.defer()
      deferredAnswers = $q.defer()
      deferredSubmitResponse = $q.defer()

    Flash = {
      now: jasmine.createSpyObj('Flash.now', ['success', 'error', 'reset'])
    }

    Quiz = jasmine.createSpyObj('Quiz', [
      'loadQuestions',
      'loadResponse',
      'loadAnswers',
      'submitResponse'
    ])
    Quiz.loadQuestions.andReturn(deferredQuestions.promise)
    Quiz.loadResponse.andReturn(deferredResponse.promise)
    Quiz.loadAnswers.andReturn(deferredAnswers.promise)
    Quiz.submitResponse.andReturn(deferredSubmitResponse.promise)

    currentUser = {
      id: 1
    }

    inject ($controller, $rootScope) ->
      scope = $rootScope.$new();
      MainCtrl = $controller 'MainCtrl',
        $scope: scope,
        Quiz: Quiz,
        Flash: Flash,
        currentUser: currentUser

  describe 'Status', ->
    it 'should be "loading..."', ->
      expect(scope.status).toMatch(/loading/i)

  describe 'Questions', ->
    it 'should load them', ->
      expect(Quiz.loadQuestions).toHaveBeenCalled()

    it 'should attach them to the scope', ->
      questions = []
      resolve deferredQuestions, questions
      expect(scope.questions).toBe(questions)

  describe "Response", ->
    it 'should load it', ->
      expect(Quiz.loadResponse).toHaveBeenCalledWith(currentUser.id)

    it 'should attach it to the scope', ->
      response = {}
      resolve deferredResponse, response
      expect(scope.response).toBe(response)

  describe "Correct answers", ->
    it 'should load them', ->
      scope.showCorrectAnswers()
      expect(Quiz.loadAnswers).toHaveBeenCalled()

  describe "Submitting response", ->
    it 'should use Quiz', ->
      scope.submitResponse()
      expect(Quiz.submitResponse).toHaveBeenCalledWith(currentUser.id, jasmine.any(Object))

    it 'should reset flash messages', ->
      scope.submitResponse()
      expect(Flash.now.reset).toHaveBeenCalled()

    it 'should flash a message', ->
      scope.submitResponse()
      resolve deferredSubmitResponse, {}
      expect(Flash.now.success).toHaveBeenCalled()

    describe 'errors', ->
      it 'should flash an error', ->
        scope.submitResponse()
        reject deferredSubmitResponse, {}
        expect(Flash.now.error).toHaveBeenCalled()

  describe "Working with the response", ->
    questions = null

    beforeEach ->
      questions = [
        name: 'q1'
        options: [
          value: 'a'
        ,
          value: 'b'
        ]
      ,
        name: 'q2'
        options: [
          value: 'a'
        ,
          value: 'b'
        ]
      ]

    beforeEach ->
      resolve deferredQuestions,  questions

    describe 'Submitting response', ->

      beforeEach ->
        scope.questions[0].options[0].checked = false
        scope.questions[0].options[1].checked = true
        scope.questions[1].options[0].checked = true
        scope.questions[1].options[1].checked = false

      it 'should prepare the response', ->
        scope.submitResponse()
        expect(Quiz.submitResponse).toHaveBeenCalledWith currentUser.id,
          q1:
            a: false
            b: true
          q2:
            a: true
            b: false


    describe 'Loading existing response', ->

      response = null

      beforeEach ->
        questions = [
          name: 'q1'
          options: [
            value: 'a'
          ,
            value: 'b'
          ]
        ,
          name: 'q2'
          options: [
            value: 'a'
          ,
            value: 'b'
          ]
        ]

        response =
          q1:
            a: false
            b: true
          q2:
            a: true
            b: false

      beforeEach ->
        resolve deferredResponse, response

      it 'should update questions', ->
        expect(scope.questions[0].options[0].checked).toBeFalsy()
        expect(scope.questions[0].options[1].checked).toBeTruthy()

        expect(scope.questions[1].options[0].checked).toBeTruthy()
        expect(scope.questions[1].options[1].checked).toBeFalsy()

      it 'should update status', ->
        expect(scope.status).toBe(null)

      describe "Marking correct answers", ->
        correctAnswers = null

        beforeEach ->
          correctAnswers =
            q1:
              a: false
              b: true
            q2:
              a: false
              b: true

        beforeEach ->
          scope.showCorrectAnswers()
          resolve deferredAnswers, correctAnswers

        it 'should update questions', ->
          expect(scope.questions[0].invalid).toBeFalsy()
          expect(scope.questions[0].options[0].correct).toEqual(correctAnswers.q1.a)
          expect(scope.questions[0].options[1].correct).toEqual(correctAnswers.q1.b)

          expect(scope.questions[1].invalid).toBeTruthy()
          expect(scope.questions[1].options[0].correct).toEqual(correctAnswers.q2.a)
          expect(scope.questions[1].options[1].correct).toEqual(correctAnswers.q2.b)
          expect(scope.questions[1].options[0].invalid).toBeTruthy()
          expect(scope.questions[1].options[1].invalid).toBeFalsy()
