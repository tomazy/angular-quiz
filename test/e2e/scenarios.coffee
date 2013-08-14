describe 'Quiz App', ->
  DEF_EMAIL = 'tomek@example.com'
  DEF_PASS = 'password'

  currentPath = ->
    browser().location().url()

  login = (email = DEF_EMAIL, pass = DEF_PASS, done) ->
    input('email').enter(email)
    input('password').enter(pass)
    element('[data-test="login"]').click()

  logout = ->
    element('[data-test="logout"]').click()

  beforeEach ->
    browser().navigateTo('/')
    logout()

  it 'should redirect to login page if not logged in', ->
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
      login()
      sleep(3)
      expect(currentPath()).toBe("/")

  describe 'When logged in', ->
    beforeEach ->
      browser().navigateTo('#/login')
      login()

    it 'should allow to logout', ->
      logout()
      expect(currentPath()).toBe("/login")
