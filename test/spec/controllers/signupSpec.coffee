describe 'Controller: SignUpCtrl', ->

  beforeEach(module('quizApp'));

  SignUpCtrl = null

  Auth = null
  Flash = null
  scope = null
  location = null
  signupPromise = null

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new();
    location = jasmine.createSpyObj('location', ['path'])

    signupPromise = jasmine.createSpyObj('signupPromise', ['then'])
    Auth =
      signup: jasmine.createSpy().andReturn(signupPromise)

    Flash =
      now: jasmine.createSpyObj('Flash.now', ['error', 'reset'])
      future: jasmine.createSpyObj('Flash.now', ['success'])

    SignUpCtrl = $controller 'SignUpCtrl',
      $scope: scope
      $location: location
      Auth: Auth
      Flash: Flash

  describe 'signup', ->

    context 'invalid', ->
      beforeEach -> scope.signup()

      it 'should not signup', ->
        expect(Auth.signup).not.toHaveBeenCalled()
        expect(location.path).not.toHaveBeenCalled()

      it 'should have errors', ->
        expect(Flash.now.error).toHaveBeenCalled()

    context 'valid', ->
      beforeEach ->
        scope.email = 'john@example.com'
        scope.password = 'password'
        scope.signup()

      it 'should not have errors', ->
        expect(Flash.now.error).not.toHaveBeenCalled()

      it 'should signup', ->
        expect(Auth.signup).toHaveBeenCalled()
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
          expect(Flash.now.error).toHaveBeenCalledWith('WOA!')
