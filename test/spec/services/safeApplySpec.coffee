describe 'Service: safeApply', ->

  beforeEach(module('quizApp'))

  $rootScope = null
  testFn = null

  beforeEach ->
    testFn = jasmine.createSpy()
    $rootScope = jasmine.createSpyObj("$rootScope", ["$apply"])

    module ($provide) ->
      $provide.factory('$rootScope', -> $rootScope)
      null

  describe "Phase: $apply", ->
    beforeEach ->
      $rootScope.$$phase = "$apply"

    it "shouldn't use $apply", inject (safeApply, $rootScope) ->
      safeApply(testFn)
      expect(testFn).toHaveBeenCalled()
      expect($rootScope.$apply).not.toHaveBeenCalled()

  describe "Phase: $digest", ->
    beforeEach ->
      $rootScope.$$phase = "$digest"

    it "shouldn't use $apply", inject (safeApply, $rootScope) ->
      safeApply(testFn)
      expect(testFn).toHaveBeenCalled()
      expect($rootScope.$apply).not.toHaveBeenCalled()


  describe "Other phases", ->
    it "should use $apply", inject (safeApply, $rootScope) ->
      safeApply(testFn)
      expect($rootScope.$apply).toHaveBeenCalledWith(testFn)

