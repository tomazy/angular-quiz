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

  describe 'Service: DBConnection', ->

    it 'should use Firebase', ->
      spyOn(fbNamespace, 'Firebase')

      inject (DBConnection)-> #noop

      expect(fbNamespace.Firebase).toHaveBeenCalledWith(FIREBASE_URL)

  describe 'Service: DB', ->

    DBConnection = null
    setSpy = null

    beforeEach ->
      setSpy = jasmine.createSpy('set')

      DBConnection = jasmine.createSpyObj('DBConnection', ['child'])
      DBConnection.child.andReturn
        on: jasmine.createSpy('on')
        set: setSpy

      module ($provide) ->
        $provide.value('DBConnection', DBConnection)
        null

    describe 'reading data', ->
      it 'should use db connection', inject (DB) ->
        DB.read('something')
        expect(DBConnection.child).toHaveBeenCalledWith('something')

      it 'should return a promise', inject (DB)->
        result = DB.read('abc')
        expect(result.then instanceof Function).toBe(true)

    describe 'writing data', ->
      it 'should use db connection', inject (DB) ->
        DB.write('abc', {})
        expect(DBConnection.child).toHaveBeenCalledWith('abc')

      it 'should return a promise', inject (DB)->
        result = DB.write('abc', {})
        expect(result.then instanceof Function).toBe(true)

      it 'should write the data', inject (DB)->
        result = DB.write('abc', 'def')
        expect(setSpy).toHaveBeenCalledWith('def', jasmine.any(Function))
