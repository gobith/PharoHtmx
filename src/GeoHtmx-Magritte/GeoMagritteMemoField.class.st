"
A text area, for a memo description: text of several lines.
"
Class {
	#name : 'GeoMagritteMemoField',
	#superclass : 'GeoMagritteField',
	#category : 'GeoHtmx-Magritte-Forms',
	#package : 'GeoHtmx-Magritte',
	#tag : 'Forms'
}

{ #category : 'rendering' }
GeoMagritteMemoField >> render [
<div class="field">
  @self renderLabel
  <textarea id="{{ self name }}" name="{{ self name }}" rows="4">{{ self stringValue }}</textarea>
  @self renderErrors
</div>
]
