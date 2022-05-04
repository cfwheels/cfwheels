# Running Local Development Serevers

### Starting a local development server

With Commandbox, we don't need to have Lucee or Adobe ColdFusion installed locally. With a simple command, we can make Commandbox go and get the CFML engine we've requested, and quickly create a server running on Undertow. Make sure you're in the root of your website, and then run:

{% tabs %}
{% tab title="CommanBox" %}
server start
{% endtab %}

{% tab title="Second Tab" %}

{% endtab %}
{% endtabs %}

The server will then start on a random port on `127.0.0.1` and will create a `server.json` file in your webroot. We can add various options to `server.json` to customise our server. Here's an example:

```json
{
    "name":"myApp",
    "force":true,
    "web":{
        "http":{
            "port":60000
        },
        "rewrites":{
            "enable":true,
            "config":"urlrewrite.xml"
        }
    }
}
```

In this example, I've set the servername to `myApp`, meaning I can now start the server from any directory by simply calling `start myApp`. I've also specified a specific port, `60000`, but you can specify any port you want, or just remove that to start on a random port each time. Lastly, I've enabled URL rewriting, and pointing the URL rewrite configuration file to the `urlrewrite.xml` which is included in CFWheels 2.x. (If you've used the `wheels new` command to create your app, this will already be done for you).
