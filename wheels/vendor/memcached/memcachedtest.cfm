<!-----------
	This is a simple test file to show how to use memcached.  in order for this to work right, you should 
	have a memcached instances up.  It is initially set up to look for the memcached server on the localhost, 
	however, the server location can be changed by passing it in to the memcached factory.
	
	the default port for memcached is 11211.
	
	you can actually use this memcached client across multiple memcached servers. You can specify multiple 
	memcached servers by making them a comma delimited list and sending that in to the init function.
	You can also send in an array list of servers.
	
	Be aware, that changing the number of servers or dropping one of the servers out of the server list is likely to 
	cause a loss of all cached data because it will have to recalculate the positions and locations of the keys.
	this will only happen if you init the memcached factory again with more or less servers than you start out with.
------------>
<cfset variables.memcachedFactory = createObject("component","memcachedFactory").init("127.0.0.1:11211")>
<cfset variables.memcached = variables.memcachedFactory.getmemcached()>

	<!--------- setting a long test ------------->
	<cfset set1 = variables.memcached.set(key="longTest",value=11111111111111111,expiry="5000")>
	<!----------- setting string test ----------->
	<cfset set2 = variables.memcached.set(key="simpleval",value="simpleval43466665532",expiry="5000")>
	<!------------ setting an int test ---------->
	<cfset set3 = variables.memcached.set(key="anothersimpleval",value=8,expiry="5000")>
	<!------------ setting array test ------------>
	<cfset arrTest = arrayNew(1)>
	<Cfset arrTest[1] = "someval">
	<Cfset arrTest[2] = "someotherval">
	<Cfset arrTest[3] = "someothersecondval">

	<cfset set4 = variables.memcached.set(key="arrTest",value=arrTest,expiry="5000")>
	
	<!---------------setting a struct test -------->
	<Cfset structTest = structNew()>
	<cfset structTest["somekey"] = "someval">
	<cfset structTest["someotherkey"] = "someother val">
	<Cfset structTest["someothersecondkey"] = "some other second val">

	<cfset set5 = variables.memcached.set(key="structTest",value=structTest,expiry="5000")>
	
	<!------------ setting a query test ---------->
	<cfset qTest = queryNew("col1,col2,col3")>
	<cfset queryAddRow(qTest,1)>
	<cfset querysetCell(qTest,"col1","yo")>
	<cfset querysetCell(qTest,"col2","adrian")>
	<cfset querysetCell(qTest,"col3",8888888)>

	<cfset set6 = variables.memcached.set(key="queryTest",value=qTest,expiry="5000")>
	
	<cfoutput>
		Here are there responses that were returned. boolean values that are returned when the set completes<br><br>
	
	<br><br>this is the long test - did it set correctly?  - <cfdump var="#set1.get()#">

	<br><br>this is the String test - did it set correctly?  - <cfdump var="#set2.get()#">
	<br><br>this is the Integer test - did it set correctly?  - <cfdump var="#set3.get()#">
	<br><br>this is the Array test - did it set correctly?  - <cfdump var="#set4.get()#">
	<br><br>this is the Struct test - did it set correctly?  - <cfdump var="#set5.get()#">
	<br><br>this is the query test - did it set correctly?  - <cfdump var="#set5.get()#">
	</cfoutput>

<!------------- this is retrieval test to make sure we can get it back out --------->

<!------------ long test ---------->
<cfset test1 = variables.memcached.get("longTest")>
	
<!------- simple string test ------------>
<cfset test2 = variables.memcached.get("simpleval")>
<!------- int test ------------->
<cfset test3 = variables.memcached.get("anothersimpleval")>
<!---------- array test ------------>
<cfset test4 = variables.memcached.get("arrTest")>
<!--------- struct test ------------>
<cfset test5 = variables.memcached.get("structTest")>
<!--------- query test ------------->
<Cfset test6 = variables.memcached.get("queryTest")>
<!-------- stats test just for fun ---------->
<!----
<Cfset test7 = variables.memcached.getStats()>
----->
<Cfset test7 = "">

<cfoutput>
	--------------------------------------------------------
<br><br>this is the long test - did we retrieve it correctly?  - <cfdump var="#test1#">
<br><br>this is the string test - did we retrieve it correctly?  - <cfdump var="#test2#">
<br><br>this is the integer test - did we retrieve it correctly?  - <cfdump var="#test3#">

<br><br>this is the array test - did we retrieve it correctly?  - <Cfdump var="#Test4#">
<br><br> as a comparison, this is what it should look like <br>
-------------------------------------- <br>
<cfdump var="#arrTest#">
<br>

<br><br>this is the struct test - did we retrieve it correctly?  - <Cfdump var="#Test5#">
<br><br> as a comparison, this is what it should look like <br>
-------------------------------------- <br>
<cfdump var="#structTest#">
<br>
<br><br>this is the query test - did we retrieve it correctly?  - <Cfdump var="#Test6#">
<br><br> as a comparison, this is what it should look like <br>
-------------------------------------- <br>
<cfdump var="#qTest#">
<br>
<br><br>this is the stats test -  
<Cfdump var="#Test7.toString()#">



<cfscript>
//	keyList = structKeylist(test7);
	//newOne = mapToStruct(test7);
</cfscript>


<cfscript>
	myendVal = "";
	myFutureTask = variables.memcached.asyncGet("queryTest");
	if (myFutureTask.isDone())	{
		myendVal = myFutureTask.get();
	} else {
		customSleep(2000);
		if (myFutureTask.isDone())	{
			myEndVal = myFutureTask.get();
		}
	}
</cfscript>
<cfdump var="#myFutureTask#">
<cfdump var="#myEndVal#">

<Cfset arrTestVals = arraynew(1)>
<cfset arrayAppend(arrTestVals,"longTest")>
<cfset arrayAppend(arrTestVals,"queryTest")>
<cfset arrayAppend(arrTestVals,"arrTest")>
<cfset arrayAppend(arrTestVals,"structTest")>
<cfset bulkvar = variables.memcached.getBulk(arrTestVals)>

<cfdump var="#bulkvar#">

<cfscript>
	myendVal = "";
	myFutureTask = variables.memcached.asyncGetBulk(arrTestVals);
	if (myFutureTask.isDone())	{
		myendVal = myFutureTask.get();
	} else {
		customSleep(2000);
		if (myFutureTask.isDone())	{
			myEndVal = myFutureTask.get();
		}
	}
</cfscript>
<cfdump var="#myFutureTask#">
<cfdump var="#myEndVal#">

</cfoutput>

<cffunction name="customSleep" output="No" returntype="void" hint=
		"Pauses execution for a number of milliseconds."
	>
		<cfargument name="milliseconds" required="Yes" type="numeric"/>
		<cfset var thread = CreateObject("java", "java.lang.Thread")/>
		<cfset thread.sleep(ARGUMENTS.milliseconds)/>
</cffunction>

<cfscript>
	function GetClassHeirarchy(obj){
		var thisClass = obj.GetClass();
		var sReturn = thisClass.GetName();
		do{  
			thisClass = thisClass.GetSuperClass();  
			sReturn = sReturn & " EXTENDS: #thisClass.GetName()#";
		} while(CompareNoCase(thisClass.GetName(), 'java.lang.Object'));
		
		return sReturn;
	}
	
	function mapToStruct(obj)	{
		var ret = structNew();
		if (not obj.isEmpty())	{
			do {
				key = obj.entrySet().iterator().next();
				thisval = obj.get(key);
				if (isdefined("thisval"))	{
					ret[key.toString()] = thisval;
				} else {
					ret[key.toString()] = "";
				}
			} while ( obj.entrySet().iterator().hasNext() );
		}
	}
</cfscript>