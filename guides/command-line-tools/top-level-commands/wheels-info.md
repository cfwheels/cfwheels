## `wheels info`

This command is the most basic of the commands and other than printing some pretty ASCII art it also displays the Current Working Directory, the CommandBox Module Root which can be handy when trying to diagnoise version discrepencies, and lastly the CFWheels version currently installed. The version is determined from a variaty of sources. First and foremost, if there is a `box.json` file in the `wheels/` directory the version is extracted from that `box.json`. Alternatively, if there is no `box.json` file in the `wheels/` directory, we look in `wheels/events/onapplicationstart.cfm` and extract a version number from that file. That is the version number that is displayed on the default congradulations screen by the way. If both of these fail to get us a version number we can use, we ask you to let us know what version of wheels you are using and give you the obtion of generating a `box.json` file. This is handy for bringing old legacy installations under CLI control.

```
 ,-----.,------.,--.   ,--.,--.                   ,--.            ,-----.,--.   ,--.
'  .--./|  .---'|  |   |  ||  ,---.  ,---.  ,---. |  | ,---.     '  .--./|  |   |  |
|  |    |  `--, |  |.'.|  ||  .-.  || .-. :| .-. :|  |(  .-'     |  |    |  |   |  |
'  '--'\|  |`   |   ,'.   ||  | |  |\   --.\   --.|  |.-'  `)    '  '--'\|  '--.|  |
 `-----'`--'    '--'   '--'`--' `--' `----' `----'`--'`----'      `-----'`-----'`--'
=================================== CFWheels CLI ===================================
Current Working Directory: /Users/peter/projects/ws/MyCFWheelsApp/
CommandBox Module Root: /Users/peter/projects/cfwheels-cli/
Current CFWheels Version in this directory: 2.3.0
====================================================================================
```
