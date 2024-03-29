### Gerrit-Api
This project wraps the gerrit's api using a bash script.

### Usage
Export the following environment variables
```
export GERRIT_USERNAME="johnedoe"
export GERRIT_HTTP_PASSWORD="password"
export GERRIT_SERVER_HOSTNAME="foo.org.com"
```

Import the methods
```
source ./script.sh
```

### Methods supported as of now

#### set review
```
name: set_review_for_latest_revision
param: change_id
param: label
```
#### Get current revision
```
name: __get_revision_id
param: change_id
```

#### Submit the change
```
name: submit_change
param: change_id
```

### Example method invocation

#### set review
```
set_review_for_latest_revision 590443 2
```

#### Get the latest revision
```
rev_id=$(__get_revision_id 590443)
```

#### submit the change
```
submit_change 590443
```
