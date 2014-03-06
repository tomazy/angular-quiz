angular.module('quizApp')
  .factory 'FirebaseSimpleAuth', (FirebaseDatabaseConnection, FirebaseSimpleLogin, $rootScope, $q, safeApply, $log) ->

    currentUser = null

    deferredLogin = $q.defer()

    auth = new FirebaseSimpleLogin FirebaseDatabaseConnection, (error, user) ->
      $rootScope.$broadcast('authStatusChanged', user)

      safeApply ->
        if error
          $log.error("FirebaseSimpleAuth: #{error}")
          deferredLogin.reject(error) if deferredLogin
        else if user
          $log.info("FirebaseSimpleAuth: User logged in! User Id: #{user.id}, Email: #{user.email}")
          currentUser = user
          deferredLogin.resolve(user) if deferredLogin
        else
          $log.info("FirebaseSimpleAuth: User not authenticated!!!")
          currentUser = null
          deferredLogin.reject(reason: 'ACCESS_DENIED') if deferredLogin
          deferredLogin = null

    service =
      signup: (email, pass) ->
        deferred = $q.defer()

        auth.createUser email, pass, (error, user) ->
          safeApply ->
            if error
              deferred.reject(error)
            else
              deferred.resolve(user)

        deferred.promise

      login: (email, pass) ->
        auth.login('password', email: email, password: pass)
        deferredLogin = $q.defer()
        deferredLogin.promise

      anonymous: ->
        auth.login('anonymous')
        deferredLogin = $q.defer()
        deferredLogin.promise

      requestCurrentUser: ->
        return $q.when(currentUser) if currentUser
        return deferredLogin.promise if deferredLogin

        deferred = $q.defer()
        deferred.reject(reason: 'ACCESS_DENIED')
        deferred.promise

      logout: ->
        auth.logout()
