angular.module('quizApp')

  .controller 'AppCtrl', ($scope, $location, Auth, Flash) ->

    $scope.$on 'authStatusChanged', (_, currUser) ->
      if currUser
        $scope.currentUser = currUser.email || currUser.id
      else
        $scope.currentUser = null

    $scope.$on '$routeChangeError', (event, current, previous, rejection) ->
      Flash.future.error('You must be logged in to access this page')
      $location.path('/login') if rejection.reason == 'ACCESS_DENIED'

    $scope.logout = ->
      Auth.logout()
      $location.path('/login')
