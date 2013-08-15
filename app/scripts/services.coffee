angular.module('quizApp')
  .factory 'DB', (Firebase, FIREBASE_URL, $q, $log, $rootScope) ->
    conn = new Firebase(FIREBASE_URL)
    questions = null
    answers = null

    conn: conn
    requestQuestions: ->
      return $q.when(questions) if questions

      deferred = $q.defer()

      conn.child('questions').on 'value', (snapshot) ->
        questions = snapshot.val()
        $log.log("db: loaded questions #{questions}")

        $rootScope.$apply ->
          deferred.resolve questions

      deferred.promise

    requestAnswers: ->
      return $q.when(answers) if answers

      deferred = $q.defer()

      conn.child('answers').on 'value', (snapshot) ->
        answers = snapshot.val()
        $log.log("db: loaded answers #{answers}")

        $rootScope.$apply ->
          deferred.resolve answers

      deferred.promise

    submitResponse: (id, response) ->
      deferred = $q.defer()

      link = conn.child("responses/#{id}")
      link.set response, (error) ->
        $rootScope.$apply ->
          if error
            deferred.reject(error)
          else
            deferred.resolve(true)

      deferred.promise

  .factory 'AuthService', ($q, $log, DB, FirebaseSimpleLogin, $rootScope) ->
    currentUser = null

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

    auth = new FirebaseSimpleLogin DB.conn, authStatusChanged

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
