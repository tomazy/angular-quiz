describe 'Quiz App', ->

  beforeEach ->
    browser().navigateTo('/')


  it 'should redirect to login page if not logged in', ->
    expect(browser().location().url()).toBe("/login")
    expect(true).toBe(false)
