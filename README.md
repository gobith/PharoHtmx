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

A bookshop with live search, a detail panel and a cart:

```smalltalk
HxSpikeApp start.    "http://localhost:8090"
HxSpikeApp stop.
```

## Razor views

A subclass of `HxView` gets its own compiler: its methods are HTML with Smalltalk in it, and the source you see in the browser stays HTML.

```
bookList: books

<ul id="book-list">
  @books do: [ :book |
    <li>
      <a href="/books/{{ book id }}" hx-get="/books/{{ book id }}" hx-target="#detail">{{ book title }}</a>
      @self addButton: book
    </li>
  ]
</ul>
```

- The first line is the message pattern.
- `{{ expr }}` writes the escaped result of a Smalltalk expression.
- `@` starts a Smalltalk statement. It runs until its brackets are balanced, and then ends at the line end or at a tag. It goes on when the next line starts with a keyword, so `ifTrue:` / `ifFalse:` can sit on lines of their own.
- Inside a block, a tag switches back to HTML until its matching close tag.
- `@@` writes a literal `@`, and an `@` inside a word (an e-mail address) is plain text.
- `<script>` and `<style>` content is raw text, apart from `{{ }}`.

The editor colours the HTML, CSS and Smalltalk, **Format** indents the HTML and CSS, vertical guides connect opening and closing tags, and the debugger highlights the HTML you are stepping through.

## Packages

| Package | Group | Contents |
|---|---|---|
| `PharoHtmx` | Core | `HxApp`, a Zinc server delegate with a small router |
| `PharoHtmx-Razor` | Razor | `HxView`, the Razor compiler, formatter, highlighting and debugger support |
| `PharoHtmx-Spike` | Spike | The bookshop demo and the Razor tests |
| `PharoHtmx-Tests` | Tests | Router tests |

## Changes to Pharo itself

`PharoHtmx-Razor` replaces three methods in Pharo 14 so that the editor and the debugger understand views. Each override keeps the original in its comment. Plain Smalltalk methods behave as before.

- `RubSmalltalkCodeMode>>parseSource:` — parse with the class's own parser, for Format.
- `OnlineSourceDebugInfo>>rangeForPC:` — let the method node map the highlighted range.
- `StContextPrinter class>>printMethod:on:` — let the method node give the source of a block in the stack.

It also adds `OCMethodNode>>debugRangeFor:` and `OCMethodNode>>sourceCodeOf:`, the plain defaults that the last two call.

## License

MIT, see [LICENSE](LICENSE).
