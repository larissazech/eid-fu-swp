// Race conditions cannot occurs in js.
this.ClientChecker = function(callback, checkInterval) {
	var that = this;

	that.clientUrls = [
		"http://127.0.0.1:24727/eID-Client",
		"eid://127.0.0.1:24727/eID-Client",
		"http://localhost:24727/eID-Client",
		"eid://localhost:24727/eID-Client"
	];
	var statusParam = "?Status";

	var clientIsAvailable = false;

	var checkClientStatus = function() {
		if(!clientIsAvailable) {
			$.each(that.clientUrls, function(index, url) {
				$.get(url + statusParam)
					.done(function() {
						if(!clientIsAvailable) {
							clientIsAvailable = true;
							callback(that.clientUrls[index]);
						}
					});
			});
			setTimeout(checkClientStatus, checkInterval);
		}
	};

	// asynchronous function call
	setTimeout(checkClientStatus, 0);

	return this;
}
