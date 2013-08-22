angular.module('quizApp')
  .factory 'safeApply', ($rootScope) ->
    safeApply = (fn) ->
      phase = $rootScope.$$phase;
      if phase == '$apply' or phase == '$digest'
        fn()
      else
        $rootScope.$apply(fn);

