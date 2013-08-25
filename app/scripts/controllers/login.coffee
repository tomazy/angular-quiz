angular.module('quizApp')

  .controller 'LogInCtrl', ($scope, $location, Auth, Flash, CredentialsValidator) ->
    onError = (error) ->
      Flash.now.error(error)

    $scope.login = ->
      Flash.now.reset()
      if CredentialsValidator.validate($scope, onError)
        $scope.processing = true

        success = ->
          Flash.future.success("Welcome!")
          $location.path('/')

        error = (error) ->
          Flash.now.error(error.message || error)
          $scope.processing = false

        Auth.login($scope.email, $scope.password).then(success, error)
