angular.module('quizApp')
  .factory 'DBConnection', (Firebase, FIREBASE_URL) ->
    new Firebase(FIREBASE_URL)

  .factory 'DB', (DBConnection, safeApply, $q, $log) ->
    conn = DBConnection

    db =
      read: (resource) ->
        deferred = $q.defer()

        conn.child(resource).on 'value', (snapshot) ->
          data = snapshot.val()
          $log.log("db: loaded #{resource} #{data}")

          safeApply ->
            deferred.resolve data

        deferred.promise

      write: (resource, data) ->
        deferred = $q.defer()

        link = conn.child(resource)
        link.set data, (error) ->
          safeApply ->
            if error
              deferred.reject(error)
            else
              deferred.resolve(true)

        deferred.promise
