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
drush pm-download ctools entity devel views admin_menu token libraries module_filter sassy prepro globalredirect rules search_krumo features strongarm diff -y

# Enable those modules.
drush pm-enable ctools page_manager entity devel devel_generate views views_ui admin_menu admin_menu_toolbar token libraries module_filter sassy prepro globalredirect rules rules_admin search_krumo features strongarm diff -y

# We need phpsass library for prepro and sassy. Only use this if you actually download and enable those two modules.
git clone https://github.com/richthegeek/phpsass.git sites/all/libraries/phpsass

# Download, create and enable an omega 3 subtheme.
# drush dl omega omega_tools -y
# drush en omega_tools -y
# drush omega-subtheme $siteName --enable --set-default

# Initialize git and make an initial commit.
# git init
# git add .
# git commit -m "Initial commit"
