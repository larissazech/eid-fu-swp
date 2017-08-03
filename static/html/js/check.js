$(function() {
	
	var redirectIfClientIsAvailable = function(url) {
		$('#result').html('Detected eID-Client. Forwarding...');
		setTimeout(function() {
			window.location = "../?clientUrl=" + url;
		}, 3000);
	};
	
	var checker = new ClientChecker(redirectIfClientIsAvailable, 5000);
});