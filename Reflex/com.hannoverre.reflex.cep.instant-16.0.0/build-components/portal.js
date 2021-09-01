(function () {
	'use strict';

	//~~~~~~WRAPPER APP~~~~~~
	angular
		.module('instantCepApp', [
			'ngRoute',
			'reflexCepAngularApp'
		]);

	//~~~~~~ERROR HANDLING~~~~~~
	angular
		.module('instantCepApp')
			.run(function ($location) {

				window.cepApi.onNotification(function(args) {
				    var headline = window.encodeURIComponent(args.headline); //translation key
				    var type = window.encodeURIComponent(args.type);
				    var message = window.encodeURIComponent(args.message); //translation key
				    //args.error = error object, may be undefined

				    //navigate to 500 page
					$location.url('/error?headline=' + headline + '&type=' + type + '&message=' + message);
				});
			})
			.config(function ($routeProvider) {
				$routeProvider
				.when('/error', {
					controller: 'ErrorController',
					templateUrl: 'views/error.html'
				})
			})
			.controller('ErrorController', ErrorController);

	function ErrorController($scope, $location) {
		$scope.error = $location.search();
	}
})();
