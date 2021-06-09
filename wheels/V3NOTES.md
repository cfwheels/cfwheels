# v3 dev notes

### Breaking Changes:

 - Rocketunit is now marked as deprecated and will be removed in wheels 4
 - `Application.cfc`, `index.cfm`  will need to be replaced
 - `rewrite.cfm` will need to be removed
 - URL rewriting no longer uses `rewrite.cfm`, and will strictly determine URL behaviour from `set(urlRewriting="on")`
 - All includes within the core now use mappings with absolute links as opposed to relative links; whilst this shouldn't affect your application, it might affect plugins or other code which tries to use internal core methods.

### Testing:

 - Core tests now use testbox, and it's recommended to upgrade your own tests before moving to wheels 4

### App Structure:

 - This new version uses it's own `Application.cfc` which means you can set the mappings before wheels initializes; this means you can move the wheels folder outside the webroot and set any other folder mappings as you see fit.
 - There are two primary mappings:
  - `/wheels`     the mapping to the main wheels directory
  - `/app`        Application source code, i.e controllers, models, config etc.

 By Default:
 - `/app` points to the webroot
 - `/wheels` points to a subdirectory within the webroot named `wheels`

 This is so the developer has the easiest route to get going and won't require configuring mappings.
