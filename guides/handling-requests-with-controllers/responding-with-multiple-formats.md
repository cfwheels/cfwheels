---
description: >-
  CFWheels controllers provide some powerful mechanisms for responding to
  requests for content in XML, JSON, and other formats. You can build an API
  with ease using these functions.
---

# Responding with Multiple Formats

If you've ever needed to create an XML or JSON API for your Wheels application,\
you may have needed to go down the path of creating a separate controller or\
separate actions for the new format. This introduces the need to duplicate model\
calls or even break them out into a super long list of before filters. With\
this, your controllers can get pretty hairy pretty fast.

Using a few CFWheels functions, you can easily respond to requests for HTML, XML,\
JSON, and PDF formats without adding unnecessary bloat to your controllers.

### Requesting Different Formats

With CFWheels Provides functionality in place, you can request different formats\
using the following methods:

1. URL Variable
2. URL Extension
3. Request Header

Which formats you can request is determined by what you configure in the\
controller. See the section below on _Responding to Different Formats in the_\
_Controller_ for more details.

#### URL Variable

CFWheels will accept a URL variable called `format`. If you wanted to request the\
XML version of an action, for example, your URL call would look something like\
this:

```
http://www.example.com/products?format=xml
```

The same would go for JSON:

```
http://www.example.com/products?format=json
```

#### URL Extension

Perhaps a cleaner way is to request the format as a "file" extension. Here are\
the XML and JSON examples, respectively:

```
http://www.example.com/products.xml
http://www.example.com/products.json
```

This works similarly to the _URL variable_ approach mentioned above in that\
there will now be a key in the `params` struct set to the `format` requested.\
With the XML example, there will be a variable at `params.format` with a value\
of `xml`.

#### Request Header

If you are calling the CFWheels application as a web service, you can also request\
a given format via the HTTP `Accept` header.

If you are consuming the service with another CFWheels application, your\
`<cfhttp>` call would look something like this:

In this example, we are sending an `Accept` header with the value for the `xml`\
format.

```html
<cfhttp url="http://www.example.com/products">
    <cfhttpparam type="header" name="Accept" value="application/octet-stream">
</cfhttp>
```

Here is a list of values that you can grab from [mimeTypes()](https://api.cfwheels.org/controller.mimeTypes.html) with CFWheels out\
of the box.

* `html`
* `xml`
* `json`
* `csv`
* `pdf`
* `xls`

You can use [addFormat()](https://api.cfwheels.org/controller.addformat.html) to set more types to the appropriate MIME type for reference. For example, we could set a Microsoft Word MIME type in\
`config/settings.cfm` like so:&#x20;

```javascript
addFormat(extension="doc", mimeType="application/msword");
```

### Responding to Different Formats in the Controller

The fastest way to get going with creating your new API and formats is to call\
[provides()](https://api.cfwheels.org/controller.provides.html) from within your controller's `config()` method.

Take a look at this example:

```javascript
component extends="Controller" {

  function config(){
    provides("html,json,xml");
  }
  
  function index(){
    products = model("product").findAll(order="title");
    renderWith(products);
  }
}
```

By calling the [provides()](https://api.cfwheels.org/controller.provides.html) function in `config()`, you are instructing the CFWheels controller to be ready to provide content in a number of formats.\
Possible choices to add to the list are `html` (which runs by default), `xml`,\
`json`, `csv`, `pdf`, and `xls`.

This is coupled with a call to [renderwith()](https://api.cfwheels.org/controller.renderwith.html) in the following actions. In the example above, we are setting a query result of products and passing it\
to [renderwith()](https://api.cfwheels.org/controller.renderwith.html). By passing our data to this function, CFWheels gives us the ability to respond to requests for different formats, and it even gives us the option to just let CFWheels handle the generation of certain formats automatically.

You can also use the [onlyProvides()](https://api.cfwheels.org/controller.onlyProvides.html) call in an individual controller action to define which formats the action will respond with. This can be used to define behavior in individual actions or to override the controller's `config()`.

When CFWheels handles this response, it will set the appropriate MIME type in the\
`Content-Type` HTTP header as well.

### Providing the HTML Format

Responding to requests for the HTML version is the same as you're already used to with [Rendering Content](https://guides.cfwheels.org/cfwheels-guides/handling-requests-with-controllers/rendering-content). [renderwith()](https://api.cfwheels.org/controller.renderwith.html) will accept the same arguments as [renderView()](https://api.cfwheels.org/controller.renderview.html), and you create just a view template in the `views` folder like normal.

### Automatic Generation of XML and JSON Formats

If the requested format is `xml` or `json`, the [renderwith()](https://api.cfwheels.org/controller.renderwith.html) function will automatically transform the data that you provide it. If you're fine with what the function produces, then you're done!

**Best Practices for Providing JSON**

Unfortunately there have been a lot of JSON related issues in CFML over the years. To avoid as many of these problems as possible we thought we'd outline some best practices for you to follow.

First of all, always return data as an array of structs. This is done by using the `returnAs` argument (on [findAll()](https://api.cfwheels.org/model.findall.html) for example), like this:

```javascript
authors = model("author").findAll(returnAs="structs");
```

The reason for doing it this way is that it will preserve the case for the struct / JSON keys.

Secondly, make use of CFWheels ability to return the JSON values in a specified type. This is done in the [renderWith()](https://api.cfwheels.org/controller.renderwith.html)function, like this:

```javascript
renderWith(data=authors, firstName="string", booksForSale="integer");
```

With that in place you can be sure that `firstName` will always be treated as a string (i.e. wrap in double quotes) and `booksForSale` as an integer (i.e. no decimal places) when producing the JSON output. Without this, your CFML engine might guess what the data type is, and it wouldn't always be correct unfortunately.

### Providing Your Own Custom Responses

If you need to provide content for another type than `xml` or `json`, or if you\
need to customize what your CFWheels application generates, you have that option.

In your controller's corresponding folder in `views`, all you need to do is\
implement a view file like so:

| Type | Example                       |
| ---- | ----------------------------- |
| html | views/products/index.cfm      |
| xml  | views/products/index.xml.cfm  |
| json | views/products/index.json.cfm |
| csv  | views/products/index.csv.cfm  |
| pdf  | views/products/index.pdf.cfm  |
| xls  | views/products/index.xls.cfm  |

If you need to implement your own XML- or JSON-based output, the presence of\
your new custom view file will override the automatic generation that CFWheels\
normally performs.

**Example: PDF Generation**

If you need to provide a PDF version of the product catalog, the view file at\
`views/products/index.pdf.cfm` may look something like this:

HTML

```html
<cfdocument format="pdf">
    <h1>Products</h1>
    <table>
        <thead>
            <tr>
                <th>Name</th>
                <th>Description</th>
                <th>Price</th>
            </tr>
        </thead>
        <tbody>
            #includePartial(products)#
        </tbody>
    </table>
</cfdocument>
```
