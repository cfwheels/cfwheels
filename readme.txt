"cfwheels" folder:
place this anywhere on your computerand create a mapping for it in ColdDFusion Administrator

"template" folder:
This is the folder for your website, place it in wwwroot, point home dir to public, create 3 virtual directories
for more info apache/iss go to chwheels








When creating a new CFWheels site, all you need to do is copy the /template/script directory and its contents 
to the directory that's going to be home to your new web application. You'll need to set up a new site in 
your webserver so that you can get to this script directory from a browser and create the rest of the 
skeleton for your app.

An example Apache configuration file entry is below. This file is typically found in 
C:\Program Files\Apache Group\Apache2\conf\httpd.conf (on Windows machines). This host entry assumes that this
will be the only site served from this machine. If that isn't so then you'll need to turn on name-based virtual
hosting. See http://httpd.apache.org/docs/2.0/vhosts/name-based.html for a complete discussion of this topic.  The below
snippet assumes that the name of the directory that will be containing your app is called "helloworld"  (Note that
the DocumentRoot is pointing to a directory [/public] that doesn't exist yet. It will after you run the generator.)
The only directory you need access to in order to begin is /script)

So, copy the entire /script directory into "helloworld." Your directory structure should look like:

/helloworld
      |--/script
               |--index.cfm
               |--script.cfc

After copying the code below and saving httpd.conf be sure to restart Apache server. Then just browse to 
http://localhost/helloworld/script to begin building your application.


# Sample httpd.conf entry for a new application

<VirtualHost *:80>
  ServerName helloworld
  DocumentRoot "c:/wwwroot/helloworld/public"
  <Directory "c:/wwwroot/helloworld/public">
    AllowOverride All
  </Directory>

# Allows us to access the ColdFusion administrator (you should comment these out when you go live with your app)
  Alias /cfide "C:/wwwroot/CFIDE"
  Alias /CFIDE "C:/wwwroot/CFIDE"
  Alias /script "c:/wwwroot/helloworld/script"

# Allows your application to access the /config directory
  Alias /config "c:/wwwroot/helloworld/config"
  <Directory "c:/wwwroot/helloworld/config">
    Order Deny,Allow
    Deny from all
    Allow from 127.0.0.1
  </Directory>

# Allows your application to access the /app directory
  Alias /app "c:/wwwroot/helloworld/app"
  <Directory "c:/wwwroot/helloworld/app">
    Order Deny,Allow
    Deny from all
    Allow from 127.0.0.1
  </Directory>
</VirtualHost>