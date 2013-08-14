angular.module('quizApp', ['ng-firebase', 'ng-firebase-simple-login'])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html',
        controller: 'MainCtrl',
        resolve: {
          currentUser: (AuthService) ->
            AuthService.requestCurrentUser()
        }
      .when '/login',
        templateUrl: 'views/login.html',
        controller: 'LogInCtrl'
      .when '/signup',
        templateUrl: 'views/signup.html',
        controller: 'SignUpCtrl'
      .otherwise
        redirectTo: '/'
  .constant('FIREBASE_URL', 'https://quiz-test.firebaseIO.com/')
