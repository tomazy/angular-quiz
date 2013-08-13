angular.module('xauth', []).
  factory 'xAuthService', ->
    service =
      currentUser: ->
        null
