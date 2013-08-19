angular.module('quizApp', ['ng-firebase', 'ng-firebase-simple-login'])
  .config ($routeProvider) ->
    currUser = (AuthService) ->
      AuthService.requestCurrentUser()
    currUser.$inject = ['AuthService'] # help the minifiers

    $routeProvider

      .when '/',
        templateUrl: 'views/main.html',
        controller: 'MainCtrl',
        resolve:
          currentUser: currUser

      .when '/login',
        templateUrl: 'views/login.html',
        controller: 'LogInCtrl'

      .when '/signup',
        templateUrl: 'views/signup.html',
        controller: 'SignUpCtrl'

      .otherwise
        redirectTo: '/'

  .constant('FIREBASE_URL', '@@FIREBASE_URL')
