"
A one-line text input, for a string description and for any description without a field of its own.
"
Class {
	#name : 'HxMagritteTextField',
	#superclass : 'HxMagritteField',
	#category : 'PharoHtmx-Magritte-Forms',
	#package : 'PharoHtmx-Magritte',
	#tag : 'Forms'
}

{ #category : 'rendering' }
HxMagritteTextField >> render [
<div class="field">
  @self renderLabel
  <input id="{{ self name }}" name="{{ self name }}" type="text" value="{{ self stringValue }}">
  @self renderErrors
</div>
]
