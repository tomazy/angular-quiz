describe 'Directives', ->

  beforeEach ->
    @addMatchers
      toHaveClass: (cls) ->
        @message = () ->
          "Expected '#{angular.mock.dump(@actual)}' to have class '#{cls}'"
        @actual.hasClass(cls)

  describe '<quiz>', ->
    elem = scope = null

    beforeEach module('quizApp')

    beforeEach inject ($rootScope, $compile) ->
      elem = angular.element """
        <div>
          <quiz>
            <child></child>
          </quiz>
        </div>
        """
      scope = $rootScope
      $compile(elem)(scope)
      scope.$digest()

    it 'should create correct markup', ->
      divs = elem.find('div')
      expect(divs.length).toBe(1)
      expect(divs).toHaveClass('quiz')

    it 'should transclude', ->
      children = elem.find('div').find('child')
      expect(children.length).toBe(1)

    it 'should setup quiz', ->
      expect(scope.quiz).toBeDefined()
      expect(scope.quiz.response).toBeDefined()
