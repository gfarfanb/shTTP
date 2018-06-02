
# How to contribute

I'm really glad you're reading this, thanks.

The following is a set of guidelines for contributing to shTTP. 
Use your best judgment, and feel free to propose changes to this document or 
any other community document in a pull request.

## Code of Conduct

This project and everyone participating in it is governed by the shTTP
[Code of Conduct](./CODE_OF_CONDUCT.md). Please report any unacceptable behavior 
to @gfarfanb.

## Getting started

To start using this repository right away, 
[fork this repository on GitHub](https://github.com/gfarfanb/shTTP/fork).

### How to install it

#### Windows approach

* Check jq installation in command line by `jq --version`. If you do not have jq,
download it from [jq](https://stedolan.github.io/jq/download/#windows). Then
setup `Path` environment variable in:
```
Windows > This PC > Properties > Advanced system settings > Environment Variables... > System variables
```
```
# Whatever location that makes sense
JQ_HOME=C:\dist\jq-1.5
Path=%Pah%; %JQ_HOME%
```
> In order to use `jq` as command, is preferably to rename the executable `jq-[win64 | win32].exe`
> to `jq.exe`

* Check installation `jq --version`, output must be similar to:
```bash
jq-1.5
```

#### Ubuntu approach

* Check jq installation in command line by `jq --version`. If you do not have jq,
install it by:
```bash
sudo apt-get update
sudo apt-get install jq
```

* Check installation `jq --version`, output must be similar to:
```bash
jq-1.5-1-a5b5cbe
```

* Preferably install [ShellCheck](https://github.com/koalaman/shellcheck)
```
sudo apt-get install shellcheck
```
Usage:
```
shellcheck http_api
```

* Service mock nginx:
```
sudo apt-get install nginx
```


## Script plugin

Export execution permissions to script file:
```bash
git update-index --add --chmod=+x ./script_file.sh
```

From source apply execution permissions:
```
sudo chmod +x ./script_file.sh
```

Avoid errors because Windows-style '\r' line ending by:
```
sed -i 's/\r$//' ./script_file.sh
```

Internal functions convention:
```
_name_of_internal_function() {
    :
}
```

Public function convention:
```
nameOfPublicFunction() {
    :
}
```

Conventions:
1. Comments
    1. Spaces
    1. Identifiers: -param, -return, -test, -beforeTests, -afterTests, -author
    1. Identation


## How can I contribute in a different way?

### Reporting bugs

- Fill the [required template](./ISSUE_TEMPLATE.md).
- Make sure you are correctly following the checklist section.
- The description must be concise.
- It is important the indicate environment you are testing.
- Do not make support questions or comments, there are specific
channels for [this chat room](https://gitter.im/shTTP/api-dev)
or post discussion (at the end of posts).
- Include screenshots and animated GIFs in your pull request whenever possible.

### Suggesting enhancements

It is always welcome a new change idea, refactoring, design, features,
new pages (not only posts), just propose it via issue requests or if
consider better via pull requests. 

## Pull Requests

- Fill the [required template](./PULL_REQUEST_TEMPLATE.md).
- Include screenshots and animated GIFs in your pull request whenever possible.
- Describe every change you made in a new bullet.
- End all files with a newline.
- Do not forget to list the contributors.
- Every pull request must have one review, must be up to date and must have
verified signatures, so wait and process the feeback.

Once your pull request is ready to be merged, the repository maintainers 
will integrate it. There is no additional action required from pull request 
contributors at this point.

## Copyright

shTTP core is licensed under [MIT License][mit_license], with a few exceptions
in bundled classes. We consider all contributions as [MIT][mit_license] unless
it's explicitly stated otherwise. [MIT][mit_license]-incompatible code contributions
will be rejected. Contributions under [MIT][mit_license]-compatible licenses
may be also rejected if they are not ultimately necessary.

[mit_license]: https://opensource.org/licenses/MIT
