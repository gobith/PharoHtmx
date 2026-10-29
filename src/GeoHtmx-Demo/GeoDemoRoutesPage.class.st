"
An overview of the endpoints of the app: its pages, the endpoint methods of its components and its route classes.
"
Class {
	#name : 'GeoDemoRoutesPage',
	#superclass : 'GeoPage',
	#category : 'GeoHtmx-Demo-Pages',
	#package : 'GeoHtmx-Demo',
	#tag : 'Pages'
}

{ #category : 'routing' }
GeoDemoRoutesPage class >> pattern [

	^ '/routes'
]

{ #category : 'rendering' }
GeoDemoRoutesPage >> render [
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
GeoDemoRoutesPage >> routes [
	"Every endpoint of the app."

	^ app endpoints
]

{ #category : 'accessing' }
GeoDemoRoutesPage >> title [

	^ 'Routes'
]
