angular.module('quizApp', ['ng-firebase', 'ng-firebase-simple-login'])
  .config ($routeProvider) ->
    requireCurrentUser = (Auth) ->
      Auth.requestCurrentUser()
    requireCurrentUser.$inject = ['Auth'] # help the minifiers

    $routeProvider

      .when '/',
        templateUrl: 'views/main.html',
        controller: 'MainCtrl',
        resolve:
          currentUser: requireCurrentUser

      .when '/login',
        templateUrl: 'views/login.html',
        controller: 'LogInCtrl'

      .when '/signup',
        templateUrl: 'views/signup.html',
        controller: 'SignUpCtrl'

      .otherwise
        redirectTo: '/'

  .constant('FIREBASE_URL', '@@FIREBASE_URL')
