angular.module('quizApp')
  .factory 'Flash', ($rootScope) ->
    now = $rootScope.flash = {}
    future = {}

    $rootScope.$on '$routeChangeSuccess', ->
      for a in ['errors', 'successes']
        now[a] = future[a]
        future[a] = []
      null

    create = (flash) ->
      result =
        reset: () ->
          flash.errors = []
          flash.successes = []
          result

        error: (error) ->
          flash.errors.push(error)

        success: (success)->
          flash.successes.push(success)

      result.reset()

    service =
      now: create(now)
      future: create(future)
