angular.module('quizApp').controller 'LogInCtrl', ($scope, $location, AuthService) ->
  validate = ->
    $scope.errors = []

    $scope.errors.push("Invalid email") unless $scope.email
    $scope.errors.push("Invalid password") unless $scope.password

    $scope.errors.length == 0

  $scope.login = ->
    if validate()
      AuthService.login($scope.email, $scope.password)
        .then ->
          $location.path('/')
        , (error)->
          $scope.errors = [error.message || error]




