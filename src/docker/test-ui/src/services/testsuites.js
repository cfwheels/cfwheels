import servers from "@/services/servers"
import databases from "@/services/databases"

let testsuites = []

for (var s = 0; s < servers.length; s++){
	for (var d = 0; d < databases.length; d++){
		if ((servers[s].servername == 'Adobe 2016' && databases[d].databasename == 'H2') ||
			(servers[s].servername == 'Adobe 2018' && databases[d].databasename == 'H2')) {
			break;
		}
		testsuites.push({
			id: servers[s].server + '_' + databases[d].database,
			displayname: servers[s].servername + ': ' + databases[d].databasename,
			servername: servers[s].servername,
			server: servers[s].server,
			databasename: databases[d].databasename,
			database: databases[d].database,
			status: null
		})
	}
}
export default testsuites
