angular.module('quizApp', ['xauth'])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      .when '/login',
        templateUrl: 'views/login.html',
        controller: 'LogInCtrl'
      .when '/signup',
        templateUrl: 'views/signup.html',
        controller: 'SignUpCtrl'
      .otherwise
        redirectTo: '/'
  .run (xAuthService, $location) ->
    $location.path('/login') if xAuthService.currentUser() == null
