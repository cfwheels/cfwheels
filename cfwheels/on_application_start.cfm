<!--- Component paths --->
<cfset application.componentPathTo = structNew()>
<cfset application.filePathTo = structNew()>
<cfset application.componentPathTo.controllers = "app.controllers">
<cfset application.filePathTo.controllers = "/app/controllers">
<cfset application.componentPathTo.models = "app.models">
<cfset application.filePathTo.models = "/app/models">

<!--- App directory paths --->
<cfset application.pathTo = structNew()>
<cfset application.pathTo.app = "/app">
<cfset application.pathTo.cfwheels = "/cfwheels">
<cfset application.pathTo.config = "/config">
<cfset application.pathTo.scripts = "/generator/index.cfm">
<cfset application.pathTo.views = application.pathTo.app & "/views">
<cfset application.pathTo.layouts = application.pathTo.views & "/layouts">
<cfset application.pathTo.helpers = application.pathTo.app & "/helpers">
<cfset application.pathTo.includes = application.pathTo.cfwheels & "/includes">
<cfset application.pathTo.functions = application.pathTo.cfwheels & "/functions">

<!--- Default public paths --->
<cfset application.pathTo.images = "/media/images">
<cfset application.pathTo.stylesheets = "/media/stylesheets">
<cfset application.pathTo.javascripts = "/media/javascripts">
<cfset application.templates.pageNotFound = "/app/404.cfm">

<!--- File system paths --->
<cfset application.absolutePathTo = structNew()>
<cfset application.absolutePathTo.webroot = expandPath("/")>
<cfset application.absolutePathTo.cfwheels = expandPath(application.pathTo.cfwheels)>

<!--- Create the defaults structure --->
<cfset application.default = structNew()>

<!--- Include some Wheels specific stuff --->
<cfset application.wheels = structNew()>
<cfset application.wheels.version = "0.7">
<cfset application.wheels.controllers = structNew()>
<cfset application.wheels.routes = arrayNew(1)>
<cfset application.wheels.models = structNew()>

<!--- Used for pluralization and singularization functions --->
<cfset application.wheels.pluralizationRules = arrayNew(2)>
<cfset application.wheels.singularizationRules = arrayNew(2)>

<!--- Pluralization --->
<!--- Uncountables --->
<cfset application.wheels.pluralizationRules[1][1] = "equipment">
<cfset application.wheels.pluralizationRules[1][2] = "equipment">
<cfset application.wheels.pluralizationRules[2][1] = "information">
<cfset application.wheels.pluralizationRules[2][2] = "information">
<cfset application.wheels.pluralizationRules[3][1] = "rice">
<cfset application.wheels.pluralizationRules[3][2] = "rice">
<cfset application.wheels.pluralizationRules[4][1] = "money">
<cfset application.wheels.pluralizationRules[4][2] = "money">
<cfset application.wheels.pluralizationRules[5][1] = "species">
<cfset application.wheels.pluralizationRules[5][2] = "species">
<cfset application.wheels.pluralizationRules[6][1] = "series">
<cfset application.wheels.pluralizationRules[6][2] = "series">
<cfset application.wheels.pluralizationRules[7][1] = "fish">
<cfset application.wheels.pluralizationRules[7][2] = "fish">
<cfset application.wheels.pluralizationRules[8][1] = "sheep">
<cfset application.wheels.pluralizationRules[8][2] = "sheep">
<!--- Irregulars --->
<cfset application.wheels.pluralizationRules[9][1] = "person">
<cfset application.wheels.pluralizationRules[9][2] = "people">
<cfset application.wheels.pluralizationRules[10][1] = "man">
<cfset application.wheels.pluralizationRules[10][2] = "men">
<cfset application.wheels.pluralizationRules[11][1] = "child">
<cfset application.wheels.pluralizationRules[11][2] = "children">  		
<cfset application.wheels.pluralizationRules[12][1] = "sex">
<cfset application.wheels.pluralizationRules[12][2] = "sexes">
<cfset application.wheels.pluralizationRules[13][1] = "move">
<cfset application.wheels.pluralizationRules[13][2] = "moves">
<!--- Everything else --->
<cfset application.wheels.pluralizationRules[14][1] = "(quiz)$">
<cfset application.wheels.pluralizationRules[14][2] = "\1zes">
<cfset application.wheels.pluralizationRules[15][1] = "^(ox)$">
<cfset application.wheels.pluralizationRules[15][2] = "\1en">
<cfset application.wheels.pluralizationRules[16][1] = "([m|l])ouse$">
<cfset application.wheels.pluralizationRules[16][2] = "\1ice">
<cfset application.wheels.pluralizationRules[17][1] = "(matr|vert|ind)ix|ex$">
<cfset application.wheels.pluralizationRules[17][2] = "\1ices">
<cfset application.wheels.pluralizationRules[18][1] = "(x|ch|ss|sh)$">
<cfset application.wheels.pluralizationRules[18][2] = "\1es">
<cfset application.wheels.pluralizationRules[19][1] = "([^aeiouy]|qu)ies$">
<cfset application.wheels.pluralizationRules[19][2] = "\1y">
<cfset application.wheels.pluralizationRules[20][1] = "([^aeiouy]|qu)y$">
<cfset application.wheels.pluralizationRules[20][2] = "\1ies">
<cfset application.wheels.pluralizationRules[21][1] = "(hive)$">
<cfset application.wheels.pluralizationRules[21][2] = "\1s">
<cfset application.wheels.pluralizationRules[22][1] = "(?:([^f])fe|([lr])f)$">
<cfset application.wheels.pluralizationRules[22][2] = "\1\2ves">
<cfset application.wheels.pluralizationRules[23][1] = "sis$">
<cfset application.wheels.pluralizationRules[23][2] = "ses">
<cfset application.wheels.pluralizationRules[24][1] = "([ti])um$">
<cfset application.wheels.pluralizationRules[24][2] = "\1a">
<cfset application.wheels.pluralizationRules[25][1] = "(buffal|tomat)o$">
<cfset application.wheels.pluralizationRules[25][2] = "\1oes">
<cfset application.wheels.pluralizationRules[26][1] = "(bu)s$">
<cfset application.wheels.pluralizationRules[26][2] = "\1ses">
<cfset application.wheels.pluralizationRules[27][1] = "(alias|status)">
<cfset application.wheels.pluralizationRules[27][2] = "\1es">
<cfset application.wheels.pluralizationRules[28][1] = "(octop|vir)us$">
<cfset application.wheels.pluralizationRules[28][2] = "\1i">
<cfset application.wheels.pluralizationRules[29][1] = "(ax|test)is$">
<cfset application.wheels.pluralizationRules[29][2] = "\1es">
<cfset application.wheels.pluralizationRules[30][1] = "s$">
<cfset application.wheels.pluralizationRules[30][2] = "s">
<cfset application.wheels.pluralizationRules[31][1] = "$">
<cfset application.wheels.pluralizationRules[31][2] = "s">

<!--- Singularization --->
<!--- Uncountables --->
<cfset application.wheels.singularizationRules[1][1] = "equipment">
<cfset application.wheels.singularizationRules[1][2] = "equipment">
<cfset application.wheels.singularizationRules[2][1] = "information">
<cfset application.wheels.singularizationRules[2][2] = "information">
<cfset application.wheels.singularizationRules[3][1] = "rice">
<cfset application.wheels.singularizationRules[3][2] = "rice">
<cfset application.wheels.singularizationRules[4][1] = "money">
<cfset application.wheels.singularizationRules[4][2] = "money">
<cfset application.wheels.singularizationRules[5][1] = "species">
<cfset application.wheels.singularizationRules[5][2] = "species">
<cfset application.wheels.singularizationRules[6][1] = "series">
<cfset application.wheels.singularizationRules[6][2] = "series">
<cfset application.wheels.singularizationRules[7][1] = "fish">
<cfset application.wheels.singularizationRules[7][2] = "fish">
<cfset application.wheels.singularizationRules[8][1] = "sheep">
<cfset application.wheels.singularizationRules[8][2] = "sheep">
<!--- Irregulars --->
<cfset application.wheels.singularizationRules[9][1] = "person">
<cfset application.wheels.singularizationRules[9][2] = "people">
<cfset application.wheels.singularizationRules[10][1] = "man">
<cfset application.wheels.singularizationRules[10][2] = "men">
<cfset application.wheels.singularizationRules[11][1] = "child"> 	
<cfset application.wheels.singularizationRules[11][2] = "children"> 
<cfset application.wheels.singularizationRules[12][1] = "sex">
<cfset application.wheels.singularizationRules[12][2] = "sexes">
<cfset application.wheels.singularizationRules[13][1] = "move">
<cfset application.wheels.singularizationRules[13][2] = "moves">
<!--- Everything else --->
<cfset application.wheels.singularizationRules[14][1] = "(quiz)zes$">
<cfset application.wheels.singularizationRules[14][2] = "\1">
<cfset application.wheels.singularizationRules[15][1] = "(matr)ices$">
<cfset application.wheels.singularizationRules[15][2] = "\1ix">
<cfset application.wheels.singularizationRules[16][1] = "(vert|ind)ices$">
<cfset application.wheels.singularizationRules[16][2] = "\1ex">
<cfset application.wheels.singularizationRules[17][1] = "^(ox)en">
<cfset application.wheels.singularizationRules[17][2] = "\1">
<cfset application.wheels.singularizationRules[18][1] = "(alias|status)es$">
<cfset application.wheels.singularizationRules[18][2] = "\1">
<cfset application.wheels.singularizationRules[19][1] = "([octop|vir])i$">
<cfset application.wheels.singularizationRules[19][2] = "\1us">
<cfset application.wheels.singularizationRules[20][1] = "(cris|ax|test)es$">
<cfset application.wheels.singularizationRules[20][2] = "\1is">
<cfset application.wheels.singularizationRules[21][1] = "(shoe)s$">
<cfset application.wheels.singularizationRules[21][2] = "\1">
<cfset application.wheels.singularizationRules[22][1] = "(o)es$">
<cfset application.wheels.singularizationRules[22][2] = "\1">
<cfset application.wheels.singularizationRules[23][1] = "(bus)es$">
<cfset application.wheels.singularizationRules[23][2] = "\1">
<cfset application.wheels.singularizationRules[24][1] = "([m|l])ice$">
<cfset application.wheels.singularizationRules[24][2] = "\1ouse">
<cfset application.wheels.singularizationRules[25][1] = "(x|ch|ss|sh)es$">
<cfset application.wheels.singularizationRules[25][2] = "\1">
<cfset application.wheels.singularizationRules[26][1] = "(m)ovies$">
<cfset application.wheels.singularizationRules[26][2] = "\1ovie">
<cfset application.wheels.singularizationRules[27][1] = "(s)eries$">
<cfset application.wheels.singularizationRules[27][2] = "\1eries">
<cfset application.wheels.singularizationRules[28][1] = "([^aeiouy]|qu)ies$">
<cfset application.wheels.singularizationRules[28][2] = "\1y">
<cfset application.wheels.singularizationRules[29][1] = "([lr])ves$">
<cfset application.wheels.singularizationRules[29][2] = "\1f">
<cfset application.wheels.singularizationRules[30][1] = "(tive)s$">
<cfset application.wheels.singularizationRules[30][2] = "\1">
<cfset application.wheels.singularizationRules[31][1] = "(hive)s$">
<cfset application.wheels.singularizationRules[31][2] = "\1">
<cfset application.wheels.singularizationRules[32][1] = "([^f])ves$">
<cfset application.wheels.singularizationRules[32][2] = "\1fe">
<cfset application.wheels.singularizationRules[33][1] = "(^analy)ses$">
<cfset application.wheels.singularizationRules[33][2] = "\1sis">
<cfset application.wheels.singularizationRules[34][1] = "((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$">
<cfset application.wheels.singularizationRules[34][2] = "\1\2sis">
<cfset application.wheels.singularizationRules[35][1] = "([ti])a$">
<cfset application.wheels.singularizationRules[35][2] = "\1um">
<cfset application.wheels.singularizationRules[36][1] = "(n)ews$">
<cfset application.wheels.singularizationRules[36][2] = "\1ews">
<cfset application.wheels.singularizationRules[37][1] = "s$">
<cfset application.wheels.singularizationRules[37][2] = "">

<!--- Take the framework functions and save them to application --->
<cfset application.core = structNew()>
<cfinclude template="#application.pathTo.includes#/core_includes.cfm">

<!--- Include environment and database connection info --->
<cfinclude template="#application.pathTo.config#/environment.ini" />
<cfinclude template="#application.pathTo.config#/database.ini" />