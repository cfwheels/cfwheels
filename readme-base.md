# cfwheels-template-base

This is a blank application written in CFWheels. 

## As an Application

As an application, this is a starting point for a modern CFWheels applicaiton with Bootstrap integration.

## As a Forgbox Package

As a Forgebox package there is some interesting things going on here. Although this package doesn't contains much custom code, it does have a dependies which pulls in the core folder the framework needs to function. This folder is pulled in via this dependency:

```
"Dependencies":{
  "cfwheels-core":"^2.2.0"
}
```

The core files are put into the `wheels/` folder acording to these settings.

```
"installPaths":{
  "cfwheels-core":"wheels/"
}
```

## To install

To install this package you'll need to have a running CommandBox installation. Then you can install this package with the following:

```
box
mkdir myapp --cd
install cfwheels-template-base
```

This could be shortened to a single command run in an empty directory:

```
box install cfwheels-template-base
```
