
:warning: This project is no longer actively maintained.

# shTTP

[![Build Status](https://travis-ci.com/gfarfanb/shTTP.svg?branch=master)](https://travis-ci.com/gfarfanb/shTTP)
[![Join the chat at https://gitter.im/shTTP/dev](https://badges.gitter.im/shTTP/dev.svg)](https://gitter.im/shTTP/dev?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

> **shTTP** pronounced `shell-ttp`

Simple HTTP API development environment by command line.


## What do you need for execute it

- [jq](https://stedolan.github.io/jq/) \~\> 1.5
- [curl](https://curl.haxx.se/) \~\> 7.47.0
- [GNU bash](https://www.gnu.org/software/bash/) \~\> 4.3.48(1)-release or [GCC for Windows](http://mingw-w64.org/doku.php) (the installed with Git Windows Installer is good enough)


## How to use it

Consider these CRUD operations:
- Get comments from a Gist
```
GET https://api.github.com/gists/{gist_id}/comments
```
- Get a comment by ID from a Gist
```
GET https://api.github.com/gists/{gist_id}/comments/{comment_id}
```
- Add new comment to a Gist
```
POST https://api.github.com/gists/{gist_id}/comments

{
    "body": "body_content"
}
```
- Update a comment for a Gist
```
PATCH https://api.github.com/gists/{gist_id}/comments/{comment_id}

{
    "body": "updated_body_content"
}
```
- Delete a comment for a Gist
```
DELETE https://api.github.com/gists/{gist_id}/comments/{comment_id}
```


### All operation in a single file

Define a bash script file like:

```
#! /usr/bin/env bash
# filename: gist_comments

# Correct! if you put the HTTP verb as the prefix of the function
# that will be the method of your request
get_all() {
    url 'https://api.github.com/gists/fc33b868bb597c71c272d9b7f2815df7/comments'
}

get_by_id() {
    url 'https://api.github.com/gists/fc33b868bb597c71c272d9b7f2815df7/comments/1'
}

post_comment() {
    url 'https://api.github.com/gists/fc33b868bb597c71c272d9b7f2815df7/comments'
    body '{ "body": "body_content" }'
}

patch_comment() {
    url 'https://api.github.com/gists/fc33b868bb597c71c272d9b7f2815df7/comments/1'
    body '{ "body": "updated_body_content" }'
}

delete_by_id() {
	url 'https://api.github.com/gists/fc33b868bb597c71c272d9b7f2815df7/comments/1'	
} 

# Import the 'shTTP/shttp' file in your script
# Yes, it must be at the end of the file
. ../shttp
```
> These methods are allowed to put them as prefix of the name of the functions (ignored case): *GET*, *POST*, *PUT*, *PATCH*, *DELETE*, *HEAD*, *OPTIONS*

Just call the services by the name of the functions defined in the *gist_comments* file:
```
./gist_comments get_all
./gist_comments get_by_id
./gist_comments post_comment
./gist_comments patch_comment
./gist_comments delete_by_id
```

Ok, probably you prefer names without the HTTP verb:
```
#! /usr/bin/env bash
# filename: gist_comments

all_comments() {
    method GET
    url 'https://api.github.com/gists/fc33b868bb597c71c272d9b7f2815df7/comments'
}

. ../shttp
```
```
./gist_comments all_comments
```

More specific with the URL parts, use some [builder functions](https://github.com/gfarfanb/shTTP/wiki/API-Functions#builder-functions):
```
#! /usr/bin/env bash
# filename: gist_comments

comment_by_id() {
    method GET
    protocol 'https'
    domain 'api.github.com'
    basePath '/gists/fc33b868bb597c71c272d9b7f2815df7/comments'
    endpoint '/1'
}

. ../shttp
```
```
./gist_comments comment_by_id
```

You can check a more complex example in [this file](https://github.com/gfarfanb/shTTP/blob/master/sample/gist_comments).
```
# Help content (you can see the examples of add-ons)
./gist_comments --help

# Set your credentials
./gist_comments --cred sample --part -u "YOUR GITHUB USERNAME" --part -p "YOUR GITHUB PERSONAL ACCESS TOKEN"

# CRUD requests
./gist_comments get_all
./gist_comments get_comment
./gist_comments post_comment
./gist_comments patch_comment
./gist_comments delete_comment --auth-basic sample

# All the CRUD flow
./gist_comments flow_comment 


# You can define a mock request to complete your flow paths, just testing porpuses of course
./gist_comments only_def
```

### Workspace, output and history

You can set configuration files which can be used to parameterize your requests. Default `ws/config.json` files is generated if it does not exist yet.
```
ws/config[.<env>].json
```

It is possible to have different environments by using:
```
# A file ws/config.dev.json must be exists
./gist_comments --env dev

# Copy you config file to a different environment
./gist_comments --copy default dev
```

Manually add new field-value entries for your configuration or just use the command:
```
./gist_comments --add appName "shTTP-samples"
```
```
# Inside config.json
{
  "apiVersion": "v3",
  "appName": "shTTP-samples",
  "gistId": "fc33b868bb597c71c272d9b7f2815df7",
  "fingerprint": "Authorization Fingerprint",
  "authId": "Authorization ID",
  "slackSrv": "Slack Webhook URL"
}
```

If you prefer to put some values as *secret/hidden/secure* one just add them in this way:
```
./gist_comments --add authId "YOUR AUTH ID WHICH WILL BE ENCODED" -h
```

The *secret/hidden/secure* values will be encoded Base-64 in the file `ws/.vlt` so you just skip it in `.gitignore`. Remember people who pull changes have to add these hidden values by themself, using the same command.


#### Output files

Every request execution will generate output files in the directory:
`output/<api_file_name>/<request_function_name>/<yyyy-mm-dd>/<unix_epoch_time_number>.<date_nanoseconds_number>`
```
# Content body of the request
.body
# Response content
.output
# curl output
.trace
```


#### History files

Every request execution will create/uptede the respective history file:
`hist/<api_file_name>/<request_function_name>.json`

The content of this file looks like:
```
{
  "api": "gist_comments",
  "command": "delete_comment",
  "type": "REQUEST",
  "data": [
    {
      "date": "2020-05-26 11:39:43.930019100 -0500",
      "assertions": 1,
      "failures": 0,
      "timeTotal": 0.362785,
      "status": "SUCCESS",
      "failed": []
    },
    ...
  ]
}
```


### Add-ons

#### After request is executed:

- Add a file in a **ext** directory (at the level of your scripts) with the suffix: `_ext`
- Implement a function named as `proceed_notif`
- Execute the request that requires this add-on

Look at [this extension](https://github.com/gfarfanb/shTTP/blob/master/sample/ext/slack_notif_ext) for Slack notifications
```
./gist_comments --slack
```

#### More authentication ways

- Add a file in a **ext** directory (at the level of your scripts) with the suffix: `_ext`
- Implement a function named as `proceed_auth`
- Execute the request that requires this add-on

Look at [this extension](https://github.com/gfarfanb/shTTP/blob/master/sample/ext/manual_auth_ext) for curl manual authentication
```
./gist_comments --auth-manual
```

#### More options

- Add a file in a **ext** directory (at the level of your scripts) with the suffix: `_ext`
- Implement a code like:
```
_new_function_for_your_option() {
    ;
}

_help_content \
    "   --new-option Any description..." \
    "          more lines..."

_register_opt --new-option  _new_function_for_your_option
if expr "$*" : ".*--new-option " > /dev/null; then
    _look_for_params --new-option "$@"
    _exit
fi
```
- Execute the request that requires this add-on

Look at [this extension](https://github.com/gfarfanb/shTTP/blob/master/sample/ext/image_chart_ext) for generate URLs with [Image Charts](https://www.image-charts.com/)
```
./gist_comments --chart gist_comments get_comment 
```


## Documentation

Please see [wiki](https://github.com/gfarfanb/shTTP/wiki) for detailed documentation.


## Contribution

Follow the [Contribution guidelines](.github/CONTRIBUTING.md) for this project.


## License

Copyright © 2018-2019, [Giovanni Farfán B](https://github.com/gfarfanb). Released under the 
[MIT License](https://opensource.org/licenses/MIT).
