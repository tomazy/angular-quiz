describe 'Service: Flash', ->

  beforeEach(module('quizApp'))

  $rootScope = null

  getFlash = (name) ->
    flash = null
    inject (Flash) ->
     flash = Flash[name]
    flash

  beforeEach ->
    $rootScope = jasmine.createSpyObj('$rootScope', ['$on'])

    module ($provide) ->
      $provide.factory "$rootScope", -> $rootScope
      null

  it 'should observe routes', inject (Flash)->
    expect($rootScope.$on).toHaveBeenCalledWith('$routeChangeSuccess', jasmine.any(Function))

  describe 'now', ->
    subject = -> getFlash('now')

    describe 'errors', ->
      it 'should update the scope', ->
        subject().error('abc')
        subject().error('def')
        expect($rootScope.flash.errors).toEqual(['abc', 'def'])

    describe 'successes', ->
      it 'should update the scope', ->
        subject().success('abc')
        expect($rootScope.flash.successes).toEqual(['abc'])

    describe 'resetting', ->
      it 'should update the scope', ->
        subject().success('abc')
        subject().error('def')

        subject().reset()
        expect($rootScope.flash.successes).toEqual([])
        expect($rootScope.flash.errors).toEqual([])

  describe 'future', ->
    subject = -> getFlash('future')

    futureIsNow = ->
      cb = $rootScope.$on.mostRecentCall.args[1]
      cb()

    describe 'errors', ->
      it 'should update the scope', ->
        subject().error('abc')
        expect($rootScope.flash.errors).toEqual([])

        futureIsNow()
        expect($rootScope.flash.errors).toEqual(['abc'])

    describe 'successes', ->
      it 'should update the scope', ->
        subject().success('abc')
        expect($rootScope.flash.successes).toEqual([])

        futureIsNow()
        expect($rootScope.flash.successes).toEqual(['abc'])

    describe 'resetting', ->
      it 'should update the scope', ->
        subject().success('abc')
        subject().error('def')

        subject().reset()
        expect($rootScope.flash.successes).toEqual([])
        expect($rootScope.flash.errors).toEqual([])

        futureIsNow()
        expect($rootScope.flash.successes).toEqual([])
        expect($rootScope.flash.errors).toEqual([])
