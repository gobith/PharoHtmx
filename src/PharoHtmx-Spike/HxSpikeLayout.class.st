"
The document around a page: the head with the scripts and the styles, the header, and the page. The body carries the CSRF token of the session, so that every htmx request of the page sends it.
"
Class {
	#name : 'HxSpikeLayout',
	#superclass : 'HxComponent',
	#instVars : [
		'header',
		'page'
	],
	#category : 'PharoHtmx-Spike-Components',
	#package : 'PharoHtmx-Spike',
	#tag : 'Components'
}

{ #category : 'instance creation' }
HxSpikeLayout class >> header: aHeader page: aPage [

	^ self new setHeader: aHeader page: aPage
]

{ #category : 'accessing' }
HxSpikeLayout >> header [

	^ header
]

{ #category : 'accessing' }
HxSpikeLayout >> page [

	^ page
]

{ #category : 'rendering' }
HxSpikeLayout >> render [
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>{{ self title }} · PharoHtmx</title>
    {{ HxHtmxScript new }}
    <style>
      body {
        font-family: system-ui, sans-serif;
        max-width: 76rem;
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
      .lead {
        color: #52525b;
      }
      section.demo {
        margin: 2rem 0;
        padding-top: 1rem;
        border-top: 1px solid #e4e4e7;
      }
      section.demo h2 {
        margin: 0 0 .25rem;
        font-size: 1.15rem;
      }
      section.demo > p {
        margin: 0 0 .75rem;
        color: #52525b;
      }
      .box {
        padding: 1rem;
        background: #f4f4f5;
        border-radius: .5rem;
      }
      .scroller {
        max-height: 12rem;
        overflow: auto;
        padding: 0 1rem;
      }
      .scroller td.num {
        width: 3rem;
      }
      .muted {
        color: #a1a1aa;
      }
      .clock {
        font-size: 1.5rem;
        font-variant-numeric: tabular-nums;
      }
      .stats {
        display: grid;
        grid-template-columns: auto 1fr;
        gap: .25rem 1rem;
        margin: 0;
      }
      .stats dt {
        color: #52525b;
      }
      .stats dd {
        margin: 0;
        font-weight: 600;
      }
      .note {
        display: flex;
        align-items: center;
        gap: .75rem;
      }
      .note-form {
        display: flex;
        flex: 1;
        align-items: center;
        gap: .5rem;
      }
      .note p {
        flex: 1;
        margin: 0;
      }
      .note input, form.add input {
        flex: 1;
        font: inherit;
        padding: .3rem .5rem;
        border: 1px solid #d4d4d8;
        border-radius: .4rem;
      }
      form.add {
        display: flex;
        gap: .5rem;
      }
      .todos span {
        flex: 1;
      }
      details.code {
        margin-top: .75rem;
      }
      details.code summary {
        cursor: pointer;
        color: #2563eb;
      }
      pre {
        background: #18181b;
        color: #f4f4f5;
        padding: .75rem 1rem;
        border-radius: .5rem;
        overflow-x: auto;
        tab-size: 4;
        font-size: .8rem;
        max-height: 28rem;
        white-space: pre-wrap;
        overflow-wrap: anywhere;
      }
      .code-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1rem;
      }
      .code-grid > div {
        min-width: 0;
      }
      .code-grid h3 {
        margin: .75rem 0 .25rem;
        font-size: .75rem;
        text-transform: uppercase;
        letter-spacing: .05em;
        color: #71717a;
      }
      @media (max-width: 56rem) {
        .code-grid {
          grid-template-columns: 1fr;
        }
      }
    </style>
  </head>
  <body {{ self hx csrfToken: page csrfToken }}>
    {{ header }}
    <main>
      {{ page }}
    </main>
  </body>
</html>
]

{ #category : 'initialization' }
HxSpikeLayout >> setHeader: aHeader page: aPage [

	header := aHeader.
	page := aPage
]

{ #category : 'accessing' }
HxSpikeLayout >> title [

	^ page title
]
