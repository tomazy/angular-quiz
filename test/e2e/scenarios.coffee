describe 'Quiz App', ->

  beforeEach ->
    browser().navigateTo('/')

  currentPath = ->
    browser().location().url()


  it 'should redirect to login page if not logged in', ->
    expect(currentPath()).toBe("/login")
    sleep(2)
    browser().navigateTo('#/')
    sleep(2)
    expect(currentPath()).toBe("/login")

  describe 'Login page', ->

    signupLink = ->
      element('[data-test="signup"]')

    beforeEach ->
      browser().navigateTo('#/login')

    it 'should allow to sign up', ->
      signupLink().click()
      expect(currentPath()).toBe("/signup")

