"
A text area, for a memo description: text of several lines.
"
Class {
	#name : 'HxMagritteMemoField',
	#superclass : 'HxMagritteField',
	#category : 'PharoHtmx-Magritte-Forms',
	#package : 'PharoHtmx-Magritte',
	#tag : 'Forms'
}

{ #category : 'rendering' }
HxMagritteMemoField >> render [
<div class="field">
  @self renderLabel
  <textarea id="{{ self name }}" name="{{ self name }}" rows="4">{{ self stringValue }}</textarea>
  @self renderErrors
</div>
]
