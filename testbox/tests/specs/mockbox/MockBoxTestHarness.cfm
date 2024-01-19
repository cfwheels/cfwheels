<!--- Create Mock Box --->
<cfset mockBox = createObject("component","testbox.system.MockBox").init()>
<!--- Create a mock based on Test CFC --->
<cfset Test = mockBox.createMock("testbox.tests.resources.Test")>

<cfoutput>
<!--- MOCKING REAL METHODS --->
<h2>Mocking Methods</h2>
Normal Test.getData() = #test.getData()#<br />
NOT MOCKED: Method called #test.$count("getData")# times<br />
<cfset test.$(method="getData",returns=1000,callLogging=true)>
Mock Method called #test.$count("getData")# times<br />
Mocked Test.getData() = #test.getData()#<br />
Mocked Test.getData() = #test.getData()#<br />
Mock Method called #test.$count("getData")# times

Mock Call Logger Dump: <cfdump var="#test.$callLog()#">

<!--- Mock Real Methods with Concatenation --->
<cfset test.$("getData").$results(1000)>
Mock Method called #test.$count("getData")# times<br />
Mocked Test.getData() = #test.getData()#<br />
Mocked Test.getData() = #test.getData()#<br />
Mock Method called #test.$count("getData")# times
Mock Call Logger Dump: <cfdump var="#test.$callLog()#">

<hr />
<!--- MOCKING VIRUTAL METHODS --->
<h2>Mocking Virtual Methods</h2>
We will add a virtual method called <strong>virtualReturn</strong>
<cfset test.$("virtualReturn").$results('Virtual Called Baby!!')>
Virtual Method called #test.$count("virtualReturn")# times<br />
Virtual Test.virtualReturn() = #test.virtualReturn()#<br />
Virtual Method called #test.$count("virtualReturn")# times
Mock Call Logger Dump: <cfdump var="#test.$callLog()#">

<hr />
<!--- MOCKING PROPERTIES --->
<h2>Mocking Properties</h2>
Original Reload property value: #test.getReload()#<br />
<cfset test.$property(propertyName="reload",mock=true,scope="variables")>
Mocked Reload Property value:  #test.getReload()#<br />

<hr />
<!--- MOCKING PRIVATE METHODS --->
<h2>Mocking Private Methods</h2>
Normal Test.getFullName() = #test.getFullName()#<br />
<cfset test.$("getName","My Mock Name")>
Mocked Test.getFullName() = #test.getFullName()#<br />

<hr />
<!--- STATE MACHINE MOCKING RESULTS --->
<h2>Mocking State Machine of Results</h2>
<p>Three results will be mocked, and they will be called 11 times. The results should recycle every 3 calls</p>
<cfset test.$("getSetting").$results("S1","S2","S3")>

<cfloop from="1" to="11" index="callCounter">
	Call ###callCounter# -> #test.getSetting('XX')# <br />
</cfloop>

<hr/>
<!--- STUB OBJECTS OR PLACEHOLDERS OF FUNCTIONALITY --->
<h2>Mocking Stubs</h2>
<p>Create a stub object and add behavior:</p>
<cfset stub = mockBox.createStub()>
<cfset stub.$("getName","Luis Majano")>
<p>Stub Fake Get Name: #stub.getName()#</p>

<!--- PREPARE A MOCK FOR SPYING --->
<cfset Test = createObject("component","testbox.tests.resources.Test")>
<cfset mockBox.prepareMock(test)>
<h2>Mocking Spy Methods</h2>
UnMocked Spy -> Test.getData() = #test.getData()#<br />
UnMocked Spy Call -> Test.spyTest() = #test.spyTest()# <br />
<cfset test.$("getData").$results(1000)>
Mocked Spy Test.getData() = #test.getData()#<br />
Mocked Spy Call -> Test.spyTest() = #test.spyTest()# <br />

<hr />
<!--- MOCKING WITH ARGUMENTS --->
<cfset Test = mockBox.createMock("testbox.tests.resources.Test")>
<h2>Mocking With Specific ARguments</h2>
<p>
	Unmocked <strong>getSetting() method</strong>:<br />
	AppMapping = #test.getSetting("AppMapping")#<br />
	DebugMode = #test.getSetting("DebugMode")#<br />
</p>
<cfset test.$(method='getSetting',callLogging=true).$args("AppMapping").$results("mockbox.testing")>
<cfset test.$(method='getSetting',callLogging=true).$args("DebugMode").$results("true")>
<p>
	Mocking the <strong>getSetting() method</strong>:<br />
	AppMapping = #test.getSetting("AppMapping")# = mockbox.testing<br />
	DebugMode = #test.getSetting("DebugMode")# = true<br />
	Call Counts = #test.$count('getSetting')#
	Mock Call Logger Dump: <cfdump var="#test.$callLog()#">
</p>

<!--- MOCKING A COLLABORATOR --->
<cfset Test = createObject("component","testbox.tests.resources.Test")>
<cfset mockCollaborator = MockBox.createMock(className="testbox.tests.resources.Collaborator",callLogging=true)>
<cfset mockCollaborator.$("getDataFromDB").$results(queryNew(""))>
<cfset Test.setCollaborator(mockCollaborator)>
Mock Call Logger Dump on Collaborator: <cfdump var="#mockCollaborator.$callLog()#">
Data Dump:
<cfdump var="#test.displayData()#">

<!--- PREPARE TEST FOR MOCCKING --->
<cfset Test.setCollaborator(structnew())>
<cfset mockBox.prepareMock(Test)>
<cfset Test.$property(propertyName="collaborator",mock=mockCollaborator)>
<cfdump var="#test.displayData()#">
<cfdump var="#test.$debug()#">


</cfoutput>
