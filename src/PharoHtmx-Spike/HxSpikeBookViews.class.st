"
Example views for the Razor spike.
"
Class {
	#name : 'HxSpikeBookViews',
	#superclass : 'HxView',
	#category : 'PharoHtmx-Spike',
	#package : 'PharoHtmx-Spike'
}

{ #category : 'views' }
HxSpikeBookViews >> addButton: book [
@book isAvailable
  ifTrue: [
    <button hx-post="/cart/{{ book id }}" hx-swap="outerHTML">In mandje</button>
  ] 
  ifFalse: [
    <span class="sold-out">Uitverkocht</span>
  ]
]

{ #category : 'views' }
HxSpikeBookViews >> addedToCart: book cart: cart [
<button class="added" hx-post="/cart/{{ book id }}" hx-swap="outerHTML">✓ In mandje ({{ cart quantityOf: book }})</button>
@self cartLinkOob: cart
]

{ #category : 'views' }
HxSpikeBookViews >> bookDetail: book [
<h2>{{ book title }}</h2>
<p>Prijs: {{ book priceString }}</p>
@self addButton: book
]

{ #category : 'views' }
HxSpikeBookViews >> bookList: books [
<ul id="book-list">
  @books do: [ :book |
    <li>
      <a href="/books/{{ book id }}" hx-get="/books/{{ book id }}" hx-target="#detail">{{ book title }}</a>
      <span class="price">{{ book priceString }}</span>
      @self addButton: book
    </li>
  ]
</ul>
]

{ #category : 'views' }
HxSpikeBookViews >> booksPage: books cart: cart [
@self layout: 'Boeken' cart: cart with: [
  <h1>Boeken</h1>
  <input type="search" name="q" placeholder="Zoek een titel…"
         hx-get="/books" hx-trigger="input changed delay:300ms"
         hx-target="#book-list" hx-swap="outerHTML">
  @self bookList: books
  <div id="detail">Klik op een titel voor details.</div>
]
]

{ #category : 'views' }
HxSpikeBookViews >> cartChanged: cart [
@self cartContents: cart
@self cartLinkOob: cart
]

{ #category : 'views' }
HxSpikeBookViews >> cartContents: cart [
<section id="cart" hx-target="#cart" hx-swap="outerHTML">
  @cart isEmpty
    ifTrue: [
      <p>Je mandje is leeg. <a href="/books">Verder winkelen</a></p>
    ]
    ifFalse: [
      <table>
        <thead>
          <tr><th>Boek</th><th class="num">Aantal</th><th class="num">Bedrag</th><th></th></tr>
        </thead>
        <tbody>
          @cart lines do: [ :line |
            <tr>
              <td>{{ line book title }}</td>
              <td class="num">
                <button hx-post="/cart/{{ line book id }}/decrement">−</button>
                {{ line quantity }}
                <button hx-post="/cart/{{ line book id }}/increment">+</button>
              </td>
              <td class="num">{{ line totalString }}</td>
              <td class="num"><button hx-post="/cart/{{ line book id }}/remove">Verwijder</button></td>
            </tr>
          ]
        </tbody>
        <tfoot>
          <tr><th>Totaal</th><th class="num">{{ cart count }}</th><th class="num">{{ cart totalString }}</th><th></th></tr>
        </tfoot>
      </table>
      <button hx-post="/cart/clear" hx-confirm="Mandje leegmaken?">Leegmaken</button>
    ]
</section>
]

{ #category : 'views' }
HxSpikeBookViews >> cartLink: cart [
<a id="cart-link" href="/cart">Mandje ({{ cart count }})</a>
]

{ #category : 'views' }
HxSpikeBookViews >> cartLinkOob: cart [
<a id="cart-link" href="/cart" hx-swap-oob="true">Mandje ({{ cart count }})</a>
]

{ #category : 'views' }
HxSpikeBookViews >> cartPage: cart [
@self layout: 'Mandje' cart: cart with: [
  <h1>Mandje</h1>
  @self cartContents: cart
]
]

{ #category : 'views' }
HxSpikeBookViews >> layout: title cart: cart with: content [

<!DOCTYPE html>
<html lang="nl">
  <head>
    <meta charset="utf-8">
    <title>{{ title }} · PharoHtmx</title>
    <script src="https://unpkg.com/htmx.org@2.0.4"></script>
    <style>
      body {
        font-family: system-ui, sans-serif;
        max-width: 44rem;
        margin: 0 auto;
        padding: 0 1rem 3rem;
        color: #18181b;
      }
      header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 1rem 0;
        border-bottom: 1px solid #e4e4e7;
        margin-bottom: 1.5rem;
      }
      header a {
        color: inherit;
        text-decoration: none;
        font-weight: 600;
      }
      #cart-link {
        background: #18181b;
        color: white;
        padding: .4rem .8rem;
        border-radius: 999px;
      }
      input[type=search] {
        width: 100%;
        box-sizing: border-box;
        padding: .6rem;
        font-size: 1rem;
        border: 1px solid #d4d4d8;
        border-radius: .4rem;
      }
      ul {
        list-style: none;
        padding: 0;
      }
      li {
        display: flex;
        align-items: center;
        gap: .75rem;
        padding: .6rem 0;
        border-bottom: 1px solid #f4f4f5;
      }
      li a {
        flex: 1;
        color: #2563eb;
        text-decoration: none;
      }
      .price {
        color: #52525b;
        font-variant-numeric: tabular-nums;
      }
      button {
        font: inherit;
        padding: .3rem .7rem;
        border: 1px solid #d4d4d8;
        background: white;
        border-radius: .4rem;
        cursor: pointer;
      }
      button:hover {
        background: #f4f4f5;
      }
      button.added {
        border-color: #16a34a;
        color: #16a34a;
      }
      .sold-out {
        color: #a1a1aa;
        font-size: .9rem;
      }
      #detail {
        margin-top: 1.5rem;
        padding: 1rem;
        background: #f4f4f5;
        border-radius: .5rem;
      }
      table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 1rem;
      }
      th, td {
        text-align: left;
        padding: .5rem;
        border-bottom: 1px solid #e4e4e7;
      }
      td.num, th.num {
        text-align: right;
        font-variant-numeric: tabular-nums;
      }
      tfoot th {
        border-bottom: none;
      }
    </style>
  </head>
  <body>
    <header>
      <a href="/books">PharoHtmx Boeken</a>
      @self cartLink: cart
    </header>
    <main>
      @content value
    </main>
  </body>
</html>
]
