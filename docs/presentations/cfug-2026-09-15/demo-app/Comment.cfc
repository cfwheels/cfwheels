/**
 * Hand-typed target for Act 3 — belongsTo + presence validation.
 * Diff against the live app with:
 *   diff app/models/Comment.cfc docs/presentations/cfug-2026-09-15/demo-app/Comment.cfc
 */
component extends="Model" {
	function config() {
		belongsTo(name="post");
		validatesPresenceOf("author,body");
	}
}
