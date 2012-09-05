# Upgrading to Wheels 1.1.x

*Instructions for upgrading your ColdFusion on Wheels 1.0.x application to Wheels 1.1.x.*

If you are upgrading from Wheels 1.0 or newer, the easiest way to upgrade is to replace the `wheels`
folder with the new one from the 1.1 download.

## Plugin Compatibility

Be sure to review your plugins and their compatibility with your newly-updated version of Wheels. Some
plugins may stop working, throw errors, or cause unexpected behavior in your application.

## Supported System Changes

  * _1.1:_ The minimum Adobe ColdFusion version required is now 8.0.1.
  * _1.1:_ The minimum Railo version required is now 3.1.2.020.
  * _1.1:_ The H2 database engine is now supported.

## File System Changes

  * _1.1:_ The `.htaccess` file has been changed. Be sure to copy over the new one from the new version
  1.1 download and copy any addition changes that you may have also made to the original version.

## Database Structure Changes

  * _1.1:_ By default, Wheels 1.1 will wrap database queries in transactions. This requires that your
  database engine supports transactions. For MySQL in particular, you can convert your MyISAM tables to
  InnoDB to	be compatible with this new functionality. Otherwise, to turn off automatic transactions,
  place a call to `set(transactionMode="none")`.
  * _1.1:_ Binary data types are now supported.

## CFML Code Changes

### Model Code

  * _1.1:_ Validations will be applied to some model properties automatically. This may cause unintended
  behavior with your validations. To turn this setting off, call `set(automaticValidations=false)` in
  `config/settings.cfm`.
  * _1.1:_ The `class` argument in `hasOne()`, `hasMany()`, and `belongsTo()` has been deprecated. Use
  the `modelName` argument instead.
  * _1.1:_ `afterFind()` callbacks no longer require special logic to handle the setting of properties
  in objects and queries. (The "query way" works for both cases now.) Because `arguments` will always be
  passed in to the method, you can't rely on `StructIsEmpty()` to determine if you're dealing with an
  object or not. In the rare cases that you need to know, you can now call `isInstance()` or `isClass()`
  instead.
  * _1.1:_ On create, a model will now set the `updatedAt` auto-timestamp to the same value as the
  `createdAt` timestamp. To override this behavior, call `set(setUpdatedAtOnCreate=false)` in
  `config/settings.cfm`.

### View Code

  * _1.1:_ Object form helpers (e.g. `textField()` and `radioButton()`) now automatically display a
  `label` based on the property name. If you left the `label` argument blank while using an earlier
  version of Wheels, some labels may start appearing automatically, leaving you with unintended results.
  To stop a label from appearing, use `label=false` instead.
  * _1.1:_ The `contentForLayout()` helper to be used in your layout files has been deprecated. Use the
  `includeContent()` helper instead.
  * _1.1:_ In `production` mode, query strings will automatically be added to the end of all asset URLs
  (which includes !JavaScript includes, stylesheet links, and images. To turn off this setting, call
  `set(assetQueryString=false)` in `config/settings.cfm`.
  * _1.1:_ `stylesheetLinkTag()` and `javaScriptIncludeTag()` now accept external URLs for the
  `source`/`sources` argument. If you manually typed out these tags in previous releases, you can now
  use these helpers instead.
  * _1.1:_ `flashMessages()`, `errorMessageOn()` and `errorMessagesFor()` now create camelCased `class`
  attributes instead (for example `error-messages` is now `errorMessages`). The same goes for the
  `class` attribute on the tag that wraps form elements with errors: it is now `fieldWithErrors`.

### Controller Code

  * _1.1.1:_ The `if` argument in all validation functions is now deprecated. Use the `condition`
  argument instead.