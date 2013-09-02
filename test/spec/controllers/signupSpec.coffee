describe 'Controller: SignUpCtrl', ->

  beforeEach(module('quizApp'));

  ctrl = null

  Auth = null
  Flash = null
  location = null
  signupPromise = null

  beforeEach inject ($controller) ->
    location = jasmine.createSpyObj('location', ['path'])

    signupPromise = jasmine.createSpyObj('signupPromise', ['then'])
    Auth =
      signup: jasmine.createSpy().andReturn(signupPromise)

    Flash =
      now: jasmine.createSpyObj('Flash.now', ['error', 'reset'])
      future: jasmine.createSpyObj('Flash.now', ['success'])

    ctrl = $controller 'SignUpCtrl',
      $location: location
      Auth: Auth
      Flash: Flash

  describe 'signup', ->

    context 'valid', ->
      beforeEach ->
        ctrl.email = 'john@example.com'
        ctrl.password = 'password'
        ctrl.signup()

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
