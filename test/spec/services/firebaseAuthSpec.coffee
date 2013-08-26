describe 'Service: FirebaseSimpleAuth', ->

  fbNamespace = window

  dbConnection = null

  beforeEach(module('quizApp'))

  beforeEach ->
    dbConnection = {}
    FirebaseSimpleLogin = fbNamespace.FirebaseSimpleLogin = ->

    module ($provide) ->
      $provide.factory('FirebaseDatabaseConnection', -> dbConnection)
      $provide.factory('FirebaseSimpleLogin', -> fbNamespace.FirebaseSimpleLogin)
      null

  it "should use FirebaseSimpleLogin", ->
    spyOn(fbNamespace, 'FirebaseSimpleLogin')
    inject (FirebaseSimpleAuth) ->
      expect(fbNamespace.FirebaseSimpleLogin).toHaveBeenCalledWith(dbConnection, jasmine.any(Function))

  describe "API", ->
    fbClient = null

    beforeEach ->
      fbClient = jasmine.createSpyObj('fbClient', ['createUser', 'login', 'logout'])
      spyOn(fbNamespace, 'FirebaseSimpleLogin').andReturn(fbClient)

    doLogin = (email='email', pass='pass') ->
      promise = null
      inject (FirebaseSimpleAuth) ->
        promise = FirebaseSimpleAuth.login(email, pass)
      promise

    fbAuthChangeCallback = (error, user) ->
      inject (FirebaseSimpleAuth) ->
        f = fbNamespace.FirebaseSimpleLogin.mostRecentCall.args[1]
        f(error, user)

    doRequestCurrentUser = ->
      promise = null
      inject (FirebaseSimpleAuth) ->
        promise = FirebaseSimpleAuth.requestCurrentUser()
      promise

    describe "Event", ->

      $rootScope = null

      beforeEach ->
        $rootScope = jasmine.createSpyObj('$rootScope', ['$broadcast', '$apply'])
        module ($provide) ->
          $provide.factory('$rootScope', -> $rootScope)
          null

      it 'should broadcast an event when auth status changes', inject ($rootScope)->
        user = {}
        fbAuthChangeCallback(null, user)
        expect($rootScope.$broadcast).toHaveBeenCalledWith('authStatusChanged', user)

    describe "Sign Up", ->

      doSignup = (email='email', pass='pass') ->
        promise = null
        inject (FirebaseSimpleAuth) ->
          promise = FirebaseSimpleAuth.signup(email, pass)
        promise

      it "should use the API", ->
        doSignup('email', 'pass')
        expect(fbClient.createUser).toHaveBeenCalledWith('email', 'pass', jasmine.any(Function))

      it "should return promise", ->
        promise = doSignup()
        expect(promise.then instanceof Function).toBe(true)

      describe "Callbacks", ->
        succBack = null
        errBack = null

        fbCreateUserCallback = (error, user) ->
          f = fbClient.createUser.mostRecentCall.args[2]
          f(error, user)

        beforeEach ->
          succBack = jasmine.createSpy('succBack')
          errBack = jasmine.createSpy('errBack')

          doSignup().then(succBack, errBack)

        describe "Success", ->

          it "should pass user", ->
            user = {}
            fbCreateUserCallback(null, user)
            expect(succBack).toHaveBeenCalledWith(user)

        describe "Errors", ->

          it "should pass errors", ->
            fbCreateUserCallback('ERROR')
            expect(errBack).toHaveBeenCalledWith('ERROR')

    describe "Log in", ->

      it "should use the API", ->
        doLogin('email', 'pass')
        expect(fbClient.login).toHaveBeenCalledWith('password', email: 'email', password: 'pass')

      it "should return promise", ->
        promise = doLogin()
        expect(promise.then instanceof Function).toBe(true)

      describe "Callbacks", ->
        succBack = null
        errBack = null

        beforeEach ->
          succBack = jasmine.createSpy('succBack')
          errBack = jasmine.createSpy('errBack')

          doLogin().then(succBack, errBack)

        describe "Success", ->

          it "should pass user", ->
            user = {}
            fbAuthChangeCallback(null, user)
            expect(succBack).toHaveBeenCalledWith(user)

        describe "Errors", ->

          it "should pass errors", ->
            fbAuthChangeCallback('ERROR')
            expect(errBack).toHaveBeenCalledWith('ERROR')

    describe "Request current user", ->

      it "should return promise", ->
        promise = doRequestCurrentUser()
        expect(promise.then instanceof Function).toBe(true)

      describe "Callbacks", ->
        succBack = null
        errBack = null

        beforeEach ->
          succBack = jasmine.createSpy('succBack')
          errBack = jasmine.createSpy('errBack')

        context "User already logged in", ->
          currUser = null

          beforeEach ->
            currUser = {}
            fbAuthChangeCallback(null, currUser)

          it "should return current user", inject ($rootScope)->
            doRequestCurrentUser().then(succBack, errBack)
            $rootScope.$apply()
            expect(succBack).toHaveBeenCalledWith(currUser)

        context "User is loggin in", ->

          it "should return current user", ->
            currUser = {}
            doLogin()
            doRequestCurrentUser().then(succBack, errBack)
            fbAuthChangeCallback(null, currUser)
            expect(succBack).toHaveBeenCalledWith(currUser)

        context "User not logged in", ->

          it "should report error", ->
            doRequestCurrentUser().then(succBack, errBack)
            fbAuthChangeCallback(null, null)
            expect(errBack).toHaveBeenCalledWith(reason: 'ACCESS_DENIED')

          context "Existing session", ->
            it "should connect to session", ->
              currUser = {}
              doRequestCurrentUser().then(succBack, errBack)
              fbAuthChangeCallback(null, currUser)
              expect(succBack).toHaveBeenCalledWith(currUser)


    describe "Log out", ->
      doLogout = ->
        inject (FirebaseSimpleAuth) ->
          FirebaseSimpleAuth.logout()

      it "should use the API", ->
        doLogout()
        expect(fbClient.logout).toHaveBeenCalled()

      context "User logged in", ->
        currUser = null

        beforeEach ->
          currUser = {}
          doLogin()
          fbAuthChangeCallback(null, currUser)

        it "should log out", inject ($rootScope)->
          errBack = jasmine.createSpy('errBack')

          doLogout()
          fbAuthChangeCallback(null, null)

          doRequestCurrentUser().then(null, errBack)

          $rootScope.$apply()

          expect(errBack).toHaveBeenCalled()
