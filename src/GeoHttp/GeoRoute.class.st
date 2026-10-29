"
I am the superclass of route classes that answer with an action or a fragment rather than a page (see GeoPage). See GeoTRoute for how a route is declared and handled.

	GeoRoute << #BookDetail

	BookDetail class >> pattern [ ^ '/books/<id>' ]
	BookDetail >> handle [ ^ 'Book ' , (self at: #id) ]
"
Class {
	#name : 'GeoRoute',
	#superclass : 'Object',
	#traits : 'GeoTRoute',
	#classTraits : 'GeoTRoute classTrait',
	#category : 'GeoHttp-Routing',
	#package : 'GeoHttp',
	#tag : 'Routing'
}
