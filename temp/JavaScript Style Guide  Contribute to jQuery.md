# JavaScript Style Guide | Contribute to jQuery

> Use JSHint to detect errors and potential problems. Every jQuery project has a Grunt task for linting all JavaScript files: grunt jshint. The options for JSHint are stored in a .jshintrc file; many repositories will have multiple .jshintrc files based on the type of code in each directory.

* * *

- [JavaScript Style Guide | Contribute to jQuery](#javascript-style-guide--contribute-to-jquery)
  - [link Linting](#link-linting)
  - [link Spacing](#link-spacing)
    - [link Bad Examples](#link-bad-examples)
    - [link Good Examples](#link-good-examples)
    - [link Object and Array Expressions](#link-object-and-array-expressions)
    - [link Chained Method Calls](#link-chained-method-calls)
    - [link Full File Closures](#link-full-file-closures)
  - [link Constructors](#link-constructors)
  - [link Equality](#link-equality)
  - [link Type Checks](#link-type-checks)
  - [link Comments](#link-comments)
  - [link Quotes](#link-quotes)
  - [link Semicolons](#link-semicolons)
  - [link Naming Conventions](#link-naming-conventions)
  - [link Global Variables](#link-global-variables)
  - [link DOM Node Rules](#link-dom-node-rules)
  - [link Switch Statements](#link-switch-statements)

[link](#linting) Linting
------------------------

Use JSHint to detect errors and potential problems. Every jQuery project has a Grunt task for linting all JavaScript files: `grunt jshint`. The options for JSHint are stored in a `.jshintrc` file; many repositories will have multiple `.jshintrc` files based on the type of code in each directory.

Each `.jshintrc` file follows a specific format. All options must be alphabetized and grouped:



The following common options must be used in all projects:



_If the project supports browsers which do not implement ES5, then the `es3` option must be included with the repo-specific options._

[link](#spacing) Spacing
------------------------

In general, the jQuery style guide encourages liberal spacing for improved human readability. The minification process creates a file that is optimized for browsers to read and process.

*   Indentation with tabs.
*   No whitespace at the end of line or on blank lines.
*   Lines should be no longer than 80 characters, and must not exceed 100 (counting tabs as 4 spaces). There are 2 exceptions, both allowing the line to exceed 100 characters:
    *   If the line contains a comment with a long URL.
    *   If the line contains a regex literal. This prevents having to use the regex constructor which requires otherwise unnecessary string escaping.
*   `if`/`else`/`for`/`while`/`try` always have braces and always go on multiple lines.
*   Unary special-character operators (e.g., `!`, `++`) must not have space next to their operand.
*   Any `,` and `;` must not have preceding space.
*   Any `;` used as a statement terminator must be at the end of the line.
*   Any `:` after a property name in an object definition must not have preceding space.
*   The `?` and `:` in a ternary conditional must have space on both sides.
*   No filler spaces in empty constructs (e.g., `{}`, `[]`, `fn()`)
*   New line at the end of each file.
*   If the entire file is wrapped in a closure, the function body is not indented. See [full file closures](#full-file-closures) for examples.

### [link](#bad-examples) Bad Examples
```js

```
### [link](#good-examples) Good Examples
```js
<pre><code>} else if ( otherCondition ) {</code><code>    object[ array[ i ] ] = someFn( i );</code><code>foo( options, object[ property ] );</code><code>foo( [ a, b ], "property", { c: d } );</code><code>foo( { a: "alpha", b: "beta" } );</code></pre>
```
### [link](#object-and-array-expressions) Object and Array Expressions

Object and array expressions can be on one line if they are short (remember the line length limits). When an expression is too long to fit on one line, there must be one property or element per line, with the opening and closing braces each on their own lines. Property names only need to be quoted if they are reserved words or contain special characters:

<pre><code>    when: 4, "you are": 15 };</code><code>map = { ready: 9, when: 4, "you are": 15 };</code><code>array = [ { key: val } ];</code><code>array = [ { key: val }, { key2: val2 } ];</code></pre>
```
### [link](#multi-line-statements) Multi-line Statements

When a statement is too long to fit on one line, line breaks must occur after an operator.

<pre><code>var html = "&lt;p&gt;The sum of " + a + " and " + b + " plus " + c</code><code>    + " is " + ( a + b + c );</code><code>var html = "&lt;p&gt;The sum of " + a + " and " + b + " plus " + c +</code></pre>
```
Lines should be broken into logical groups if it improves readability, such as splitting each expression of a ternary operator onto its own line even if both will fit on a single line.
```js
<table><tbody><tr><td><p>1<p>2<p>3</td><td><pre><code>var baz = firstCondition( foo ) &amp;&amp; secondCondition( bar ) ?</code></pre>
```
When a conditional is too long to fit on one line, successive lines must be indented one extra level to distinguish them from the body.
```js
<table><tbody><tr><td><p>1<p>2<p>3<p>4</td><td><pre><code>    if ( firstCondition() &amp;&amp; secondCondition() &amp;&amp;</code></pre>
```
### [link](#chained-method-calls) Chained Method Calls

When a chain of method calls is too long to fit on one line, there must be one call per line, with the first call on a separate line from the object the methods are called on. If the method changes the context, an extra level of indentation must be used.

### [link](#full-file-closures) Full File Closures

When an entire file is wrapped in a closure, the body of the closure is not indented.
```js
<table><tbody><tr><td><p>1<p>2<p>3<p>4<p>5</td><td><pre><code>module.exports = function( grunt ) {</code></pre>
```
The same applies to AMD wrappers.
```js
<table><tbody><tr><td><p>1<p>2<p>3<p>4<p>5<p>6<p>7<p>8<p>9</td><td><pre><code>], function( foo, bar, baz ) {</code></pre>
```
For UMD, the factory is indented to visually differentiate it from the body.
```js
<table><tbody><tr><td><p>1<p>2<p>3<p>4<p>5<p>6<p>7<p>8<p>9<p>10<p>11<p>12<p>13<p>14<p>15<p>16<p>17</td><td><pre><code>    if ( typeof define === "function" &amp;&amp; define.amd ) {</code></pre>
```
[link](#constructors) Constructors
----------------------------------

Constructor functions should always be invoked with argument lists, even when such lists are empty.
```js
<table><tbody><tr><td><p>1<p>2</td><td><pre><code>when = time || new Date();</code></pre>
```
When property access or method invocation is immediately performed on the result of a constructor function, clarify precedence with wrapping parentheses.
```js
<table><tbody><tr><td><p>1<p>2</td><td><pre><code>detachedMode = ( new TemplateFactory( settings ) ).nodeType === 11;</code><code>match = ( new RegExp( pattern ) ).exec( input );</code></pre>
```
[link](#equality) Equality
--------------------------

Strict equality checks (`===`) must be used in favor of abstract equality checks (`==`). The _only_ exception is when checking for `undefined` and `null` by way of `null`. The use of `== null` is also acceptable in cases where only one of `null` or `undefined` may be logically encountered, such as uninitialized variables.

[link](#type-checks) Type Checks
--------------------------------

*   String: `typeof object === "string"`
*   Number: `typeof object === "number"`
*   Boolean: `typeof object === "boolean"`
*   Object: `typeof object === "object"`
*   Plain Object: `jQuery.isPlainObject( object )`
*   Function: `jQuery.isFunction( object )`
*   Array: `jQuery.isArray( object )`
*   Element: `object.nodeType`
*   null: `object === null`
*   null or undefined: `object == null`
*   undefined:
    *   Global Variables: `typeof variable === "undefined"`
    *   Local Variables: `variable === undefined`
    *   Properties: `object.prop === undefined`

[link](#comments) Comments
--------------------------

Comments are always preceded by a blank line. Comments start with a capital first letter, but don't require a period at the end, unless you're writing full sentences. There must be a single space between the comment token and the comment text.

Single line comments go **over** the line they refer to:

Multi-line comments are only used for file and function headers.

Inline comments are allowed as an exception when used to annotate special arguments in formal parameter lists or when needed to support a specific development tool:
```js
<table><tbody><tr><td><p>1<p>2<p>3<p>4</td><td><pre><code>function foo( types, selector, data, fn,  one ) {</code></pre>
```
Do not write API documentation in comments. API documentation lives in its own repository.

[link](#quotes) Quotes
----------------------

jQuery uses double quotes.
```js
<table><tbody><tr><td><p>1</td><td><pre><code>var double = "I am wrapped in double quotes";</code></pre>
```
Strings that require inner quoting must use double outside and single inside.
```js
<table><tbody><tr><td><p>1</td><td><pre><code>var html = "&lt;div id='my-id'&gt;&lt;/div&gt;";</code></pre>
```
[link](#semicolons) Semicolons
------------------------------

Use them. Never rely on ASI.

[link](#naming-conventions) Naming Conventions
----------------------------------------------

Variable and function names should be full words, using camel case with a lowercase first letter. Names should be descriptive but not excessively so. Exceptions are allowed for iterators, such as the use of `i` to represent the index in a loop. Constructors do not need a capital first letter.

[link](#global-variables) Global Variables
------------------------------------------

Each project may expose at most one global variable.

[link](#dom-node-rules) DOM Node Rules
--------------------------------------

`.nodeName` must always be used in favor of `.tagName`.

`.nodeType` must be used to determine the classification of a node (not `.nodeName`).

[link](#switch-statements) Switch Statements
--------------------------------------------

The usage of `switch` statements is generally discouraged, but can be useful when there are a large number of cases - especially when multiple cases can be handled by the same block, or fall-through logic (the `default` case) can be leveraged.

When using `switch` statements:

*   Use a `break` for each case other than `default`.
*   Align `case` statements with the `switch`.
```js
<table><tbody><tr><td><p>1<p>2<p>3<p>4<p>5<p>6<p>7<p>8<p>9<p>10<p>11</td><td><pre><code>switch ( event.keyCode ) {</code><code>case $.ui.keyCode.ESCAPE:</code></pre>
```
