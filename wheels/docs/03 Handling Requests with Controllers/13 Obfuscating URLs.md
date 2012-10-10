# Obfuscating URLs

*Hide your primary key values from nosy users.*

The Wheels convention of using primary key values when building links (as in the `key` argument to 
`linkTo()` for example) will lead to them being exposed to anyone interested in the browser's URL bar. 
Using the built-in URL obfuscation functionality in Wheels, you can hide the real primary key values 
from nosy users.

## What URL Obfuscation Does

When URL obfuscation is turned off (which is the default setting in Wheels), this is how a lot of your 
URLs will end up looking:

	http://localhost/user/profile/99

Here, `99` is the primary key value of a record in your `users` table.

After enabling URL obfuscation, this is how those URLs will look instead:

	http://localhost/user/profile/b7ab9a50

The value `99` has now been obfuscated by Wheels to `b7ab9a50`. This makes it harder for nosy users to 
substitute the value to see how many records are in your `users` table, to name just one example.

## How to Use It

To turn on URL obfuscation, all you have to do is call `set(obfuscateURLs=true)` in the 
`config/settings.cfm` file.

Once you do that, Wheels will handle everything else. Obviously, the main things Wheels does are 
obfuscating the primary key value when using the `linkTo()` function and deobfuscating it on the 
receiving end. Wheels will also obfuscate all other params sent in to `linkTo()` as well as any value in 
a form sent using a `get` request.

In some circumstances, you will need to obfuscate and deobfuscate values yourself if you link to pages 
without using the `linkTo()` function, for example. In these cases, you can use the `obfuscateParam()` 
and `deObfuscateParam()` functions to do the job for you.

## Is This Really Secure?

No, this is not meant to add a high level of security to your application. It just obfuscates the 
values, making casual observation harder. It does not encrypt values, so keep that in mind when using 
this approach.