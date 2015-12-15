# The site name should be passed in as a first parameter to the shell script.
siteName=$1

# Drop the database with the specified name if it exists
mysql -u "root" -e "DROP DATABASE $siteName;"

# Create a database with the same name as the site name.
mysql -u "root" -e "CREATE DATABASE $siteName;"

# Download drupal and rename the project folder to the site name. ###
# --drupal-project-rename creates errors so for now as a workaround just hardcode the latest drupal version.
drush pm-download drupal-8 --drupal-project-rename=$siteName

# Go to the root of the the site so that the drush commands could apply there.
cd $siteName

# Create modules directory structure
mkdir modules/contrib
mkdir modules/custom

# Initialize the site install, with user:pass = admin:admin
drush site-install standard --account-name=admin --account-pass=admin --db-url=mysql://root:@localhost/$siteName --site-name=$siteName -y

# Download a bunch of useful modules, that would be used on almost any site.
drush pm-download admin_toolbar devel page_manager -y

# Enable those modules.
drush pm-enable admin_toolbar_tools devel devel_generate kint page_manager -y
