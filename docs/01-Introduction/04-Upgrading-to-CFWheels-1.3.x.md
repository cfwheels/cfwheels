# Upgrading to CFWheels 1.3.x

Instructions for upgrading CFWheels application to version 1.3.x.

If you are upgrading from CFWheels 1.1.0 or newer, follow these steps:

1.  Replace the `wheels` folder with the new one from the 1.3 download.
2.  Replace the root `root.cfm` file with the new one from the 1.3 download.
3.  Remove the `<cfheader>` calls from the following files:
    -  `events/onerror.cfm`
    -  `events/onmaintenance.cfm`
    -  `events/onmissingtemplate.cfm`

In addition, if you're upgrading from an earlier version of CFWheels, we recommend reviewing the instructions from earlier reference guides:

-   Before version 1.0: [Upgrading to CFWheels 1.0][1]
-   Before version 1.1: [Upgrading to CFWheels 1.1][2]

Note: To accompany the newest 1.1.x releases, we've highlighted the changes that are affected by each release in this cycle.

[1]: TBD
[2]: TBD
