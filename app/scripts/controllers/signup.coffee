angular.module('quizApp').controller 'SignUpCtrl', ($scope, AuthService) ->
  $scope.register = ->
    console.log('registering...')
