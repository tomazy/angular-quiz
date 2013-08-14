describe 'Controller: SignUpCtrl', ->

  # load the controller's module
  beforeEach(module('quizApp'));

  SignUpCtrl = null
  scope = null
  location = null
  AuthService = null
  signupPromise = null

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new();
    location = jasmine.createSpyObj('location', ['path'])
    signupPromise = jasmine.createSpyObj('signupPromise', ['then'])
    AuthService =
      signup: jasmine.createSpy().andReturn(signupPromise)

    SignUpCtrl = $controller 'SignUpCtrl', $scope: scope, $location: location, AuthService: AuthService

  describe 'signup', ->

    context 'invalid', ->
      beforeEach -> scope.signup()

      it 'should not signup', ->
        expect(AuthService.signup).not.toHaveBeenCalled()
        expect(location.path).not.toHaveBeenCalled()

      it 'should have errors', ->
        expect(scope.errors.length).toBeGreaterThan(0)

    context 'valid', ->
      beforeEach ->
        scope.email = 'john@example.com'
        scope.password = 'password'
        scope.signup()

      it 'should not have errors', ->
        expect(scope.errors.length).toBe(0)

      it 'should signup', ->
        expect(AuthService.signup).toHaveBeenCalled()
        expect(signupPromise.then).toHaveBeenCalled()

      describe 'signup success', ->
        beforeEach ->
          signupSuccessCB = signupPromise.then.calls[0].args[0]
          signupSuccessCB()

        it 'should redirect to home page', ->
          expect(location.path).toHaveBeenCalledWith('/login')

      describe 'signup failure', ->
        beforeEach ->
          signupErrorCB = signupPromise.then.calls[0].args[1]
          signupErrorCB(message: 'WOA!')

        it 'should not redirect to home page', ->
          expect(location.path).not.toHaveBeenCalled()

        it 'should collect errors', ->
          expect(scope.errors).toEqual(['WOA!'])

