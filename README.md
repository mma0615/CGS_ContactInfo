# Installation notes
    After installing package.

    1. From Setup, enter Schema Settings in the Quick Find box, and make sure that the Restrict access to custom metadata types org permission is enabled.
    2. Enter User Management Settings in the Quick Find box, and enable Enhanced Profile User Interface.
    3. Enter Profiles or Permission Sets in the Quick Find box.
    4. Click the name of the profile or permission set that you want to edit.
    5. Click Custom Metadata Types.
        . Click Edit.
        . Select the custom metadata types that you want to grant access to, and add them to the Enabled Custom Metadata Types list.
        . Click Save.
    6. Select APEX class access
        . Click Edit
        . Select APEX Classes to add to profile
        . Click Save

    7. ****** For users that have edit access to meta data
        . Click on users
        . Permission set assigment
        . Add 'CGS Contact Information' to the Permission

# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)


# creating unlock package
    1 Create package: 
        sfdx force:package:create -n CGSContactInfo -d "CGS Contact Information" -r force-app -t Unlocked -v DevHub
    
    2. sfdx force:package:list
    
    3. To update package version open sfdx-project.json and update version name and version number
        "versionName": "ver 0.1",
        "versionNumber": "0.1.0.NEXT"

    4. To create package version: 

        sfdx force:package:version:create -p CGSContactInfo -d force-app -k CGS1234 --wait 10 -v DevHub

    5.  Successfully created the package version [08c3i000000L0S1AAK]. Subscriber Package Version Id: 04t3i000002alDeAAI
Package Installation URL: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t3i000002alDeAAI
As an alternative, you can use the "sfdx force:package:install" command.