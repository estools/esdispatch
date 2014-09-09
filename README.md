# esdispatch

Trigger events based on [esquery](https://github.com/jrfeenst/esquery) selectors during a traversal of a [SpiderMonkey format AST](https://developer.mozilla.org/en-US/docs/SpiderMonkey/Parser_API).



## Install

    npm install --save esdispatch



## Examples

```js
var counter = 0, dispatcher = new ESDispatcher;
dispatcher.on(
  'UpdateExpression[operator="++"] > Identifier[name=i]',
  function(node, ancestors) { ++counter; }
);
dispatcher.observe(spidermonkeyAST, function() {
  counter; // 4
});
```



## API

#### `new ESDispatcher` → ESDispatcher instance
The ESDispatcher constructor takes no arguments.

#### `ESDispatcher::addListener(selector, listener)` → void
Invoke `listener` whenever esdispatch walks over a node that matches
`selector`. `listener` is given two arguments: the node that matched the
selector, and a list containing the ancestors of that node. `listener` may also
be an object containing an `enter` and, optionally, a `leave` function. In that
case, the `enter` function will be called in pre-order, and the `leave`
function will be called in post-order. Aliased as `ESDispatcher::on`.

#### `ESDispatcher::once(selector, listener)` → void
Adds a listener that is invoked only the first time `selector` matches.

#### `ESDispatcher::observe(ast, onFinished)` → void
Begin a traversal using the given SpiderMonkey AST, triggering any listeners
associated with matching queries. `onFinished`, if given, is called with no
arguments once the traversal is completed.
