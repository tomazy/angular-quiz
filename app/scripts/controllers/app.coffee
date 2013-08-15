angular.module('quizApp')

  .controller 'AppCtrl', ($scope, $location, $log, AuthService) ->

    $scope.$on '$routeChangeError', (event, current, previous, rejection) ->
      $log.log('$routeChangeError', arguments)
      $location.path('/login') if rejection.reason == 'ACCESS_DENIED'

    $scope.logout = ->
      AuthService.logout()
      $location.path('/login')
