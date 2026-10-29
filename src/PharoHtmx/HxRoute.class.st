"
I am the superclass of route classes that answer with an action or a fragment rather than a page (see HxPage). See HxTRoute for how a route is declared and handled.

	HxRoute << #BookDetail

	BookDetail class >> pattern [ ^ '/books/<id>' ]
	BookDetail >> handle [ ^ 'Book ' , (self at: #id) ]
"
Class {
	#name : 'HxRoute',
	#superclass : 'Object',
	#traits : 'HxTRoute',
	#classTraits : 'HxTRoute classTrait',
	#category : 'PharoHtmx-Routing',
	#package : 'PharoHtmx',
	#tag : 'Routing'
}
