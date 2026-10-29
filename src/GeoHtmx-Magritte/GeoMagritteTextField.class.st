"
A one-line text input, for a string description and for any description without a field of its own.
"
Class {
	#name : 'GeoMagritteTextField',
	#superclass : 'GeoMagritteField',
	#category : 'GeoHtmx-Magritte-Forms',
	#package : 'GeoHtmx-Magritte',
	#tag : 'Forms'
}

{ #category : 'rendering' }
GeoMagritteTextField >> render [
<div class="field">
  @self renderLabel
  <input id="{{ self name }}" name="{{ self name }}" type="text" value="{{ self stringValue }}">
  @self renderErrors
</div>
]
