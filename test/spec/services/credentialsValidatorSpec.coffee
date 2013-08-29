describe 'Service: credentialsValidator', ->

  data = null

  beforeEach(module('quizApp'))

  beforeEach ->
    data =
      email: "email"
      password: "password"

  describe "validation", ->
    onError = null

    validate = ->
      result = null
      inject (CredentialsValidator) ->
        result = CredentialsValidator.validate(data, onError)
      result

    beforeEach ->
      onError = jasmine.createSpy('onError')

    it "should not return errors when password and email are set", ->
      expect(validate()).toBe(true)
      expect(onError).not.toHaveBeenCalled()

    describe "Password", ->

      it "should return error when there is no password", ->
        data.password = null
        expect(validate()).toBe(false)
        expect(onError).toHaveBeenCalled()
        expect(onError.callCount).toEqual(1)
        expect(onError.mostRecentCall.args[0]).toMatch(/password/)

    describe "Email", ->

      it "should return error when there is no email", ->
        data.email = null
        expect(validate()).toBe(false)
        expect(onError).toHaveBeenCalled()
        expect(onError.callCount).toEqual(1)
        expect(onError.mostRecentCall.args[0]).toMatch(/email/)
