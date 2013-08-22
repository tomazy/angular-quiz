angular.module('quizApp')
  .factory 'AuthService', ($q, $log, DBConnection, FirebaseSimpleLogin, safeApply) ->
    currentUser = null

    deferredUser = $q.defer()

    authStatusChanged = (error, user) ->
      if error
        $log.error("auth: Error: #{error}")
        safeApply ->
          deferredUser.reject(error) if deferredUser
      else if user
        $log.log("auth: User logged in! User Id: #{user.id}, Email: #{user.email}")
        currentUser = user
        safeApply ->
          deferredUser.resolve(user) if deferredUser?
      else
        $log.log("auth: User not authenticated!!!")
        currentUser = null
        deferredUser.reject(reason: 'ACCESS_DENIED') if deferredUser

    auth = new FirebaseSimpleLogin DBConnection, authStatusChanged

    service =
      login: (email, pass) ->
        $log.log('auth: login ->', email)

        service.logout()

        deferredUser = $q.defer()

        auth.login('password', email: email, password: pass)

        deferredUser.promise

      logout: ->
        deferredUser.reject('logging out') if deferredUser
        auth.logout()


      signup: (email, pass) ->
        $log.log("auth: signup -> #{email}")

        service.logout()

        deferred = $q.defer()

        auth.createUser email, pass, (error, user) ->
          safeApply ->
            if error
              deferred.reject(error)
            else
              deferred.resolve(user)

        deferred.promise

      requestCurrentUser: ->
        $log.log("auth: requesting current user")

        return $q.when(currentUser) if currentUser?
        return deferredUser.promise if deferredUser?

        deferred = $q.defer()
        deferred.reject(reason: 'ACCESS_DENIED')
        deferred.promise

  .factory 'LoginValidator', ->

    service =
      validate: (data, onError) ->
        result = true

        unless data.email
          onError "Invalid email"
          result = false

        unless data.password
          onError "Invalid password"
          result = false

        result
