# CEP-Questionnaire
> The awesome AngularJS directive that delivers the CEP experience directly into the browser of your choice

The cep-questionnaire is an AngularJS directive and the core component to render the CEP frontend.
For simple integration in modern UI build processes it is delivered as a Yarn component.

## Dependencies
Angular Dependencies 	| Description
---------- 				| ----------
angular					| The core dependency since the cep-questionnaire is an AngularJS directive
angular-bootstrap 		| Renders the datepicker on date input fields
angular-resource 		| Convenient helper services for RESTful interaction
angular-route 			| For the questionnaire routing and to get access to the url route params
angular-sanitize		| Sanitizes HTML
angular-touch			| ngClick for touch devices
angular-uuid4 			| Generator for ids to make question ids more unique


Other Dependencies 		| Description
---------- 				| ----------
bootstrap-sass-official | Dependency for the styling of the cep-questionnaire
checklist-model 		| Helper directive for multi-select components based on checkboxes
jquery 					| Selector library mostly used for path traversing when focusing
jsondiffpatch 			| Updates the questionnaire data with the results form a server roundtrip
modernizr 				| Detection of browser features
moment 					| For javascript date conversions and computations


## Installation
Through Yarn if hosted on a private yarn repository:

	$ yarn install cep-questionnaire --save

Through Yarn declared directly as dependency:

	package.json

	{
		...
		"dependencies": {
			...,
			"cep-questionnaire": "path/to/questionnaire-component"
		}
	}

If no package manager is used, the questionnaire component can be manually installed into the
integrating app, that is, the component can be put directly into the dedicated vendor directory.

## Usage
All files declared under the `main` namespace in the `package.json` must be included in `index.html`.
Furthermore, all dependencies must be satisfied and included before these main-files. Then the
`reflexCepAngularApp` module must be declared as a dependency in the integrating AngularJS-App:

	angular
		.module('myPortalApp', [
			'...',
			'reflexCepAngularApp'
		]);

## API
The API of the cep-questionnaire is split between public directives, public services, and public events.
Please refer to the ReFlex Integrator's Handbook (Chapter about CEP Integration) for additional details.
