angular.module('quizApp')

  .directive 'quiz', ->
    restrict: 'E'
    replace: true
    transclude: true
    controller: ($scope) ->
      $scope.quiz ||= {}
      $scope.quiz.response ||= {}
      @
    template: "<div class='quiz' ng-transclude></div>"

  .directive 'question', ->
    restrict: 'E'
    replace: true
    transclude: true
    controller: ($scope, $attrs) ->
      @name = $attrs.name
      $scope.quiz.response[@name] ||= {}
      @
    scope: true
    template: """
      <fieldset class="question" ng-transclude ng-class="{invalid: quiz.correct[name].invalid}">
      </fieldset>
      """
    link: (scope, element, attrs) ->
      scope.name = attrs.name

  .directive 'choice', ->
    restrict: 'A',
    replace: false,
    transclude: true,
    require: '^question'
    scope: true
    template: """
      <label class="checkbox"
         ng-class="{correct: quiz.correct[questionName].answers[answerName].correctValue,
                    invalid: quiz.correct[questionName].answers[answerName].invalid}">
        <input type="checkbox" ng-disabled="quiz.disabled" ng-model="quiz.response[questionName][answerName]">
        <span ng-transclude></span>
      </label>
    """
    link: (scope, element, attrs, question) ->
      scope.questionName = question.name
      scope.answerName = attrs.value

  .directive 'inlineAnswer', ->
    restrict: 'E',
    replace: true,
    transclude: false,
    require: '^question'
    scope: true
    template: """
      <input class="inline-answer" type="text" ng-disabled="quiz.disabled"
        ng-class="{invalid: quiz.correct[questionName].answers[answerName].invalid}"
        ng-model="quiz.response[questionName][answerName]">
    """
    link: (scope, element, attrs, question) ->
      scope.questionName = question.name
      scope.answerName = attrs.name
      scope.$watch 'quiz.correct[questionName].answers[answerName].correctValue', (value) ->
        attrs.$set('title', (value and "Correct answer: #{value}") or '')
