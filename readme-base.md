# cfwheels-template-base

This is a blank application written in CFWheels. 

## As an Application

As an application, this is a starting point for a modern CFWheels application with Bootstrap integration.

## As a ForgeBox Package

As a ForgeBox package there is some interesting things going on here. Although this package doesn't contain much custom code, it does have a dependency which pulls in the core folder the framework needs to function. This folder is pulled in via this dependency:

```
"Dependencies":{
  "cfwheels":"^2.0.0"
}
```

The core files are put into the `wheels/` folder according to these settings.

```
"installPaths":{
  "cfwheels":"wheels/"
}
```

## To Install

To install this package you'll need to have a running CommandBox installation. Then you can install this package with the following:

```
box
mkdir myapp --cd
install cfwheels-base-template
```

This could be shortened to a single command run in an empty directory:

```
box install cfwheels-base-template
```
