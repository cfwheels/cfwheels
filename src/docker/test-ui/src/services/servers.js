let servers =
[
	{
		servername: 'Lucee 5',
		server: 'http://localhost:60005'
	},
	{
		servername: 'Adobe ColdFusion 2016',
		server: 'http://localhost:62016'
	},
	{
		servername: 'Adobe ColdFusion 2018',
		server: 'http://localhost:62018'
	}
]

let databases = [
	{
		databasename: 'MySQL 5.6',
		database: 'mysql'
	},
	{
		databasename: 'MSSQL 2017',
		database: 'sqlserver'
	},
	{
		databasename: 'PostGres',
		database: 'postgres'
	}
]

let testsuites = []

for (var s = 0; s < servers.length; s++){
	for (var d = 0; d < databases.length; d++){
		testsuites.push({
			id: servers[s].server + '_' + databases[d].database,
			displayname: servers[s].servername + ' ' + databases[d].databasename,
			servername: servers[s].servername,
			server: servers[s].server,
			databasename: databases[d].databasename,
			database: databases[d].database,
			results: null
		})
	}
}
export default testsuites
