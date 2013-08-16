describe 'Service: Flash', ->

  beforeEach(module('quizApp'))

  rootScopeMock = null

  beforeEach ->
    rootScopeMock =
      $on: jasmine.createSpy('$on')

    inject ($rootScope) ->
      rootScopeMock = $rootScope
      spyOn(rootScopeMock, '$on')

  it 'should observe routes', inject (Flash)->
    expect(rootScopeMock.$on).toHaveBeenCalledWith('$routeChangeSuccess', jasmine.any(Function))

  describe 'now', ->
    subject = (Flash) -> Flash.now

    describe 'errors', ->
      it 'should update the scope', inject (Flash)->
        subject(Flash).error('abc')
        subject(Flash).error('def')
        expect(rootScopeMock.flash.errors).toEqual(['abc', 'def'])

    describe 'successes', ->
      it 'should update the scope', inject (Flash)->
        subject(Flash).success('abc')
        expect(rootScopeMock.flash.successes).toEqual(['abc'])

    describe 'resetting', ->
      it 'should update the scope', inject (Flash)->
        subject(Flash).success('abc')
        subject(Flash).error('def')

        subject(Flash).reset()
        expect(rootScopeMock.flash.successes).toEqual([])
        expect(rootScopeMock.flash.errors).toEqual([])

  describe 'future', ->
    subject = (Flash) -> Flash.future

    futureIsNow = ->
      cb = rootScopeMock.$on.mostRecentCall.args[1]
      cb()

    describe 'errors', ->
      it 'should update the scope', inject (Flash)->
        subject(Flash).error('abc')
        expect(rootScopeMock.flash.errors).toEqual([])

        futureIsNow()
        expect(rootScopeMock.flash.errors).toEqual(['abc'])

    describe 'successes', ->
      it 'should update the scope', inject (Flash)->
        subject(Flash).success('abc')
        expect(rootScopeMock.flash.successes).toEqual([])

        futureIsNow()
        expect(rootScopeMock.flash.successes).toEqual(['abc'])

    describe 'resetting', ->
      it 'should update the scope', inject (Flash)->
        subject(Flash).success('abc')
        subject(Flash).error('def')

        subject(Flash).reset()
        expect(rootScopeMock.flash.successes).toEqual([])
        expect(rootScopeMock.flash.errors).toEqual([])

        futureIsNow()
        expect(rootScopeMock.flash.successes).toEqual([])
        expect(rootScopeMock.flash.errors).toEqual([])
