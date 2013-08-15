describe 'Controller: MainCtrl', ->

  # load the controller's module
  beforeEach(module('quizApp'));

  MainCtrl = null
  scope = null

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new();
    MainCtrl = $controller 'MainCtrl', $scope: scope
