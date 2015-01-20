
console.log(JSON.stringify(
	{ region : 'lon1'
	, image : "coreos-stable"
	, size : "512mb"
	, user_data: require('fs').readFileSync('user_data.slave.yaml').toString()
        , ssh_keys: [1234, 5678]
	, name: 'yourhostname' 
	}))
