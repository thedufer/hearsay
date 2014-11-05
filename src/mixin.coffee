uniqueKey = require './utils/uniqueKey'
watch = require './watch'

remember = (target, observation) ->
  observationSet = (target._hearsay_observations ?= {})
  key = uniqueKey()
  observationSet[key] = observation
  return remove: ->
    observation.remove()
    delete observationSet[key]

module.exports =
  subscribe: (signal, callback) ->
    remember this, signal.subscribe(callback)

  watch: (target, path, callback) ->
    if arguments.length == 2
      callback = path
      path = target
      target = @

    remember this, watch(target, path, callback, this)

  unsubscribe: ->
    for key, observation of @_hearsay_observations
      observation.remove()
    delete @_hearsay_observations
    return
