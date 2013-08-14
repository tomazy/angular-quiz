angular.module('quizApp').
  factory 'AuthService', ($q, $timeout, $log, Firebase, FirebaseSimpleLogin, FIREBASE_URL) ->
    $log.log('auth: in factory')

    currentUser = null

    dbRef = new Firebase(FIREBASE_URL)

    $log.log('auth: dbRef', dbRef)

    pendingUser = null

    authStatusChanged = (error, user) ->
      if error
        $log.error(error)
        pendingUser.reject(error) if pendingUser
      else if user
        $log.log("auth: User Id: #{user.id}, Email: #{user.email}")
        pendingUser.resolve(user) if pendingUser

    auth = new FirebaseSimpleLogin dbRef, authStatusChanged

    service =
      login: (email, pass) ->
        $log.log('auth: login ->', email)

        deferred = $q.defer()
        $timeout( ->

          if (email == 'tomek@example.com' and pass == 'password')
            currentUser = email: email
            deferred.resolve(true)
          else
            deferred.reject(reason: 'Invalid email/password')

        , 1000)

        deferred.promise

      isAuthenticated: ->
        currentUser?

      requestCurrentUser: ->
        $log.log('auth: requesting current user')
        deferred = $q.defer()

        if isAuthenticated()
          deferred.resolve currentUser
        else
          deferred.reject(reason: 'ACCESS_DENIED')

        deferred.promise
