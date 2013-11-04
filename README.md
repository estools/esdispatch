# esdispatch

Trigger events based on [esquery](https://github.com/jrfeenst/esquery) selectors during a traversal of a [SpiderMonkey format AST](https://developer.mozilla.org/en-US/docs/SpiderMonkey/Parser_API).



## Install

    npm install --save esdispatch



## Examples

```coffee
dispatcher = new ESDispatcher
counter = 0
dispatcher.on 'UpdateExpression[operator="++"] > Identifier[name=i]', -> ++counter
dispatcher.observe esprimaAST, ->
  eq 4, counter
  do done
```



## API

#### `new ESDispatcher` → ESDispatcher instance
The ESDispatcher constructor takes no arguments.

#### `ESDispatcher::addListener(selector, listener)` → void
Invoke `listener` whenever esdispatch walks over a node that matches
`selector`. `listener` is given three arguments: `null`, the node that matched
the selector, and a list containing the ancestors of that node. Aliased as
`ESDispatcher::on`.

#### `ESDispatcher::once(selector, listener)` → void
Adds a listener that is invoked only the first time `selector` matches.

#### `ESDispatcher::observe(ast, onFinished)` → void
Begin a traversal using the given SpiderMonkey AST, triggering any listeners
associated with matching queries. `onFinished`, if given, is called with no
arguments once the traversal is completed.
