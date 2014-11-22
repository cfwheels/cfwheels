# Directory Structure

###### Finding your way around a Wheels application.

After downloading and unzipping Wheels, here's the directory structure that you will see:

+ :open_file_folder: config
+ :open_file_folder: controller
+ :open_file_folder: events
+ :open_file_folder: files
+ :open_file_folder: images
+ :open_file_folder: javascripts
+ :open_file_folder: miscellaneous
+ :open_file_folder: model
+ :open_file_folder: plugins
+ :open_file_folder: stylesheets
+ :open_file_folder: view
+ :open_file_folder: wheels
+ :page_facing_up: .htaccess
+ :page_facing_up: Application.cfc
+ :page_facing_up: index.cfm
+ :page_facing_up: IsapiRewrite4.ini
+ :page_facing_up: rewrite.cfm
+ :page_facing_up: root.cfm
+ :page_facing_up: web.config

## Quick Summary
Your configuration settings will be done in the **_config_** directory.

Your application code will end up in four of the folders, namely **_controllers_**, **_events_**, **_models_**, and **_views_**.

Static media files should be placed in the **_files_**, **_images_**, **_javascripts_** and **_stylesheets_** folders.

Place anything that need to be executed outside of the framework in the **_miscellaneous_** folder. The framework does not get involved when executing `.cfm` files in this folder. (The empty `Application.cfc` takes care of that.) Also, no URL rewriting will be performed in this folder, so it's a good fit for placing CFCs that need to be accessed remotely via `<cfajaxproxy>` and Flash AMF binding, for example.

Place Wheels plugins in the **_plugins_** folder.

And the last directory? That's the framework itself. It exists in the **_wheels_** directory. Please go in there and have a look around. If you find anything you can improve or new features that you want to add, let us know!

## Detailed Overview
Let's go through all of the files and directories now starting with the ones you'll spend most of your time in: the code directories.

#### :open_file_folder: controllers
This is where you create your controllers. You'll see two files in here already: `Controller.cfc` and `Wheels.cfc`. You can place functions inside `Controller.cfc` to have that function shared between all the controllers you create. (This works because all your controllers will extend `Controller`.) `Wheels.cfc` is an internal file used by Wheels.

#### :open_file_folder: models
This is where you create your model files (or classes if you prefer that term). Each model file you create should map to one table in the database.

The setup in this directory is similar to the one for controllers, to share methods you can place them in the existing `Model.cfc` file.

#### :open_file_folder: views
This is where you prepare the views for your users. As you work on your website, you will create one view directory for each controller.

#### :open_file_folder: events
If you want code executed when ColdFusion triggers an event, you can place it here (rather than directly in `Application.cfc`).

#### :open_file_folder: config
Make all your configuration changes here. You can set the environment, routes, and other settings here. You can also override settings by making changes in the individual settings files that you see in the subdirectories.

#### :open_file_folder: files
Any files that you intend to deliver to the user using the `sendFile()` function should be placed here. Even if you don't use that function to deliver files, this folder can still serve as file storage if you like.

#### :open_file_folder: images
This is a good place to put your images. It's not required to have them here, but all Wheels functions that involve images will, by convention, assume they are stored here.

#### :open_file_folder: javascripts
This is a good place to put your JavaScript files.

#### :open_file_folder: stylesheets
This is a good place to put your CSS files.

#### :open_file_folder: miscellaneous
Use this folder for code that you need to run completely outside of the framework. (There is an empty `Application.cfc` file in here, which will prevent Wheels from taking part in the execution.)

This is most useful if you're using Flash to connect directly to a CFC via AMF binding or if you're using `<cfajaxproxy>` in your views to bind directly to a CFC as well.

#### :open_file_folder: plugins
Place any plugins you have downloaded and want installed here.

#### :open_file_folder: wheels
This is the framework itself. When a new version of Wheels is released it is often enough to just drop it in here (unless there has been changes to the general folder structure).

#### :page_facing_up: .htaccess
This file is used by Apache, and you specifically need it for URL rewriting to work properly. If you're not using Apache, then you can safely delete it.

#### :page_facing_up: IsapiRewrite4.ini
If you use IIS 6 and want to use [URL Rewriting][1], you'll need this file. Otherwise, you can safely delete it.

#### :page_facing_up: web.config
Same as `IsapiRewrite4.ini` but used for version 7 of IIS instead.

#### :page_facing_up: Application.cfc, index.cfm, root.cfm, and rewrite.cfm
These are all needed for the framework to run. No changes should be done to these files.

You can add more directories if you want to, of course. Just remember to include a blank `Application.cfc` in those directories. Otherwise, Wheels will try to get itself involved with those requests as well.

[1]: ../03-Handling-Requests-with-Controllers/11-URL-Rewriting.md