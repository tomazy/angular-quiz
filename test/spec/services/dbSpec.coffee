describe 'Services', ->
  FIREBASE_URL = 'https://some.url.com'

  fbNamespace =
    Firebase: ->

  beforeEach(module('quizApp'))

  beforeEach ->
    module ($provide) ->
      $provide.value('Firebase', fbNamespace.Firebase)
      $provide.constant('FIREBASE_URL', FIREBASE_URL)
      null

  describe 'Service: FirebaseDatabaseConnection', ->

    it 'should use Firebase', ->
      spyOn(fbNamespace, 'Firebase')

      inject (FirebaseDatabaseConnection)-> #noop

      expect(fbNamespace.Firebase).toHaveBeenCalledWith(FIREBASE_URL)

  describe 'Service: DB', ->

    FirebaseDatabaseConnection = null
    setSpy = null

    beforeEach ->
      setSpy = jasmine.createSpy('set')

      FirebaseDatabaseConnection = jasmine.createSpyObj('FirebaseDatabaseConnection', ['child'])
      FirebaseDatabaseConnection.child.andReturn
        on: jasmine.createSpy('on')
        set: setSpy

      module ($provide) ->
        $provide.value('FirebaseDatabaseConnection', FirebaseDatabaseConnection)
        null

    describe 'reading data', ->
      it 'should use db connection', inject (DB) ->
        DB.read('something')
        expect(FirebaseDatabaseConnection.child).toHaveBeenCalledWith('something')

      it 'should return a promise', inject (DB)->
        result = DB.read('abc')
        expect(result.then instanceof Function).toBe(true)

    describe 'writing data', ->
      it 'should use db connection', inject (DB) ->
        DB.write('abc', {})
        expect(FirebaseDatabaseConnection.child).toHaveBeenCalledWith('abc')

      it 'should return a promise', inject (DB)->
        result = DB.write('abc', {})
        expect(result.then instanceof Function).toBe(true)

      it 'should write the data', inject (DB)->
        result = DB.write('abc', 'def')
        expect(setSpy).toHaveBeenCalledWith('def', jasmine.any(Function))
