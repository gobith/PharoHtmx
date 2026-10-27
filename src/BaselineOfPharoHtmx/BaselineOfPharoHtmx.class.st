"
I describe how to load PharoHtmx with Metacello.

	Metacello new
		baseline: 'PharoHtmx';
		repository: 'gitlocal://D:/projects/PharoHtmx/src';
		load
"
Class {
	#name : 'BaselineOfPharoHtmx',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfPharoHtmx',
	#package : 'BaselineOfPharoHtmx'
}

{ #category : 'baselines' }
BaselineOfPharoHtmx >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec
				package: 'PharoHtmx';
				package: 'PharoHtmx-Tests' with: [ spec requires: #( 'PharoHtmx' ) ].
			spec
				group: 'Core' with: #( 'PharoHtmx' );
				group: 'Tests' with: #( 'PharoHtmx-Tests' );
				group: 'default' with: #( 'Core' 'Tests' ) ]
]
