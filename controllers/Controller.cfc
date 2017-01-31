/**
 * This is the parent controller file that all your controllers should extend.
 * You can add functions to this file to make them globally available in all your controllers.
 * 
 * Do not delete this file.
 * 
 * NOTE: When extending this controller and implementing `init()` in the child controller, don't
 * forget to call this base controller's `init()` via `super.init()`, or else the call to
 * `protectFromForgery` below will be skipped.
 * 
 * Example controller extending this one:
 * 
 * component extends="Controller" {
 *   function init() {
 *     // Call parent constructor
 *     super.init();
 * 
 *     // Your own init logic here.
 *     // ...
 *   }
 * }
 */
component extends="Wheels" {
	function init() {
		protectFromForgery();
	}
}
