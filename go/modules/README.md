# Modules

## What it is

Directory contains go packages



Standard go packages are installed in GOROOT (installation path) $GOROOT/src

go get github.com/thatisuday/stringmanip   clone the most recent commit

## Installation

1. `go mod init import-path`   -> create go.mod file for you
2. in the module, each package will have its own `package package-name`
3. 


## Get Packages with version

`go get <package>@<version>`

## Store

Go modules cache is stored in $GOPATH/pkg/mod

if newer version comes, we need to run

`go get -u` to update the dependencies with latest minor/patch version

major version is treated as different packages.

`go get -u=patch` to update only patch version and ignore minor

get specific version via `go get github.com/thatisuday/nummanip@v1.1.2`

## Build Module

`go build` or `go build .` will create binary in the directory

or `go install` or `go install .` to create binary in `$GOPATH/bin`

