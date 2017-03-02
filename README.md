#Scripts and hacks, not yet emancipated

Copyright Felix Wolfsteller 2017
Licensed under the GPL v3 or any later version.

## virt-helpers/

### ubuntu-16.04-builder.sh

provision an Ubuntu 16.04 machine using virt-builder.

Example: `ubuntu-16.04-builder.sh app-test`
Results in the file `app-test.qcow2` which is a bare metal Ubuntu 16.04 installation.

### redmine-builder.sh

provision an Ubuntu 16.04 machine using virt-builder that comes slightly prepared for a redmine installation.

Example: `redmine-builder.sh projects-test`
Results in the file `projects-test.qcow2` which is a Ubuntu 16.04 installation with some additional packages installed.

### fake-dokku-app.sh

Do what you shouldnt do (http://stackoverflow.com/questions/42529271/how-to-proxy-subdomains-to-other-servers-with-dokku), use dokku to hook in some legacy systems in your dokku awesomness.
