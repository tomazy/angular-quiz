angular.module('quizApp').
  factory 'AuthService', ($q, $log, Firebase, FirebaseSimpleLogin, FIREBASE_URL, $rootScope) ->
    currentUser = null

    dbRef = new Firebase(FIREBASE_URL)

    deferredUser = $q.defer()

    authStatusChanged = (error, user) ->
      if error
        $log.error("auth: Error: #{error}")
        $rootScope.$apply ->
          deferredUser.reject(error) if deferredUser
      else if user
        $log.log("auth: User logged in! User Id: #{user.id}, Email: #{user.email}")
        currentUser = user
        $rootScope.$apply ->
          deferredUser.resolve(user) if deferredUser?
      else
        $log.log("auth: User not authenticated!!!")
        currentUser = null
        deferredUser.reject(reason: 'ACCESS_DENIED') if deferredUser

    auth = new FirebaseSimpleLogin dbRef, authStatusChanged

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

      requestCurrentUser: ->
        $log.log("auth: requesting current user")

        return $q.when(currentUser) if currentUser?
        return deferredUser.promise if deferredUser?

        deferred = $q.defer()
        deferred.reject(reason: 'ACCESS_DENIED')
        deferred.promise
