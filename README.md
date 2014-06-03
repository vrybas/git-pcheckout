# git-pcheckout

[![Build Status](https://api.travis-ci.org/vrybas/git-pcheckout.svg)][travis]
[![Gem Version](http://img.shields.io/gem/v/git-pcheckout.svg)][gem]
[![Code Climate](http://img.shields.io/codeclimate/github/vrybas/git-pcheckout.svg)][codeclimate]
[![Coverage](https://coveralls.io/repos/vrybas/git-pcheckout/badge.png?branch=master)][coverage]

Git command to evenly checkout local/remote branches and source/fork
pull requests by URL (with Hub)

## Installation

[Hub][1] is required for checking out pull requests.

    $ brew install hub
    $ gem install git-pcheckout

## Usage

    $ git pcheckout 123-myfeature
    $ git pcheckout https://github.com/user/repo/pull/123

## What it does

1. If specified _branch-name_ exists locally:

    $ git checkout branch-name
    $ git pull origin branch-name

2. If specified _branch-name_ not exist locally:

    $ git fetch
    $ git checkout --track origin/branch-name

3. If pull request URL specified(from fork):
  - pulls fork branch with Hub

4. If pull request URL specified(from source repo):
  - treats it as if just a _branch_name_ was specified (goto 1)

## Contributing

1. Fork it ( http://github.com/vrybas/git-pcheckout/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[1]: http://hub.github.com/
[travis]: https://travis-ci.org/vrybas/git-pcheckout
[gem]: http://rubygems.org/gems/git-pcheckout
[codeclimate]: https://codeclimate.com/github/vrybas/git-pcheckout
[coverage]: https://coveralls.io/r/vrybas/git-pcheckout?branch=master
