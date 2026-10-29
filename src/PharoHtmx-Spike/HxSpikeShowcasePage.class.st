"
Common htmx patterns, each working on the page with the code that makes it.
"
Class {
	#name : 'HxSpikeShowcasePage',
	#superclass : 'HxPage',
	#category : 'PharoHtmx-Spike-Showcase',
	#package : 'PharoHtmx-Spike',
	#tag : 'Showcase'
}

{ #category : 'routing' }
HxSpikeShowcasePage class >> pattern [

	^ '/showcase'
]

{ #category : 'rendering' }
HxSpikeShowcasePage >> render [
<h1>htmx showcase</h1>
<p class="lead">Each example is a component and a route or two. Open Code under an example to see all of it.</p>

<section class="demo">
  <h2>Lazy loading</h2>
  <p>The figures load after the page, with an indicator while they come. The trigger is <code>load</code>.</p>
  <div class="box" hx-get="{{ HxSpikeStats pathOf: #load }}" hx-trigger="load" hx-swap="outerHTML">
    <span class="htmx-indicator">Loading the figures…</span>
  </div>
  @self render: (HxSpikeCode methods: { HxSpikeStats >> #render. HxSpikeStats class >> #load: })
</section>

<section class="demo">
  <h2>Polling</h2>
  <p>The clock asks the server for the time every second. The trigger is <code>every 1s</code>.</p>
  <div class="box">
    @self render: HxSpikeClock new
  </div>
  @self render: (HxSpikeCode methods: { HxSpikeClock >> #render. HxSpikeClock class >> #tick: })
</section>

<section class="demo">
  <h2>Infinite scroll</h2>
  <p>Scroll the list: its last row loads the next page when it comes into view. The trigger is <code>intersect once</code>.</p>
  <div class="box scroller">
    <table>
      <tbody>
        @self render: (HxSpikeRows catalog: app catalog page: 1)
      </tbody>
    </table>
  </div>
  @self render: (HxSpikeCode methods: { HxSpikeRows >> #render. HxSpikeRows class >> #more: })
</section>

<section class="demo">
  <h2>Inline editing</h2>
  <p>One component in two states. Edit swaps the text for a form; Save sends a PUT and swaps the text back. The target and the swap sit once on the outer element, and the buttons inherit them.</p>
  @self render: (HxSpikeNote text: self showcase note)
  @self render: (HxSpikeCode methods: { HxSpikeNote >> #render. HxSpikeNote class >> #edit:. HxSpikeNote class >> #save:. HxSpikeNote class >> #cancel: })
</section>

<section class="demo">
  <h2>Add and delete</h2>
  <p>The form adds an item at the end of the list. Delete asks first, then sends a DELETE and removes the item.</p>
  @self render: (HxSpikeTodoList todos: self showcase todos)
  @self render: (HxSpikeCode methods: { HxSpikeTodoList >> #render. HxSpikeTodoItem >> #render. HxSpikeTodoList class >> #add:. HxSpikeTodoItem class >> #delete: })
</section>

<section class="demo">
  <h2>Events from the server</h2>
  <p>Ping changes nothing on the page itself. Its answer has the header <code>HX-Trigger: pinged</code>, and the counter reloads itself on that event.</p>
  <div class="box note">
    <button hx-post="{{ HxSpikePings pathOf: #ping }}" hx-swap="none">Ping the server</button>
    @self render: (HxSpikePings count: self showcase pings)
  </div>
  @self render: (HxSpikeCode methods: { HxSpikePings >> #render. HxSpikePings class >> #ping:. HxSpikePings class >> #reload: })
</section>
]

{ #category : 'accessing' }
HxSpikeShowcasePage >> showcase [

	^ app showcase
]

{ #category : 'accessing' }
HxSpikeShowcasePage >> title [

	^ 'htmx showcase'
]
