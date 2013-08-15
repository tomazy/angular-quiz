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

  .constant('FIREBASE_URL', 'https://quiz-test.firebaseIO.com/')
  .constant('QUESTIONS', [
    {
      desc: "Which is not an advantage of using a closure?"
      options: [
        { desc: "Prevent pollution of global scope" },
        { desc: "Encapsulation" },
        { desc: "Private properties and methods" },
        { desc: "Allow conditional use of ‘strict mode’" },
      ]
    },
    {
      desc: "To create a columned list of two­line email subjects and dates for a master­detail view, which are the most semantically correct?"
      options: [
        { desc: "<div>+<span>" },
        { desc: "<tr>+<td>" },
        { desc: "<ul>+<li>" },
        { desc: "<p>+<br>" },
        { desc: "<p>+<br>" },
        { desc: "none of these" },
        { desc: "all of these" },
      ]
    },
    {
      desc: "To pass an array of strings to a function, you should not use..."
      options: [
        { desc: "fn.apply(this, stringsArray)" },
        { desc: "fn.call(this, stringsArray)" },
        { desc: "fn.bind(this, stringsArray)" },
      ]
    },
    {
      desc: "Given <div id=”outer”><div class=”inner”></div></div>, which of these two is the most performant way to select the inner div?"
      options: [
        { desc: "getElementById(\"outer\").children[0]" },
        { desc: "getElementsByClassName(\"inner\")[0]" },
      ]
    },
    {
      desc: "Given this:"
      example: """
      angular.module(‘myModule’).service(‘myService', function(){
        var message = "Message One!"
        var getMessage = function(){
          return this.message
        }
        this.message = "Message Two!"
        this.getMessage = function(){ return message }
        function(){
          {
            getMessage: getMessage,
            message: "Message Three!"
          }
        }
      }
      """
      instruction: "Which message will be returned by injecting this service and executing 'myService.getMessage()'?",
      options: [
        { desc: "\"Message One!\"" },
        { desc: "\"Message Two!\"" },
        { desc: "\"Message Three!\"" },
      ]
    },

  ])
