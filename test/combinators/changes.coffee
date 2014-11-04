changes = require 'hearsay/combinators/changes'
Emitter = require 'hearsay/emitter'
Slot = require 'hearsay/slot'
{ assert } = require 'chai'

describe "change", ->
  it "only sends changes", ->
    slot = new Slot(1)
    vals = []

    subscription = changes(slot).subscribe (val) ->
      vals.push val

    assert.deepEqual vals, []

    slot.set 2
    slot.set 3
    slot.set 4
    assert.deepEqual vals, [[1, 2], [2, 3], [3, 4]]

    subscription.remove()

