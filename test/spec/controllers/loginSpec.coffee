describe 'Controller: LogInCtrl', ->

  # load the controller's module
  beforeEach(module('quizApp'));

  LogInCtrl = null
  scope = null
  location = null
  Auth = null
  loginPromise = null
  Flash = null

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new();
    location = jasmine.createSpyObj('location', ['path'])

    loginPromise = jasmine.createSpyObj('loginPromise', ['then'])
    Auth =
      login: jasmine.createSpy().andReturn(loginPromise)

    Flash =
      now: jasmine.createSpyObj('Flash.now', ['error', 'reset'])
      future: jasmine.createSpyObj('Flash.now', ['success'])

    LogInCtrl = $controller 'LogInCtrl',
      $scope: scope
      $location: location
      Auth: Auth
      Flash: Flash

  describe 'login', ->

    context 'invalid', ->
      beforeEach -> scope.login()

      it 'should not login', ->
        expect(Auth.login).not.toHaveBeenCalled()
        expect(location.path).not.toHaveBeenCalled()

      it 'should have errors', ->
        expect(Flash.now.error).toHaveBeenCalled()

    context 'valid', ->
      beforeEach ->
        scope.email = 'john@example.com'
        scope.password = 'password'
        scope.login()

      it 'should not have errors', ->
        expect(Flash.now.error).not.toHaveBeenCalled()

      it 'should login', ->
        expect(Auth.login).toHaveBeenCalled()
        expect(loginPromise.then).toHaveBeenCalled()

      describe 'login success', ->
        beforeEach ->
          loginSuccessCB = loginPromise.then.calls[0].args[0]
          loginSuccessCB()

        it 'should redirect to home page', ->
          expect(location.path).toHaveBeenCalledWith('/')

        it 'should flash a message', ->
          expect(Flash.future.success).toHaveBeenCalled()

      describe 'login failure', ->
        beforeEach ->
          loginErrorCB = loginPromise.then.calls[0].args[1]
          loginErrorCB(message: 'WOA!')

        it 'should not redirect to home page', ->
          expect(location.path).not.toHaveBeenCalled()

        it 'should collect errors', ->
          expect(Flash.now.error).toHaveBeenCalledWith('WOA!')
