"
A checkbox, for a boolean description. A browser sends nothing for an unchecked box, so a missing value means false.
"
Class {
	#name : 'HxMagritteCheckboxField',
	#superclass : 'HxMagritteField',
	#category : 'PharoHtmx-Magritte-Forms',
	#package : 'PharoHtmx-Magritte',
	#tag : 'Forms'
}

{ #category : 'reading' }
HxMagritteCheckboxField >> checkedAttribute [
	"checked=checked when the value is true, nothing otherwise."

	^ (form valueOf: description) = true ifTrue: [
			  HxHtmxAttributes new
				  attribute: 'checked' value: 'checked';
				  yourself ]
]

{ #category : 'reading' }
HxMagritteCheckboxField >> readFrom: anHxRequest [
	"A browser sends a checked box only, so no value means false."

	form write: (anHxRequest at: self name ifAbsent: [ nil ]) notNil for: description
]

{ #category : 'rendering' }
HxMagritteCheckboxField >> render [
<div class="field field-checkbox">
  <label>
    <input type="checkbox" name="{{ self name }}" value="true" {{ self checkedAttribute }}>
    {{ self label }}
  </label>
  @self renderErrors
</div>
]
