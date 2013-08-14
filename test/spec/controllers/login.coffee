describe 'Controller: LogInCtrl', ->

  # load the controller's module
  beforeEach(module('quizApp'));

  LogInCtrl = null
  scope = null
  location = null
  AuthService = null
  loginPromise = null

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new();
    location = jasmine.createSpyObj('location', ['path'])
    loginPromise = jasmine.createSpyObj('loginPromise', ['then'])
    AuthService =
      login: jasmine.createSpy().andReturn(loginPromise)

    LogInCtrl = $controller 'LogInCtrl', $scope: scope, $location: location, AuthService: AuthService

  describe 'login', ->

    context 'invalid', ->
      beforeEach -> scope.login()

      it 'should not login', ->
        expect(AuthService.login).not.toHaveBeenCalled()
        expect(location.path).not.toHaveBeenCalled()

      it 'should have errors', ->
        expect(scope.errors.length).toBeGreaterThan(0)

    context 'valid', ->
      beforeEach ->
        scope.email = 'john@example.com'
        scope.password = 'password'
        scope.login()

      it 'should not have errors', ->
        expect(scope.errors.length).toBe(0)

      it 'should login', ->
        expect(AuthService.login).toHaveBeenCalled()
        expect(loginPromise.then).toHaveBeenCalled()

      describe 'login success', ->
        beforeEach ->
          loginSuccessCB = loginPromise.then.calls[0].args[0]
          loginSuccessCB()

        it 'should redirect to home page', ->
          expect(location.path).toHaveBeenCalledWith('/')

      describe 'login failure', ->
        beforeEach ->
          loginErrorCB = loginPromise.then.calls[0].args[1]
          loginErrorCB(message: 'WOA!')

        it 'should not redirect to home page', ->
          expect(location.path).not.toHaveBeenCalled()

        it 'should collect errors', ->
          expect(scope.errors).toEqual(['WOA!'])
