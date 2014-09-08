esquery = require 'esquery'
estraverse = require 'estraverse'

parsedSelectors = {}

module.exports = class ESDispatcher
  @ESDispatcher: this
  constructor: ->
    @_listeners = {}

  listeners: (selector) -> @_listeners[selector]

  addListener: addListener = (selector, listener) ->
    parsedSelectors[selector] ?= esquery.parse selector
    @_listeners[selector] ?= []
    @_listeners[selector].push listener
    return

  on: addListener

  removeListener: removeListener = (selector, listener) ->
    return unless @_listeners[selector]?
    idx = @_listeners[selector].indexOf listener
    return unless idx > -1
    @_listeners[selector].splice idx, 1
    return

  removeAllListeners: (selector) ->
    if selector? then delete @_listeners[selector] else @_listeners = {}
    return

  once: (selector, listener) ->
    wrapper = =>
      removeListener.call this, selector, wrapper
      listener.apply this, arguments
    addListener.call this, selector, wrapper

  observe: (ast, done) ->
    ancestry = []
    estraverse.traverse ast,
      enter: (node, parent) =>
        if parent? then ancestry.unshift parent
        for own selector, listeners of @_listeners
          if esquery.matches node, parsedSelectors[selector], ancestry
            for listener in listeners
              listener node, ancestry
        return
      leave: ->
        do ancestry.shift
        return
    do done if done?
    return
