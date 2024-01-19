component extends="testbox.system.BaseSpec" {

	/**
	 * @beforeAll
	 */
	function initializeCounter() {
		expect( variables.counter ).toBe( 0 );
		variables.counter = 1;
	}

	/**
	 * @afterAll
	 */
	function setCounterBackToZero() {
		variables.counter = 0;
	}

	/**
	 * @beforeEach
	 */
	function runThisBefore() {
		variables.counter++;
	}

	/**
	 * @beforeEach
	 */
	function runThisBeforeAsWell() {
		variables.counter++;
	}

	/**
	 * @afterEach
	 */
	function runThisAfter(currentSpec) {
		if ( arguments.currentSpec == "runs lifecycle annotation hooks just as if they were in the suite" ) {
			expect( variables.counter ).toBe( 4 );
		} else {
			expect( variables.counter ).toBe( 8 );
		}
	}
}
