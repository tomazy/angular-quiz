angular.module('quizApp', ['ng-firebase', 'ng-firebase-simple-login'])

  .constant('FIREBASE_URL', '@@FIREBASE_URL')

  .config ($routeProvider) ->
    requireCurrentUser = (Auth) ->
      Auth.requestCurrentUser()
    requireCurrentUser.$inject = ['Auth'] # help the minifiers

    $routeProvider
      .when '/',
        templateUrl: 'views/quiz.html'
        controller: 'QuizCtrl'
        resolve:
          currentUser: requireCurrentUser

      .when '/login',
        templateUrl: 'views/login.html'
        controller: 'LogInCtrl'
        controllerAs: 'ctrl'

      .when '/signup',
        templateUrl: 'views/signup.html'
        controller: 'SignUpCtrl'
        controllerAs: 'ctrl'

      .when '/quiz/:quizId',
        templateUrl: 'views/quiz.html'
        controller: 'QuizCtrl'
        resolve:
          currentUser: requireCurrentUser

      .otherwise
        redirectTo: '/'
