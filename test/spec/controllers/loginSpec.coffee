describe 'Controller: LogInCtrl', ->

  beforeEach(module('quizApp'));

  ctrl = null

  Auth = null
  Flash = null
  location = null
  loginPromise = null

  beforeEach inject ($controller) ->
    location = jasmine.createSpyObj('location', ['path'])

    loginPromise = jasmine.createSpyObj('loginPromise', ['then'])
    Auth =
      login: jasmine.createSpy('Auth.login').andReturn(loginPromise)

    Flash =
      now: jasmine.createSpyObj('Flash.now', ['error', 'reset'])
      future: jasmine.createSpyObj('Flash.now', ['success'])

    ctrl = $controller 'LogInCtrl',
      $location: location
      Auth: Auth
      Flash: Flash

  describe 'login', ->

    context 'valid', ->
      beforeEach ->
        ctrl.email = 'john@example.com'
        ctrl.password = 'password'
        ctrl.login()

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
