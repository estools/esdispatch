suite 'Dispatch', ->

  test 'basic dispatch', (done) ->
    dispatcher = new ESDispatcher
    dispatcher.on 'Program', -> do done
    dispatcher.observe esprimaAST

  test 'completion function', (done) ->
    dispatcher = new ESDispatcher
    dispatcher.observe esprimaAST, -> do done

  test 'basic dispatch', (done) ->
    dispatcher = new ESDispatcher
    counter = 0
    dispatcher.on 'Program', -> ++counter
    dispatcher.observe esprimaAST, ->
      eq 1, counter
      do done

  test 'lots of dispatch', (done) ->
    dispatcher = new ESDispatcher
    counter = 0
    dispatcher.on 'Identifier', -> ++counter
    dispatcher.observe esprimaAST, ->
      eq 4946, counter
      do done

  test 'complex selectors', (done) ->
    dispatcher = new ESDispatcher
    counter = 0
    dispatcher.on 'UpdateExpression[operator="++"] > Identifier[name=i]', -> ++counter
    dispatcher.observe esprimaAST, ->
      eq 4, counter
      do done

  test 'multiple handlers', (done) ->
    dispatcher = new ESDispatcher
    iCounter = 0
    kCounter = 0
    eCounter = 0
    dispatcher.on 'Identifier[name=i]', -> ++iCounter
    dispatcher.on 'Identifier[name=k]', -> ++kCounter
    dispatcher.on 'Identifier[name=e]', -> ++eCounter
    dispatcher.observe esprimaAST, ->
      eq 26, iCounter
      eq 0, kCounter
      eq 8, eCounter
      do done

  test 'multiple handlers using the same selector', (done) ->
    dispatcher = new ESDispatcher
    counter = 0
    dispatcher.on 'Identifier[name=e]', -> ++counter
    dispatcher.on 'Identifier[name=e]', -> ++counter
    dispatcher.on 'Identifier[name=e]', -> ++counter
    dispatcher.observe esprimaAST, ->
      eq 24, counter
      do done

  test 'one-time dispatch', (done) ->
    dispatcher = new ESDispatcher
    counter = 0
    dispatcher.once 'Identifier', -> ++counter
    dispatcher.observe esprimaAST, ->
      eq 1, counter
      do done
