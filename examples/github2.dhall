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
            mr.Source.GitHubSsh
              { user = "jfroche", repository = "dhall-haskell" }
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
