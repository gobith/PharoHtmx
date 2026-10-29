"
Common htmx patterns, each working on the page with the code that makes it.
"
Class {
	#name : 'GeoDemoShowcasePage',
	#superclass : 'GeoPage',
	#category : 'GeoHtmx-Demo-Showcase',
	#package : 'GeoHtmx-Demo',
	#tag : 'Showcase'
}

{ #category : 'routing' }
GeoDemoShowcasePage class >> pattern [

	^ '/showcase'
]

{ #category : 'rendering' }
GeoDemoShowcasePage >> render [
<h1>htmx showcase</h1>
<p class="lead">Each example is a component with its endpoints. Open Code and HTML under an example to see its Smalltalk next to the HTML it writes.</p>

<section class="demo">
  <h2>Lazy loading</h2>
  <p>The figures load after the page, with an indicator while they come: <code>triggerOnLoad</code>.</p>
  <div class="box"
    {{ self hx
         action: #load: of: GeoDemoStats;
         triggerOnLoad;
         swapOuter }}>
    <span class="htmx-indicator">Loading the figures…</span>
  </div>
  {{ GeoDemoCode
       methods: { GeoDemoStats >> #render. GeoDemoStats class >> #load: }
       examples: { GeoDemoStats books: app catalog } }}
</section>

<section class="demo">
  <h2>Polling</h2>
  <p>The clock asks the server for the time every second: <code>triggerEvery: 1 second</code>.</p>
  <div class="box">
    {{ GeoDemoClock new }}
  </div>
  {{ GeoDemoCode
       methods: { GeoDemoClock >> #render. GeoDemoClock class >> #tick: }
       examples: { GeoDemoClock new } }}
</section>

<section class="demo">
  <h2>Infinite scroll</h2>
  <p>Scroll the list: its last row loads the next page when it comes into view: <code>triggerIntersectOnce</code>.</p>
  <div class="box scroller">
    <table>
      <tbody>
        {{ GeoDemoRows catalog: app catalog page: 1 }}
      </tbody>
    </table>
  </div>
  {{ GeoDemoCode
       methods: { GeoDemoRows >> #render. GeoDemoRows class >> #more: }
       examples: { GeoDemoRows catalog: app catalog page: 5 } }}
</section>

<section class="demo">
  <h2>Inline editing</h2>
  <p>One component in two states. Edit swaps the text for a form; Save sends a PUT and swaps the text back. <code>targetThis; swapOuter</code> sits once on the outer element, and the buttons inherit it.</p>
  {{ GeoDemoNote text: self showcase note }}
  {{ GeoDemoCode
       methods: { GeoDemoNote >> #render. GeoDemoNote class >> #edit:. GeoDemoNote class >> #save:. GeoDemoNote class >> #cancel: }
       examples: { GeoDemoNote text: self showcase note. (GeoDemoNote text: self showcase note) beEditing; yourself } }}
</section>

<section class="demo">
  <h2>Add and delete</h2>
  <p>The form adds an item at the end of the list. Delete asks first, then sends a DELETE and removes the item.</p>
  {{ GeoDemoTodoList todos: self showcase todos }}
  {{ GeoDemoCode
       methods: { GeoDemoTodoList >> #render. GeoDemoTodoItem >> #render. GeoDemoTodoList class >> #add:. GeoDemoTodoItem class >> #delete: }
       examples: { GeoDemoTodoList todos: self showcase todos } }}
</section>

<section class="demo">
  <h2>Events from the server</h2>
  <p>Ping changes nothing on the page itself. Its answer has the header <code>HX-Trigger: pinged</code>, and the counter reloads itself on that event.</p>
  <div class="box note">
    <button
      {{ self hx
           action: #ping: of: GeoDemoPings;
           swapNone }}>
      Ping the server
    </button>
    {{ GeoDemoPings count: self showcase pings }}
  </div>
  {{ GeoDemoCode
       methods: { GeoDemoPings >> #render. GeoDemoPings class >> #ping:. GeoDemoPings class >> #reload: }
       examples: { GeoDemoPings count: self showcase pings } }}
</section>

<section class="demo">
  <h2>Forms from Magritte</h2>
  <p>The profile describes its fields once, with Magritte: a label, a kind and rules. The card lists the values with those labels, and Edit turns the same descriptions into a form. Leave the name empty, type an e-mail without @@ or an age of 200, and Save shows what is wrong under the field; nothing is stored until all values are valid.</p>
  {{ GeoDemoProfileCard profile: self showcase profile }}
  {{ GeoDemoCode
       methods: { GeoDemoProfile >> #descriptionEmail. GeoDemoProfile >> #descriptionAge. GeoDemoProfileCard >> #render. GeoDemoProfileCard class >> #save: }
       examples: { GeoDemoProfileCard profile: self showcase profile. (GeoDemoProfileCard profile: self showcase profile) beEditing; yourself } }}
</section>
]

{ #category : 'accessing' }
GeoDemoShowcasePage >> showcase [

	^ app showcase
]

{ #category : 'accessing' }
GeoDemoShowcasePage >> title [

	^ 'htmx showcase'
]
