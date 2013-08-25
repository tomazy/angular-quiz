angular.module('quizApp')

  .controller 'SignUpCtrl', ($scope, $location, Auth, Flash, CredentialsValidator) ->
    onError = (error) ->
      Flash.now.error(error)

    $scope.signup = ->
      if CredentialsValidator.validate($scope, onError)
        $scope.processing = true

        success = ->
          Flash.future.success("You've been signed up! Now you can log in.")
          $location.path('/login')

        error = (error) ->
          Flash.now.error(error.message || error)
          $scope.processing = false

        Auth.signup($scope.email, $scope.password).then(success, error)
