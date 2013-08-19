describe 'Service: Quiz', ->

  beforeEach(module('quizApp'))

  DB = null

  beforeEach ->
    DB = jasmine.createSpyObj('DB', ['read', 'write'])

    module ($provide) ->
      $provide.value('DB', DB)
      null

  describe 'questions', ->

    loadQuestions = inject (Quiz, $rootScope) ->
      Quiz.loadQuestions()
      $rootScope.$apply()

    it 'should be loaded from db', ->
      loadQuestions()
      expect(DB.read).toHaveBeenCalledWith('questions')

    it 'should not be cached', ->
      loadQuestions()
      loadQuestions()
      expect(DB.read.callCount).toEqual(2)

  describe 'answers', ->
    beforeEach inject ($q) ->
      DB.read.andReturn($q.when(true))

    loadAnswers = inject (Quiz, $rootScope) ->
      Quiz.loadAnswers()
      $rootScope.$apply()

    it 'should be loaded from db', ->
      loadAnswers()
      expect(DB.read).toHaveBeenCalledWith('answers')

    it 'should be cached', ->
      loadAnswers()
      loadAnswers()
      expect(DB.read.callCount).toEqual(1)

  describe 'responses', ->
    beforeEach inject ($q) ->
      DB.read.andReturn($q.when(true))

    loadResponse = (id) ->
      inject (Quiz, $rootScope) ->
        Quiz.loadResponse(id)
        $rootScope.$apply()

    it 'should be loaded from db', ->
      loadResponse(123)
      expect(DB.read).toHaveBeenCalledWith("responses/123")

    it 'should be cached', ->
      loadResponse(123)
      loadResponse(123)
      expect(DB.read.callCount).toEqual(1)

      loadResponse(321)
      expect(DB.read.callCount).toEqual(2)
