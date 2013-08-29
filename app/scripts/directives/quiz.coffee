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

  .directive 'questions', ->
    restrict: 'E'
    replace: true
    transclude: true
    template: "<ol type='1' ng-transclude></ol>"

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
      <li class="question">
        <fieldset ng-transclude ng-class="{invalid: quiz.correct[name].invalid}">
        </fieldset>
      </li>
      """
    link: (scope, element, attrs) ->
      scope.name = attrs.name

  .directive 'description', ->
    restrict: 'E'
    replace: true
    transclude: true
    template: "<div class='description' ng-transclude></div>"

  .directive 'choices', ->
    restrict: 'E'
    replace: true
    transclude: true
    template: "<ol type='a' ng-transclude></ol>"

  .directive 'choice', ->
    restrict: 'E',
    replace: true,
    transclude: true,
    require: '^question'
    scope: true
    template: """
    <li class="choice">
      <label class="checkbox"
         ng-class="{correct: quiz.correct[questionName].answers[answerName].correctValue, invalid: quiz.correct[questionName].answers[answerName].invalid}">
        <input type="checkbox" ng-disabled="quiz.disabled" ng-model="quiz.response[questionName][answerName]">
        <span ng-transclude></span>
      </label>
    </li>
    """
    link: (scope, element, attrs, question) ->
      scope.questionName = question.name
      scope.answerName = attrs.value

  .directive 'inlineAnswer', ->
    restrict: 'E',
    replace: true,
    transclude: true,
    require: '^question'
    scope: true
    template: """
      <input class="inline-answer" type="text" ng-disabled="quiz.disabled"
        ng-class="{invalid: quiz.correct[questionName].answers[answerName].invalid}"
        title="{{'correct answer: ' + quiz.correct[questionName].answers[answerName].correctValue}}"
        ng-model="quiz.response[questionName][answerName]">
    """
    link: (scope, element, attrs, question) ->
      scope.questionName = question.name
      scope.answerName = attrs.name
