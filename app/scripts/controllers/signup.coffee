angular.module('quizApp').controller 'SignUpCtrl', ($scope, authService) ->
  console.log(authService);

  $scope.register = ->
    console.log('registering...')
