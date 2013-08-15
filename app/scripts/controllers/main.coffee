angular.module('quizApp').controller 'MainCtrl', ($scope, QUESTIONS) ->
  $scope.questions = QUESTIONS
  $scope.awesomeThings = [
    'HTML5 Boilerplate',
    'AngularJS',
    'Karma'
  ]
