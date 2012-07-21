# Redirecting Users

*Use redirection to keep your application user friendly.*

When a user submits a form, you do *not* want to show any content on the page that handles the form
submission! Why? Because if you do, and the user hits refresh in their browser, the form handling code
could be triggered again, possibly causing duplicate entries in your database, multiple emails being
sent, etc.

## Remember to Redirect

To avoid the above problem, it is recommended to always redirect the user after submitting a form. In
Wheels this is done with the `redirectTo()` function. It is basically a wrapper around the `cflocation`
tag in CFML.

Being that `redirectTo()` is a Wheels function, it can accept the `controller`, `action`, and `key`
arguments so that you can easily redirect to other actions in your application.

## Three Ways to Redirect

Let's look at the three ways you can redirect in Wheels.

### 1. Redirecting to Another Action

You can redirect the user to another action in your application simply by passing in the `controller`,
`action`, and `key` arguments. You can also pass in any other arguments that are accepted by the
`URLFor()` function, like `host`, `params`, etc. (The `URLFor()` function is what Wheels uses internally
to produce the URL to redirect to.)

### 2. Redirection Using Routes

If you have configured any routes in `config/routes.cfm` you can use them when redirecting as well.
Just pass in the route's name to the `route` argument together with any additional arguments needed for
the route in question. You can read more about routing in the [Using Routes][1] chapter.

### 3. Redirecting to the Referring URL

It's very common that all you want to do when a user submits a form is send them back to where they came
from. (Think of a user posting a comment on a blog post and then being redirected back to view the post
with their new comment visible as well.) For this, we have the `back` argument. Simply pass in
`back=true` to `redirectTo()`, and the user will be redirected back to the page they came from.

#### Handling an Invalid Referrer

The referring URL is retrieved from the `cgi.http_referer` value. If this value is blank or comes from a
different domain than the current one, Wheels will redirect the visitor to the root of your website
instead.

If you want to specify exactly where to send the visitor when the referring domain is blank/foreign, you
can pass in the normal `URLFor()` arguments like `route`, `controller`, `action`, etc. These will be
used only when Wheels can't redirect to the referrer because it's invalid.

## Appending Params

Sometimes it's useful to be able to send the visitor back to the same URL they came from but with extra
parameters added to it. You can do this by using the `params` argument. Note that Wheels will append to
the URL and not replace it in this case.

## `addToken` and `statusCode` Arguments

Common for all three methods above is that you can also pass in the `addToken` and `statusCode`
arguments, which will be directly passed along to CFML's `cflocation` tag.

[1]: 12%20Using%20Routes.md