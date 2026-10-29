# PharoHtmx

A small [htmx](https://htmx.org) web UI framework for [Pharo](https://pharo.org) 14, built on Zinc.

> **Status: playground.** This is a spike to try out ideas. Names, packages and syntax will change, and the parts will later move to repositories of their own.

## Loading

In a Pharo 14 image:

```smalltalk
Metacello new
	baseline: 'PharoHtmx';
	repository: 'github://gobith/PharoHtmx:main/src';
	load.
```

To load only part of it, add `load: #( 'Core' )` (or `'Razor'`, `'Spike'`, `'Tests'`).

## Demo

A bookshop with live search, a detail panel and a cart, built from components. `/routes` lists the pages and routes of the app.

`/showcase` shows common htmx patterns working, each with the code of its component and route: lazy loading, polling, infinite scroll, inline editing, adding and deleting with a form, and events from the server.

```smalltalk
HxSpikeApp start.    "http://localhost:8090"
HxSpikeApp stop.
```

## Components

A component is one piece of UI in one class: its props are instance variables, its logic is plain Smalltalk, and its HTML is in its render methods.

```smalltalk
HxComponent << #HxSpikeBookRow
	slots: { #book };
	package: 'PharoHtmx-Spike';
	tag: 'Components'.

HxSpikeBookRow class >> book: aBook [ ^ self new setBook: aBook ]
HxSpikeBookRow >> setBook: aBook [ book := aBook ]
```

```
render
<li>
  <a href="{{ HxSpikeBookDetail pathOf: #show with: book id }}"
    {{ self hx
         action: #show of: HxSpikeBookDetail with: book id;
         target: '#detail' }}>
    {{ book title }}
  </a>
  <span class="price">{{ book priceString }}</span>
  {{ HxSpikeAddButton book: book }}
</li>
```

- A method whose selector starts with `render` (`render`, `renderRow:`) is HTML. Every other method is plain Smalltalk.
- `{{ aComponent }}` writes a child component into the same HTML, also on its own line inside a block. `@self render: aComponent` does the same.
- `aComponent toHtml` renders a component and answers the HTML.
- Components are built anew for every request and keep no state between requests.
- A component answers requests in its class-side endpoint methods; see Endpoints.

### Pages and layout

A page is a component with a path. Its class side has a `pattern`, and the app lists it in `routes`. A page answers the whole document: the app puts it in a layout with `layoutFor:`.

```smalltalk
HxSpikeApp >> layoutFor: aPage [
	^ HxSpikeLayout
		  header: (HxSpikeHeader cart: self cart)
		  page: aPage
]
```

The layout's `render` writes the head, then `{{ header }}`, then `{{ page }}`.

## Endpoints

A component answers requests in its class-side methods. A pragma names the HTTP method; the method gets the request and answers what goes back. One component stands for one thing on the page, with its states and its actions:

```
HxSpikeNote >> render
<div id="note" class="box note" {{ self hx targetThis; swapOuter }}>
  @self isEditing
    ifTrue: [
      <form class="note-form" {{ self hx action: #save }}>
        <input name="text" value="{{ text }}" autofocus>
        <button type="submit">Save</button>
        <button type="button" {{ self hx action: #cancel }}>Cancel</button>
      </form>
    ]
    ifFalse: [
      <p>{{ text }}</p>
      <button {{ self hx action: #edit }}>Edit</button>
    ]
</div>
```

```smalltalk
HxSpikeNote class >> edit: request [
	"Swap the text for a form that edits it."
	<get>
	^ (self text: request app showcase note) beEditing; yourself
]

HxSpikeNote class >> save: request [
	"Store the text from the form and show it."
	<put>
	request app showcase note: (request at: #text ifAbsent: [ '' ]).
	^ self text: request app showcase note
]
```

- The pragmas are `<get>`, `<post>`, `<put>`, `<patch>` and `<delete>`. Without a path, an endpoint gets one from its class and selector: `/HxSpikeNote/edit`.
- Give a path when the endpoint needs a parameter or when people see the URL: `<get: '/books/<id>'>`, `<delete: '/showcase/todos/<id>'>`.
- A template sends a request to an action with `self hx action: #edit` (see htmx below). For a plain link it asks for the path: `self path: #edit`, `self path: #delete with: todo id`, or `HxSpikeBookDetail pathOf: #show with: book id` for another component. Values that are not path parameters go into the query string.
- `hx-target` and `hx-swap` inherit in htmx, so `targetThis; swapOuter` on the outer element makes every button inside replace the whole component.
- `request at: #id` reads a path parameter, query parameter or form field, and `request app` is the app.
- An endpoint answers a component, an `HxHtmxResponse`, a String of HTML or a `ZnResponse`.
- An app lists its pages, components and route classes in `routes`. A class that is not in the list answers nothing. The list is read for every request, so a change to it works at once on a running server, and `/routes` shows every endpoint in its order.
- When two endpoints match, the one with fewer parameters wins, so `/cart/clear` goes before `/cart/<id>`.
- The first line of the method comment is the endpoint's `summary`, which the overview shows.

A page has its path on its class side (`pattern`) and answers itself in the layout. For a request without UI, such as a redirect, a subclass of `HxRoute` has `pattern` on its class side and `handle` on its instance side.

## htmx

A component builds the htmx attributes of an element with `self hx` and a cascade, one message per line. `{{ }}` in a tag writes them as attributes. A tag with a cascade puts it on a line of its own, the content on the next line and the closing tag under the opening tag:

```
<button
  {{ self hx
       action: #delete with: todo id;
       confirm: 'Delete this item?';
       targetClosest: 'li';
       swapOuter }}>
  Delete
</button>
```

writes

```html
<button hx-delete="/showcase/todos/7" hx-confirm="Delete this item?" hx-target="closest li" hx-swap="outerHTML">Delete</button>
```

- `action:` takes the HTTP method from the endpoint's pragma, so `hx-get`, `hx-post`, `hx-put` and `hx-delete` always match the endpoint. `action:of:` names an endpoint of another component; `get:`, `post:` and the like take a URL.
- A misspelt message shows up in the editor and fails when the view renders, where the browser ignores a misspelt attribute without a word. Code completion on `self hx` shows what htmx can do.
- A cascade that two elements share goes in a method of the component, as `addAction` in `HxSpikeAddButton`.
- `attribute:value:` writes an attribute that has no message, such as `hx-ext`. Plain `hx-` attributes in the HTML still work.

| Group | Messages |
|---|---|
| Request | `action:`, `action:with:`, `action:of:`, `action:of:with:`, `get:`, `post:`, `put:`, `patch:`, `delete:` |
| Target | `target:`, `targetThis`, `targetClosest:`, `targetFind:`, `targetNext:`, `targetPrevious:` |
| Swap | `swapInner`, `swapOuter`, `swapBeforeBegin`, `swapAfterBegin`, `swapBeforeEnd`, `swapAfterEnd`, `swapDelete`, `swapNone`, `swap:` |
| Trigger | `triggerOnLoad`, `triggerEvery:`, `triggerRevealed`, `triggerIntersectOnce`, `triggerOnInputDelay:`, `triggerOn:from:`, `trigger:` |
| Feedback | `confirm:`, `prompt:`, `indicator:`, `disabledElt:`, `sync:` |
| Address bar | `pushUrl`, `pushUrl:`, `replaceUrl`, `replaceUrl:`, `boost` |
| Values | `vals:`, `include:`, `select:` |
| Events | `on:do:` |

Every message has a comment that says what it does and which attribute it writes.

What needs the server has a class of its own:

- `HxHtmxScript` is a component that loads htmx: `{{ HxHtmxScript new }}` in the head of a layout.
- `request htmx` is an `HxHtmxRequest`: whether htmx sent the request, whether it was boosted, its target, its trigger, the current URL and the answer to an `hx-prompt`.
- `HxHtmxResponse` is an answer for htmx: the HTML for the target, components to swap out of band, and the response headers.

```smalltalk
^ (HxHtmxResponse with: (HxSpikeBookList books: books))
	  addOutOfBand: (HxSpikeCartLink cart: cart);
	  replaceUrl: '/books?q=go';
	  trigger: 'cart-changed';
	  yourself
```

| Message | Header or attribute | Effect |
|---|---|---|
| `addOutOfBand:` | `hx-swap-oob="true"` | Replaces the element with the same id |
| `addOutOfBand:swap:` | `hx-swap-oob="beforeend:#log"` | Adds to or replaces elsewhere in the page |
| `pushUrl:` / `replaceUrl:` | `HX-Push-Url` / `HX-Replace-Url` | Changes the address bar, with or without a history entry |
| `redirect:` / `location:` / `refresh` | `HX-Redirect` / `HX-Location` / `HX-Refresh` | Goes to another page, with or without a full reload, or reloads |
| `retarget:` / `reswap:` / `reselect:` | `HX-Retarget` / `HX-Reswap` / `HX-Reselect` | Overrides the target, swap or select of the element |
| `trigger:` / `trigger:with:` | `HX-Trigger` | Fires an event in the browser, with details as JSON |
| `triggerAfterSwap:` / `triggerAfterSettle:` | `HX-Trigger-After-Swap` / `-Settle` | Fires an event later in the swap |

## Razor syntax

The render methods of a component are HTML with Smalltalk in it, and the source you see in the browser stays HTML.

- The first line is the message pattern.
- `{{ expr }}` writes the escaped result of a Smalltalk expression.
- `@` starts a Smalltalk statement. It runs until its brackets are balanced, and then ends at the line end or at a tag. It goes on when the next line starts with a keyword, so `ifTrue:` / `ifFalse:` can sit on lines of their own.
- Inside a block, a tag switches back to HTML until its matching close tag.
- `@@` writes a literal `@`, and an `@` inside a word (an e-mail address) is plain text.
- `<script>` and `<style>` content is raw text, apart from `{{ }}`.

The editor colours the HTML, CSS and Smalltalk, **Format** indents the HTML and CSS, vertical guides connect opening and closing tags, and the debugger highlights the HTML you are stepping through.

Format keeps the line breaks and sets the indentation, so a formatted method stays as it is when formatted again:

- Each open element or bracket indents its content one level; a closing tag or bracket goes back to the level of the line that opened it.
- A continuation line of a tag or statement goes one level deeper, and so does a keyword line such as `ifTrue:`, also inside a block.
- The next lines of a `{{ }}`, such as the messages of a cascade, line up one level to the right of the expression after the `{{`.

## Packages

| Package | Group | Contents |
|---|---|---|
| `PharoHtmx` | Core | `HxApp`, a Zinc server delegate; the routing: `HxEndpoint`, `HxTRoute`, `HxRoute`, `HxRoutePattern`, `HxRouter`; htmx: `HxHtmxAttributes`, `HxHtmxRequest`, `HxHtmxResponse` |
| `PharoHtmx-Razor` | Razor | `HxComponent`, `HxPage` and `HxHtmxScript`, the Razor compiler, formatter, highlighting and debugger support. Needs Core. |
| `PharoHtmx-Spike` | Spike | The bookshop demo, its tests and the Razor tests |
| `PharoHtmx-Tests` | Tests | Routing and htmx tests, and their test routes |

## Changes to Pharo itself

`PharoHtmx-Razor` replaces three methods in Pharo 14 so that the editor and the debugger understand render methods. Each override keeps the original in its comment. Plain Smalltalk methods behave as before.

- `RubSmalltalkCodeMode>>parseSource:` — parse with the class's own parser, for Format.
- `OnlineSourceDebugInfo>>rangeForPC:` — let the method node map the highlighted range.
- `StContextPrinter class>>printMethod:on:` — let the method node give the source of a block in the stack.

It also adds `OCMethodNode>>debugRangeFor:` and `OCMethodNode>>sourceCodeOf:`, the plain defaults that the last two call.

## License

MIT, see [LICENSE](LICENSE).
