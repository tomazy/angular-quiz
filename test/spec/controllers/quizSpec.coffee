describe 'Controller: QuizCtrl', ->

  beforeEach(module('quizApp'));

  QuizCtrl = null
  scope = null
  Quiz = null
  currentUser = null
  Flash = null

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
    Quiz.loadResponse.andReturn(deferredResponse.promise)
    Quiz.loadAnswers.andReturn(deferredAnswers.promise)
    Quiz.submitResponse.andReturn(deferredSubmitResponse.promise)

    currentUser = {
      id: 1
    }

    inject ($controller, $rootScope) ->
      scope = $rootScope.$new();
      scope.quiz = {}
      QuizCtrl = $controller 'QuizCtrl',
        $scope: scope,
        Quiz: Quiz,
        Flash: Flash,
        currentUser: currentUser

  describe 'Status', ->
    it 'should be "loading..."', ->
      expect(scope.status).toMatch(/loading/i)

  describe "Response", ->
    response = null

    it 'should load response of the current user', ->
      expect(Quiz.loadResponse).toHaveBeenCalledWith(currentUser.id)

    context "exists/", ->
      beforeEach ->
        response = {}
        resolve deferredResponse, response

      it 'should attach it to the scope', ->
        expect(scope.quiz.response).toBe(response)

      it 'should disable quiz', ->
        expect(scope.quiz.disabled).toBe(true)

      it 'should clean the status', ->
        expect(scope.status).toBe(null)

      it 'should set ready flag', ->
        expect(scope.quiz.ready).toBe(true)

    context "doesn't exists/", ->
      beforeEach ->
        response = null
        resolve deferredResponse, response

      it 'should not attach it to the scope', ->
        expect(scope.quiz.response).not.toBe(response)

      it 'should not disable quiz', ->
        expect(scope.quiz.disabled).toBeFalsy()

      it 'should clean the status', ->
        expect(scope.status).toBe(null)

      it 'should set ready flag', ->
        expect(scope.quiz.ready).toBe(true)

  describe "Submitting response", ->
    response = null

    beforeEach ->
      response = {}
      scope.quiz.response = response

    beforeEach ->
      scope.submitResponse()

    it 'should use Quiz', ->
      expect(Quiz.submitResponse).toHaveBeenCalledWith(currentUser.id, response)

    it 'should reset flash messages', ->
      expect(Flash.now.reset).toHaveBeenCalled()

    describe 'success', ->
      beforeEach ->
        resolve deferredSubmitResponse, {}

      it 'should flash a message', ->
        expect(Flash.now.success).toHaveBeenCalled()

    describe 'errors', ->
      it 'should flash an error', ->
        reject deferredSubmitResponse, {}
        expect(Flash.now.error).toHaveBeenCalled()

  describe "Marking correct answers", ->
    response = null
    correctAnswers = null
    correct = null

    beforeEach ->
      response =
        q1:
          a: false
          b: true
        q2:
          a: true
          b: false

      correctAnswers =
        q1:
          a: false
          b: true
        q2:
          a: false
          b: true

    beforeEach ->
      resolve deferredResponse, response

    beforeEach ->
      scope.showCorrectAnswers()
      resolve deferredAnswers, correctAnswers

    beforeEach ->
      correct = scope.quiz.correct

    it 'should load them', ->
      expect(Quiz.loadAnswers).toHaveBeenCalled()

    it 'should update correct', ->
      expect(correct.q1.invalid).toBeFalsy()
      expect(correct.q1.answers.a.correctValue).toEqual(correctAnswers.q1.a)
      expect(correct.q1.answers.b.correctValue).toEqual(correctAnswers.q1.b)

      expect(correct.q1.answers.a.correct).toEqual(response.q1.a == correctAnswers.q1.a)
      expect(correct.q1.answers.b.correct).toEqual(response.q1.b == correctAnswers.q1.b)

      expect(correct.q2.invalid).toBeTruthy()
      expect(correct.q2.answers.a.correctValue).toEqual(correctAnswers.q2.a)
      expect(correct.q2.answers.b.correctValue).toEqual(correctAnswers.q2.b)

      expect(correct.q2.answers.a.correct).toEqual(response.q2.a == correctAnswers.q2.a)
      expect(correct.q2.answers.b.correct).toEqual(response.q2.b == correctAnswers.q2.b)

      expect(correct.q2.answers.a.invalid).toBeTruthy()
      expect(correct.q2.answers.b.invalid).toBeFalsy()
