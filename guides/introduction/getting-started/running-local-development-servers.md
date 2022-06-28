# Running Local Development servers

### Starting a local development server

With Commandbox, we don't need to have Lucee or Adobe ColdFusion installed locally. With a simple command, we can make Commandbox go and get the CFML engine we've requested, and quickly create a server running on Undertow. Make sure you're in the root of your website, and then run:

{% tabs %}
{% tab title="CommanBox" %}
server start
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

#### Using custom hostnames

You can also specify hosts other than localhost: there's a useful commandbox module to do that ([Host updater](https://www.forgebox.io/view/commandbox-hostupdater)) which will automatically create entries in your hosts file to allow for domains such as `myapp.local` running on port 80. You can install it via `install commandbox-hostupdater` when running the box shell with administrator privileges.

### Controlling local servers

Obviously, anything you start, you might want to stop. Servers can be stopped either via right/ctrl clicking on the icon in the taskbar, or by the `stop` command

{% tabs %}
{% tab title="CommandBox" %}
server stop
{% endtab %}
{% endtabs %}

You can also stop the server from anywhere by name:

{% tabs %}
{% tab title="CommandBox" %}
server stop myApp
{% endtab %}
{% endtabs %}

If you want to see what server configurations exist on your system and their current status, simply do `server list`

{% tabs %}
{% tab title="CommandBox" %}
server list
{% endtab %}
{% endtabs %}

```shell-session
myapp (stopped)
 http://127.0.0.1:60000
 Webroot: /Users/cfwheels/Documents/myapp

myAPI (stopped)
 http://127.0.0.1:60010
 Webroot: /Users/cfwheels/Documents/myAPI

megasite (stopped)
 http://127.0.0.1:61280
 CF Engine: lucee 4.5.4+017
 Webroot: /Users/cfwheels/Documents/megasite

awesomesite (stopped)
 http://127.0.0.1:60015
 CF Engine: lucee 4.5.4+017
 Webroot: /Users/cfwheels/Documents/awesomeo
```

To remove a server configuration from the list, you can do `server forget myapp`. Note the status of the servers on the list is somewhat unreliable, as you it only remembers the last known state of the server: so if you start a server and then turn on your local machine, it may remember it as `running` which is why we recommend the use of `force: true`in the `server.json` file.

### Specifying different CF engines

By default, Commandbox will run Lucee (version 4.5.x at time of writing). You may wish to specify an exact version of Lucee, or use Adobe ColdFusion. We can do this via either setting the appropriate `cfengine` setting in `server.json`, or at runtime with the `cfengine=` argument.

{% tabs %}
{% tab title="CommandBox" %}
_Start the default engine_

CommandBox> start

\_\_

_Start the latest stable Lucee 5.x engine_

CommandBox> start cfengine=lucee@5

\_\_

_Start a specific engine and version_

CommandBox> start cfengine=adobe@10.0.12

\_\_

_Start the most recent Adobe server that starts with version "11"_

CommandBox> start cfengine=adobe@11

\_\_

_Start the most recent adobe engine that matches the range_

CommandBox> start cfengine="adobe@>9.0 <=11"
{% endtab %}
{% endtabs %}

Or via `server.json`

```json
{
    "name":"myApp",
    "force":true,
    "web":{
        "http":{
            "host":"localhost",
            "port":60000
        },
        "rewrites":{
            "enable":true,
            "config":"urlrewrite.xml"
        }
    },
    "app":{
        "cfengine":"adobe@2016"
    },
}
```

{% hint style="info" %}
#### CFIDE / Lucee administrators

The default username and password for all administrators is `admin` & `commandbox`
{% endhint %}

You can of course run multiple servers, so if you need to test your app on Lucee 4.x, Lucee 5.x and Adobe 2016, you can just start three servers with different `cfengine=` arguments!

{% hint style="info" %}
#### Watch out

Commandbox 5.1 required to install dependencies easily
{% endhint %}

CFWheels can run just fine on lucee-light (which is after all, Lucee, minus all the extensions) but at the minimum requires the following extensions to be installed as dependencies in your `box.json`

```json
"dependencies":{
    "lucee-image":"lex:https://ext.lucee.org/lucee.image.extension-1.0.0.35.lex",
    "lucee-zip": "lex:https://ext.lucee.org/compress-extension-1.0.0.2.lex",
    json"lucee-esapi": "lex:https://ext.lucee.org/esapi-extension-2.1.0.18.lex"
}
```

Once added to your box.json file, while the server is running, just do `box install`, which will install the dependencies, and load them into the running server within 60 seconds.

Alternatively you can download the extensions and add them manually to your server root's deploy folder (i.e `\WEB-INF\lucee-server\deploy`)
