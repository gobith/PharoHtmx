"
A number input, for a number description. The browser offers arrows and rejects letters; the server checks the value anyway.
"
Class {
	#name : 'GeoMagritteNumberField',
	#superclass : 'GeoMagritteField',
	#category : 'GeoHtmx-Magritte-Forms',
	#package : 'GeoHtmx-Magritte',
	#tag : 'Forms'
}

{ #category : 'rendering' }
GeoMagritteNumberField >> render [
<div class="field">
  @self renderLabel
  <input id="{{ self name }}" name="{{ self name }}" type="number" value="{{ self stringValue }}">
  @self renderErrors
</div>
]
