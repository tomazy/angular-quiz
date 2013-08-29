msie = parseInt((/msie (\d+)/.exec(navigator.userAgent.toLowerCase()) || [])[1], 10);

angular.scenario.dsl 'waitFor', ->
  (name, check, timout = 5) ->
    @addFutureAction "wait for #{name}", ($window, $document, done) ->
      currTime = -> (new Date).getTime()
      finish = currTime() + 5 * 1000

      test = ->
        if currTime() > finish
          done "Timed out waiting for #{name}"
        else if check($window, $document)
          done()
        else
          setTimeout(test, 100)

      test()

# preserve the old 'input' under different name
angular.scenario.dsl 'modelInput', angular.scenario.dsl['input']

# define new 'input' using selectors
angular.scenario.dsl 'input', ->
  chain = {}
  supportInputEvent = 'oninput' of document.createElement('div') and msie != 9

  chain.enter = (value, event) ->
    @addFutureAction "input '#{@label}' enter '#{value}'", ($window, $document, done) ->
      input = $document.elements().filter(':input')
      input.val(value)
      input.trigger(event || (if supportInputEvent then 'input' else 'change'))
      done()

  chain.check = ->
    @addFutureAction "checkbox '#{@label}' toggle", ($window, $document, done) ->
      input = $document.elements().filter(':checkbox')
      input.trigger('click')
      done()

  chain.select = (value) ->
    @addFutureAction "radio button '#{@label}' toggle '#{value}'", ($window, $document, done) ->
      input = $document.elements().filter("[value=\"#{value}\"]").filter(':radio')
      input.trigger('click')
      done()

  chain.val = ->
    @addFutureAction "return input val", ($window, $document, done) ->
      input = $document.elements().filter(':input')
      done(null, input.val())

  (selector, label) ->
    @dsl.using selector, label
    chain

angular.scenario.dsl 'testInput', ->
  (dataTest, label) -> input "[data-test=\"#{dataTest}\"]", label

angular.scenario.dsl 'testElement', ->
  (dataTest, label) -> element "[data-test=\"#{dataTest}\"]", label
