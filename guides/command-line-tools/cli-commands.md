# CLI Commands

The command line tools extends the functionality of CommandBox with some commands specifically designed for CFWheels
development. These tools allow you to adopt a more modern workflow and allow you to create and manipulate many CFWheels
objects from the command line. By making these tools available in the command line, not only will you be able to speed up
your development but you can also utilize these commands in Continous Integration (CI) and Continous Deployment (CD) work flows.

The commands are all listed below. We are working on documenting each command.

## `wheels info`

This command is the most basic of the commands and other than printing some pretty ASCII art it also displays the Current Working Directory, the CommandBox Module Root which can be handy when trying to diagnoise version discrepencies, and lastly the CFWheels version currently installed. The version is determined from a variaty of sources. First and foremost, if there is a `box.json` file in the `wheels/` directory the version is extracted from that `box.json`. Alternatively, if there is no `box.json` file in the `wheels/` directory, we look in `wheels/events/onapplicationstart.cfm` and extract a version number from that file. That is the version number that is displayed on the default congradulations screen by the way. If both of these fail to get us a version number we can use, we ask you to let us know what version of wheels you are using and give you the obtion of generating a `box.json` file. This is handy for bringing old legacy installations under CLI control.

## `wheels init`
## `wheels reload`
## `wheels test`
## `wheels scaffold`
## `wheels destroy`
## `wheels travis`
