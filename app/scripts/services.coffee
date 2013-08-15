angular.module('quizApp')
  .factory 'safeApply', ($rootScope) ->
    safeApply = (fn) ->
      phase = $rootScope.$$phase;
      if phase == '$apply' or phase == '$digest'
        fn()
      else
        $rootScope.$apply(fn);

  .factory 'DB', (Firebase, FIREBASE_URL, safeApply, $q, $log) ->
    conn = new Firebase(FIREBASE_URL)

    questions = null
    answers = null

    responses = {}

    loadData = (name) ->
      deferred = $q.defer()

      conn.child(name).on 'value', (snapshot) ->
        data = snapshot.val()
        $log.log("db: loaded #{name} #{data}")

        safeApply ->
          deferred.resolve data

      deferred.promise

    conn: conn
    requestQuestions: ->
      return $q.when(questions) if questions

      loadData('questions').then (data) ->
        questions = data

    requestAnswers: ->
      return $q.when(answers) if answers

      loadData('answers').then (data) ->
        answers = data

    requestResponse: (id) ->
      return $q.when(responses[id]) if responses[id]

      loadData("responses/#{id}").then (data) ->
        responses[id] = data

    submitResponse: (id, response) ->
      deferred = $q.defer()

      link = conn.child("responses/#{id}")
      link.set response, (error) ->
        safeApply ->
          if error
            deferred.reject(error)
          else
            deferred.resolve(true)

      deferred.promise

  .factory 'AuthService', ($q, $log, DB, FirebaseSimpleLogin, safeApply) ->
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


      signup: (email, pass) ->
        $log.log("auth: signup -> #{email}, #{pass}")

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
