# git-pcheckout

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

If specified _branch-name_ exists locally:

    $ git checkout branch-name
    $ git pull origin branch-name

If specified _branch-name_ not exist locally:

    $ git fetch
    $ git checkout --track origin/branch-name

If pull request URL specified(from fork):
  - pulls fork branch with Hub

If pull request URL specified(from source repo):
  - treats it as if just a _branch_name_ was specified (goto 1)

## Contributing

1. Fork it ( http://github.com/vrybas/git-pcheckout/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[1]: http://hub.github.com/
