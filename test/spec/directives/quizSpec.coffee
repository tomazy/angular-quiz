describe 'Directives', ->
  dump = (arg) ->
    console.log angular.mock.dump(arg)

  beforeEach ->
    @addMatchers
      toHaveClass: (cls) ->
        @message = () ->
          "Expected '#{angular.mock.dump(@actual)}' to have class '#{cls}'"
        @actual.hasClass(cls)

  markup = scope = extendScope = null

  beforeEach ->
    markup = scope = extendScope = null

  element = ->
    result = null
    inject ($rootScope, $compile) ->
      scope = $rootScope.$new()
      angular.extend(scope, extendScope)

      result = angular.element markup

      $compile(result)(scope)

      scope.$digest()
    result

  beforeEach module('quizApp')

  describe '<quiz>', ->

    beforeEach ->
      markup = """
        <div>
          <quiz>
            <child></child>
          </quiz>
        </div>
        """

    it 'should create correct markup', ->
      els = element().find('div')
      expect(els.length).toBe(1)
      expect(els).toHaveClass('quiz')

    it 'should transclude', ->
      children = element().find('div').find('child')
      expect(children.length).toBe(1)

    it 'should setup quiz', ->
      element()
      expect(scope.quiz).toBeDefined()
      expect(scope.quiz.response).toBeDefined()

  describe '<question>', ->
    beforeEach ->
      extendScope =
        quiz:
          response: {}
          correct: {}

      markup = """
        <div>
          <question name="q1">
            <child></child>
          </question>
        </div>
        """

    it 'should create correct markup', ->
      els = element().find('fieldset')
      expect(els.length).toBe(1)
      expect(els).toHaveClass('question')

    it 'should transclude', ->
      children = element().find('fieldset').find('child')
      expect(children.length).toBe(1)

    it 'should setup scope', ->
      els = element().find('fieldset')
      expect(els.scope().name).toBe('q1')

    context 'invalid question', ->
      beforeEach ->

      it 'should mark the question', ->
        els = element().find('fieldset')
        expect(els).not.toHaveClass('invalid')

        scope.$apply ->
          scope.quiz.correct.q1 = invalid: true

        expect(els).toHaveClass('invalid')

    describe 'answers', ->
      describe 'choice', ->
        beforeEach ->
          markup = """
            <question name="CHOICE">
              <div choice value="X">
                <child></child>
              </div>
            </question>
          """

        it 'should create correct markup', ->
          els = element().find('label')
          expect(els.length).toBe(1)
          expect(els).toHaveClass('checkbox')

          els = element().find('input')
          expect(els.length).toBe(1)
          expect(els.attr('type')).toEqual('checkbox')

        it 'should transclude', ->
          children = element().find('child')
          expect(children.length).toBe(1)

        it 'should setup scope', ->
          els = element().find('label')
          expect(els.scope().questionName).toBe('CHOICE')
          expect(els.scope().answerName).toBe('X')

        it 'should react to disabled quiz', ->
          els = element().find('input')
          expect(els.attr('disabled')).toBeFalsy()

          scope.$apply ->
            scope.quiz.disabled = true

          expect(els.attr('disabled')).toBeTruthy()

        it 'should reflect correct value', ->
          els = element().find('label')
          expect(els).not.toHaveClass('correct')

          scope.$apply ->
            scope.quiz.correct.CHOICE =
              answers:
                X:
                  correctValue: true

          expect(els).toHaveClass('correct')

        it 'should reflect invalid flag', ->
          els = element().find('label')
          expect(els).not.toHaveClass('invalid')

          scope.$apply ->
            scope.quiz.correct.CHOICE =
              answers:
                X:
                  invalid: true

          expect(els).toHaveClass('invalid')

        it 'should work with the model', ->
          els = element().find('input')
          expect(els.attr('checked')).toBeFalsy()

          scope.$apply ->
            scope.quiz.response.CHOICE.X = true

          expect(els.attr('checked')).toBeTruthy()


      describe '<inline-answer>', ->
        beforeEach ->
          markup = """
            <question name="INLINE_QUESTION">
              <inline-answer name="Y">
                <child></child>
              </inline-answer>
            </question>
          """

        it 'should create correct markup', ->
          els = element().find('input')
          expect(els.length).toBe(1)
          expect(els).toHaveClass('inline-answer')
          expect(els.attr('type')).toEqual('text')

        it 'should not transclude', ->
          children = element().find('child')
          expect(children.length).toBe(0)

        it 'should setup scope', ->
          els = element().find('input')
          expect(els.scope().questionName).toBe('INLINE_QUESTION')
          expect(els.scope().answerName).toBe('Y')

        it 'should work with the model', ->
          els = element().find('input')
          expect(els.val()).toEqual('')

          scope.$apply ->
            scope.quiz.response.INLINE_QUESTION.Y = 'abc'

          expect(els.val()).toEqual('abc')

        it 'should reflect correct value', ->
          els = element().find('input')
          expect(els.attr('title')).toEqual('')

          scope.$apply ->
            scope.quiz.correct.INLINE_QUESTION =
              answers:
                Y:
                  correctValue: 'XYZ'

          expect(els.attr('title')).toMatch(/XYZ/)

        it 'should reflect invalid flag', ->
          els = element().find('input')
          expect(els).not.toHaveClass('invalid')

          scope.$apply ->
            scope.quiz.correct.INLINE_QUESTION =
              answers:
                Y:
                  invalid: true

          expect(els).toHaveClass('invalid')
