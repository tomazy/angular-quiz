DEF_EMAIL = 'tomek@example.com'
DEF_PASS = 'password'

class BasePage
  logout: ->
    element('[data-test="logout"]').click()

class HomePage extends BasePage
  title: ->
    element('h1').text()

  expectToBeDisplayed: ->
    expect(@title()).toBe('Welcome to the Quiz!')

class LoginPage extends BasePage
  title: ->
    element('legend').text()

  goToSignUpPage: ->
    element('[data-test="signup"]').click()

  expectToBeDisplayed: ->
    expect(@title()).toBe('Log in')

  login: (email = DEF_EMAIL, pass = DEF_PASS, done) ->
    input('email').enter(email)
    input('password').enter(pass)
    element('[data-test="login"]').click()

class SignUpPage extends BasePage
  title: ->
    element('legend').text()

  expectToBeDisplayed: ->
    expect(@title()).toBe('Sign up')

homePage = -> new HomePage
loginPage = -> new LoginPage
signupPage = -> new SignUpPage
currentPage = -> new BasePage

describe 'Quiz App', ->
  currentPath = ->
    browser().location().url()

  beforeEach ->
    browser().navigateTo('/')
    currentPage().logout()

  it 'should redirect to login page if not logged in', ->
    browser().navigateTo('#/')
    loginPage().expectToBeDisplayed()

  describe 'Logging in', ->

    beforeEach ->
      browser().navigateTo('#/login')
      loginPage().expectToBeDisplayed()

    it 'should allow to sign up', ->
      loginPage().goToSignUpPage()
      signupPage().expectToBeDisplayed()

    it 'should allow to login', ->
      loginPage().login()
      sleep(3) # grrr
      homePage().expectToBeDisplayed()

  describe 'When logged in', ->
    beforeEach ->
      browser().navigateTo('#/login')
      loginPage().login()

    it 'should allow to logout', ->
      currentPage().logout()
      loginPage().expectToBeDisplayed()
