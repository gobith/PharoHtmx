"
A checkbox, for a boolean description. A browser sends nothing for an unchecked box, so a missing value means false.
"
Class {
	#name : 'GeoMagritteCheckboxField',
	#superclass : 'GeoMagritteField',
	#category : 'GeoHtmx-Magritte-Forms',
	#package : 'GeoHtmx-Magritte',
	#tag : 'Forms'
}

{ #category : 'reading' }
GeoMagritteCheckboxField >> checkedAttribute [
	"checked=checked when the value is true, nothing otherwise."

	^ (form valueOf: description) = true ifTrue: [
			  GeoHtmxAttributes new
				  attribute: 'checked' value: 'checked';
				  yourself ]
]

{ #category : 'reading' }
GeoMagritteCheckboxField >> readFrom: aGeoRequest [
	"A browser sends a checked box only, so no value means false."

	form write: (aGeoRequest at: self name ifAbsent: [ nil ]) notNil for: description
]

{ #category : 'rendering' }
GeoMagritteCheckboxField >> render [
<div class="field field-checkbox">
  <label>
    <input type="checkbox" name="{{ self name }}" value="true" {{ self checkedAttribute }}>
    {{ self label }}
  </label>
  @self renderErrors
</div>
]
