angular.module('quizApp').controller 'SignUpCtrl', ($scope, $location, AuthService) ->
  validate = ->
    $scope.errors = []

    $scope.errors.push("Invalid email") unless $scope.email
    $scope.errors.push("Invalid password") unless $scope.password

    $scope.errors.length == 0

  $scope.signup = ->
    if validate()
      AuthService.signup($scope.email, $scope.password)
        .then ->
          $location.path('/login')
        , (error)->
          $scope.errors = [error.message || error]
