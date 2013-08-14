angular.module('quizApp').controller 'LogInCtrl', ($scope, $location, AuthService) ->
  form = $scope.form

  validate = ->
    $scope.errors = []

    $scope.errors.push("Invalid email") unless $scope.email
    $scope.errors.push("Invalid password") unless $scope.password

    $scope.errors.length == 0

  $scope.login = ->
    console.log($scope)
    if validate()
      AuthService.login($scope.email, $scope.password)
        .then ->
          $location.path('/')
        , (rejection)->
          $scope.errors = [rejection.reason]




