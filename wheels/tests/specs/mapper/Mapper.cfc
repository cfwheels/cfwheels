/**
 * This tests Wheels Application Bootstrapping
 */
component extends="testbox.system.BaseSpec" {
    variables.checkLegacyFunctionsConfig = [
        "get",
        "patch",
        "post",
        "put",
        "delete",
        "root",
        "wildcard",
        "resource",
        "resources",
        "member",
        "collection",
        "scope",
        "constraints",
        "controller",
        "end",
        "namespace",
        "package",
	];

	function run() {


		describe("Initialization", function() {

            afterEach(function( currentSpec ) {
                structDelete(variables, "m");
            });

			it("Exposes all public API legacy functions", function(){
                m = new wheels.Mapper();
			    for ( var func in checkLegacyFunctionsConfig ) {
			        expect( isCustomFunction(m[func])).toBeTrue();
			    }
			});

			it("Initialises with defaults", function(){
                m = new wheels.Mapper();
                prepareMock(m);
               expect(m.$getProperty("restful", "variables")).toBeTrue();
               expect(m.$getProperty("methods", "variables")).toBeTrue();
			});
			it("Initialises with restful false", function(){
                m = new wheels.Mapper(restful = false);
                prepareMock(m);
               expect(m.$getProperty("restful", "variables")).toBeFalse();
               expect(m.$getProperty("methods", "variables")).toBeFalse();
			});
			it("Initialises with restful false & methods true", function(){
                m = new wheels.Mapper(
                    restful = false,
                    methods = true);
                prepareMock(m);
               expect(m.$getProperty("restful", "variables")).toBeFalse();
               expect(m.$getProperty("methods", "variables")).toBeTrue();
			});
		});
	}

}
