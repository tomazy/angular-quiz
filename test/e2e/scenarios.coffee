describe 'Quiz App', ->

  beforeEach ->
    browser().navigateTo('/')

  currentPath = ->
    browser().location().url()


  it 'should redirect to login page if not logged in', ->
    expect(currentPath()).toBe("/login")
    browser().navigateTo('#/')
    expect(currentPath()).toBe("/login")

  describe 'Login page', ->

    signupLink = ->
      element('[data-test="signup"]')

    beforeEach ->
      browser().navigateTo('#/login')

    it 'should allow to sign up', ->
      signupLink().click()
      expect(currentPath()).toBe("/signup")


    it 'should allow to login', ->
      input('email').enter('tomek@example.com')
      input('password').enter('password')
      element('[data-test="login"]').click()
      expect(currentPath()).toBe("/")
