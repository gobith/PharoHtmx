"
Example views for the Razor tests: a book list, buttons, a cart and a page layout with CSS, all as render methods. They cover the syntax the compiler, the formatter and the editor have to deal with; the demo app has components of its own.
"
Class {
	#name : 'HxRazorExampleViews',
	#superclass : 'HxComponent',
	#category : 'PharoHtmx-Spike',
	#package : 'PharoHtmx-Spike'
}

{ #category : 'views' }
HxRazorExampleViews >> renderAddButton: book [
@book isAvailable
  ifTrue: [
    <button hx-post="/cart/{{ book id }}" hx-swap="outerHTML">Add to cart</button>
  ]
  ifFalse: [
    <span class="sold-out">Sold out</span>
  ]
]

{ #category : 'views' }
HxRazorExampleViews >> renderAddedToCart: book cart: cart [
<button class="added" hx-post="/cart/{{ book id }}" hx-swap="outerHTML">✓ In cart ({{ cart quantityOf: book }})</button>
@self renderCartLinkOob: cart
]

{ #category : 'views' }
HxRazorExampleViews >> renderBookDetail: book [
<h2>{{ book title }}</h2>
<p>Price: {{ book priceString }}</p>
@self renderAddButton: book
]

{ #category : 'views' }
HxRazorExampleViews >> renderBookList: books [
<ul id="book-list">
  @books do: [ :book |
    <li>
      <a href="/books/{{ book id }}" hx-get="/books/{{ book id }}" hx-target="#detail">{{ book title }}</a>
      <span class="price">{{ book priceString }}</span>
      @self renderAddButton: book
    </li>
  ]
</ul>
]

{ #category : 'views' }
HxRazorExampleViews >> renderBooksPage: books cart: cart [
@self renderLayout: 'Books' cart: cart with: [
  <h1>Books</h1>
  <input type="search" name="q" placeholder="Search for a title…"
    hx-get="/books" hx-trigger="input changed delay:300ms"
    hx-target="#book-list" hx-swap="outerHTML">
  @self renderBookList: books
  <div id="detail">Click a title for details.</div>
]
]

{ #category : 'views' }
HxRazorExampleViews >> renderCartChanged: cart [
@self renderCartContents: cart
@self renderCartLinkOob: cart
]

{ #category : 'views' }
HxRazorExampleViews >> renderCartContents: cart [
<section id="cart" hx-target="#cart" hx-swap="outerHTML">
  @cart isEmpty
    ifTrue: [
      <p>Your cart is empty. <a href="/books">Continue shopping</a></p>
    ]
    ifFalse: [
      <table>
        <thead>
          <tr><th>Book</th><th class="num">Quantity</th><th class="num">Amount</th><th></th></tr>
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
              <td class="num"><button hx-post="/cart/{{ line book id }}/remove">Remove</button></td>
            </tr>
          ]
        </tbody>
        <tfoot>
          <tr><th>Total</th><th class="num">{{ cart count }}</th><th class="num">{{ cart totalString }}</th><th></th></tr>
        </tfoot>
      </table>
      <button hx-post="/cart/clear" hx-confirm="Empty the cart?">Empty cart</button>
    ]
</section>
]

{ #category : 'views' }
HxRazorExampleViews >> renderCartLink: cart [
<a id="cart-link" href="/cart">Cart ({{ cart count }})</a>
]

{ #category : 'views' }
HxRazorExampleViews >> renderCartLinkOob: cart [
<a id="cart-link" href="/cart" hx-swap-oob="true">Cart ({{ cart count }})</a>
]

{ #category : 'views' }
HxRazorExampleViews >> renderCartPage: cart [
@self renderLayout: 'Cart' cart: cart with: [
  <h1>Cart</h1>
  @self renderCartContents: cart
]
]

{ #category : 'views' }
HxRazorExampleViews >> renderLayout: title cart: cart with: content [

<!DOCTYPE html>
<html lang="en">
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
      nav {
        display: flex;
        align-items: center;
        gap: 1rem;
      }
      nav a.dev {
        color: #71717a;
        font-weight: 400;
      }
      code {
        font-size: .9rem;
      }
      .method {
        font-size: .75rem;
        font-weight: 600;
        padding: .1rem .4rem;
        border-radius: .3rem;
      }
      .method.get {
        background: #dbeafe;
        color: #1d4ed8;
      }
      .method.post {
        background: #dcfce7;
        color: #15803d;
      }
    </style>
  </head>
  <body>
    <header>
      <a href="/books">PharoHtmx Books</a>
      <nav>
        <a class="dev" href="/routes">Routes</a>
        @self renderCartLink: cart
      </nav>
    </header>
    <main>
      @content value
    </main>
  </body>
</html>
]
