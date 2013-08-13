angular.module('quizApp').
  controller 'SignUpCtrl', ($scope) ->

    validate = ->
      $scope.validationError = null

      if $scope.password != $scope.confirmPassword
        $scope.validationError = "Passwords don't match!"
        return false

      true

    $scope.register = ->
      console.log($scope)
      if validate()
        console.log('valid')

