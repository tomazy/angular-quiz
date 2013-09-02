angular.module('quizApp')

  .controller 'SignUpCtrl', ($location, Auth, Flash) ->
    self = @

    self.signup = ->
      Flash.now.reset()

      self.processing = true

      success = ->
        Flash.future.success("You've been signed up! Now you can log in.")
        $location.path('/login')

      error = (error) ->
        Flash.now.error(error.message || error)
        self.processing = false

      Auth.signup(self.email, self.password).then(success, error)
