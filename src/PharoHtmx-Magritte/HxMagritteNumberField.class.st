"
A number input, for a number description. The browser offers arrows and rejects letters; the server checks the value anyway.
"
Class {
	#name : 'HxMagritteNumberField',
	#superclass : 'HxMagritteField',
	#category : 'PharoHtmx-Magritte-Forms',
	#package : 'PharoHtmx-Magritte',
	#tag : 'Forms'
}

{ #category : 'rendering' }
HxMagritteNumberField >> render [
<div class="field">
  @self renderLabel
  <input id="{{ self name }}" name="{{ self name }}" type="number" value="{{ self stringValue }}">
  @self renderErrors
</div>
]
