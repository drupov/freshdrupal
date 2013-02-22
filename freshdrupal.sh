# The site name should be passed in as a first parameter to the shell script.
siteName=$1

# Create a database with the same name as the site name.
mysql -u "root" -e "CREATE DATABASE $siteName;"

# Download drupal and rename the project folder to the site name. ###
# --drupal-project-rename creates errors so for now as a workaround just hardcode the latest drupal version.
drush pm-download drupal --drupal-project-rename=$siteName

# Go to the root of the the site so that the drush commands could apply there.
cd $siteName

# Initialize the site install, with user:pass = admin:admin
drush site-install standard --account-name=admin --account-pass=admin --db-url=mysql://root:@localhost/$siteName --site-name=$siteName -y

# Disable and uninstall some modules, activated by default.
drush pm-disable toolbar -y
drush pm-uninstall toolbar -y

# Download a bunch of useful modules, that would be used on almost any site.
drush pm-download ctools entity devel views admin_menu token libraries module_filter sassy prepro globalredirect rules search_krumo -y

# Enable those modules.
drush pm-enable ctools page_manager entity devel devel_generate views views_ui admin_menu admin_menu_toolbar token libraries module_filter sassy prepro globalredirect rules rules_admin search_krumo -y

# We need phpsass library for prepro and sassy. Only use this if you actually download and enable those two modules.
git clone https://github.com/richthegeek/phpsass.git sites/all/libraries/phpsass

# Download, create and enable a omega subtheme.
# drush dl omega omega_tools -y
# drush en omega_tools -y
# drush omega-subtheme $siteName --enable --set-default

# Initialize git and make an initial commit.
# git init
# git add .
# git commit -m "Initial commit"

# Print some info on configuring css and javascript, especially in omega.
# echo ""
# echo ""
# echo ""
# echo ""
# echo "----- Use Omega 3 with Sassy -----"
# echo "In order to use sass for your omega theme just go to your theme folder at sites/all/themes/$siteName"
# echo "and open the file '$siteName.info'."
# echo "Change '[global.css]' to '[global.scss]' in following lines:"
# echo "css[global.css][name] = 'Your custom global styles'"
# echo "css[global.css][description] = 'This file holds all the globally active custom CSS of your theme.'"
# echo "css[global.css][options][weight] = '10'."
# echo ""
# echo "Clear the cache."
# echo "Then in a browser go to your theme settings at 'admin/appearance/settings/$siteName'"
# echo "and under 'Toggle styles' check the setting 'Your custom global styles (all) - global.scss'."
# echo "As a last step go to your themes css folder at sites/all/themes/$siteName and change all"
# echo "extensions of files with .css to .scss"
# echo ""
# echo ""
# echo "----- Add custom js to Omega 3 -----"
# echo "Add following lines to you .info file"
# echo "libraries[custom_js][name] = Custom javascript"
# echo "libraries[custom_js][description] = Custom javascript files for this theme."
# echo "libraries[custom_js][js][0][file] = scripts.js"
# echo "libraries[custom_js][js][0][options][weight] = 20"
# echo "The 'scripts.js' file should reside in a js folder in your theme root directory."
# echo ""
# echo "Clear the cache."
# echo "Then in a browser go to your theme settings at 'admin/appearance/settings/$siteName'"
# echo "and under 'Toggle libraries' check the setting 'Custom javascript'."
# echo ""
# echo "In Drupal 7 your javascripts should be wrapped like this (e.g. in your 'scripts.js' file):"
# echo "(function($) {"
# echo "  Drupal.behaviors.myCustomBehavior = {"
# echo "    attach: function(context) {"
# echo "      alert('Success');"
# echo "    }"
# echo "  };"
# echo "})(jQuery);"
