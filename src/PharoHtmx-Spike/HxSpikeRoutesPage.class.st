"
An overview of the endpoints of the app: its pages, the endpoint methods of its components and its route classes.
"
Class {
	#name : 'HxSpikeRoutesPage',
	#superclass : 'HxPage',
	#category : 'PharoHtmx-Spike-Pages',
	#package : 'PharoHtmx-Spike',
	#tag : 'Pages'
}

{ #category : 'routing' }
HxSpikeRoutesPage class >> pattern [

	^ '/routes'
]

{ #category : 'rendering' }
HxSpikeRoutesPage >> render [
<h1>Routes</h1>
<table>
  <thead>
    <tr><th>Method</th><th>Path</th><th>Class</th><th>Description</th></tr>
  </thead>
  <tbody>
    @self routes do: [ :route |
      <tr>
        <td><span class="method {{ route httpMethod asLowercase }}">{{ route httpMethod }}</span></td>
        <td>
          @(route httpMethod = #GET and: [ route routePattern parameterCount = 0 ])
            ifTrue: [
              <a href="{{ route path }}"><code>{{ route pattern }}</code></a>
            ]
            ifFalse: [
              <code>{{ route pattern }}</code>
            ]
        </td>
        <td><code>{{ route name }}</code></td>
        <td>{{ route summary }}</td>
      </tr>
    ]
  </tbody>
</table>
]

{ #category : 'accessing' }
HxSpikeRoutesPage >> routes [
	"Every endpoint of the app."

	^ app endpoints
]

{ #category : 'accessing' }
HxSpikeRoutesPage >> title [

	^ 'Routes'
]
