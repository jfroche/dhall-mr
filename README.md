# Configure mr using dhall

> John: Someone in the team could try this: `cd ~/projects/company/website && git checkout feat/A && git pull && make run`
>
> Adele: sure
>
> Adele: works for me !

As developers we clone, update git repositories almost every day.
We want to share with colleagues repositories to clone and their locations.
[Mr][mr] is a command line tool that provides an easy way to do that.

Mr configuration uses the ini format which quickly becomes verbose and repetitive.
We want a language that enables us to generate that configuration.
[Dhall configuration language][dhall-lang] is a good candidate.

## Example

``` dhall
let List/map = https://prelude.dhall-lang.org/List/map

let Text/concat = https://prelude.dhall-lang.org/Text/concat

let mr = https://raw.githubusercontent.com/jfroche/dhall-mr/main/package.dhall

let dhallRepositories =
      [ mr.Repository::{
        , prefix = "projects/github/dhall-lang"
        , name = Some "dhall-lang"
        , source =
            mr.Source.GitHubSsh
              { repository = "dhall-lang", user = "dhall-lang" }
        }
      , mr.Repository::{
        , prefix = "projects/github/dhall-lang"
        , branch = Some "some-branch"
        , source =
            mr.Source.GitHubSsh { user = "jfroche", repository = "dhall-haskell" }
        , remotes = Some
            (   [ mr.Remote::{
                  , source =
                      mr.Source.GitHubHttps
                        { user = "dhall-lang", repository = "dhall-haskell" }
                  }
                ]
              : List mr.Remote.Type
            )
        }
      ]

in  Text/concat
      (List/map mr.Repository.Type Text mr.Repository/show dhallRepositories)
```

Dhall would generate the following mr configuration:

```
[$HOME/projects/github/dhall-lang/dhall-lang]
checkout = git clone git@github.com:dhall-lang/dhall-lang.git dhall-lang
fixups = true
remotes =

[$HOME/projects/github/dhall-lang/dhall-haskell]
checkout = git clone git@github.com:jfroche/dhall-haskell.git -b some-branch
fixups = true
remotes =
  git_add_remotes "
    upstream https://github.com/dhall-lang/dhall-haskell.git"
```

## Mrconfig

Mr is running dhall to generate its configuration. Here is the `.mrconfig`
file:

``` ini
[DEFAULT]
include = fd '.dhall' -d 1 -x dhall text --file
lib =
  git_add_remotes () {
    cd "$MR_REPO" || return
    echo "$*" | while read -r remote url; do
        existing_url=$( git config "remote.$remote.url" ) || true
        if [ -n "$existing_url" ]; then
            git remote set-url "$remote" "$url"
            git fetch "$remote"
        else
            git remote add -f "$remote" "$url"
        fi
    done
  }
```

[dhall-lang]: https://github.com/dhall-lang/dhall-lang/
[mr]: http://myrepos.branchable.com/
