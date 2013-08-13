angular.module('quizApp', []).
  config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      .when '/signup',
        templateUrl: 'views/signup.html',
        controller: 'SignUpCtrl'
      .otherwise
        redirectTo: '/'
