angular.module('quizApp')

  .controller 'AppCtrl', ($scope, $location) ->

    $scope.$on '$routeChangeError', (event, current, previous, rejection) ->
      console.log('$routeChangeError', arguments)
      $location.path('/login') if rejection.reason == 'ACCESS_DENIED'

    $scope.$on '$routeChangeStart', (event, next, current) ->
      console.log('$routeChangeStart', next, current)
