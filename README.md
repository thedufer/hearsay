# Hearsay.js

A library for observing keys of objects.

## Stability

No. Don't use this. It doesn't even work yet. And the API will be heavily changing in the future.

## Shortcomings

**It does not handle cyclic observations**. It *will* at *some* point in the future. But as this was a "I need to start using this" sort of project I didn't bother to do that part right. As long as you never have an observation cycle, it will just work totally fine. By which I mean:

A `person` object has a slot, `boss`, that can hold a person. And that person becomes their own boss.

You `watch person, 'boss.name'` and everything will work if the person's boss changes or the person's name changes... but if you `watch person, 'boss.boss.name'`, you will get unexpected behavior if the person's `boss` slot changes.

# Concepts

## Slots

A slot is a container for a value. It has methods for mutating that value, and for observing changes to that value.

## Observations

An observation is an object with one method: `remove`. When you watch something, it returns an observation that you can use to stop watching that thing.

The mixin form of the API makes this easier if you want to do all of your cleanup in one place.

# API

Hearsay exports an object that looks like this:

    watch: (Object, (String | Array), Function, Object?) -> Observation
    mixin:
      watch: (Object, (String | Array), Function) -> Observation
      unwatch: () -> ()
    Slot: "Class"

`Function` refers to a function that takes one argument and returns nothing. The return value is ignored, so if you do return something it won't yell at you or anything. But you don't need to. Doesn't make sense.

## `Slot`

    new Slot: (Any) -> Slot
    slot.get: () -> Any
    slot.set: (Any) -> Any
    slot.watch: (Function, Object?) -> Observation

Example usage:

    name = new Slot "Emily"
    console.log name.get()
    >> Emily

    name.set "James"
    console.log name.get()
    >> James

    observation = name.watch (val) ->
      console.log "Name is #{val}"
    >> Name is James

    name.set "Mary"
    >> Name is Mary
    console.log name.get()
    >> Mary

    observation.remove()
    name.set "Penelope"
    console.log name.get()
    >> Penelope

The second argument to `watch` is the context with which the `callback` will be invoked.

## `watch`

`watch` is used for nested observation.

`watch` will invoke its callback as soon as it's added. Use a skip combinator if you don't want this behavior.

Don't forget to `.remove()` the observation returned by `watch`.

You can pass watch either a string of dot-separated keypaths or an array of strings (in case your keys have dots in them).

The last argument is the context with which the callback will be invoked.

## Mixin

A potentially nicer way to use Slots is as a mixin on your objects, as it can make cleanup easier.

This will introduce the `watch` and `unwatch` methods, and a variable used to maintain state called `_slot_observations`.

## `watch`

Usage:

    this.watch(target, 'foo.bar.baz', callback)

Adds a nested watcher. `callback` is always invoked with `this` as the context.

If `target` is omitted, `this` is assumed. Thus the following two lines are equivalent:

    this.watch('foo.bar.baz', callback)
    this.watch(this, 'foo.bar.baz', callback)

## `unwatch`

Removes all observations created via `this.watch`.

For more fine-grained watch-removal, hold onto the return value from `this.watch` and invoke its `remove` method.

# Why aren't you just using signal combinators

Shhhhh.
