/**
 * Hand-typed target for Act 3 — the association you add after the Comment scaffold.
 * Diff against the live app with:
 *   diff app/models/Post.cfc docs/presentations/cfug-2026-09-15/demo-app/Post.cfc
 */
component extends="Model" {
	function config() {
		hasMany(name="comments", dependent="delete");
	}
}
