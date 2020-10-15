let List/concat = https://prelude.dhall-lang.org/List/concat

let List/map = https://prelude.dhall-lang.org/List/map

let Text/concat = https://prelude.dhall-lang.org/Text/concat

let mr = ../package.dhall

let dhallRepositories =
      [ mr.Repository::{
        , prefix = "projects/github/dhall-lang"
        , name = Some "dhall-lang"
        , source =
            mr.Source.GitHubSsh
              { repository = "dhall-lang", user = "dhall-lang" }
        }
      , mr.Repository::{
        , prefix = "projects/github/dhall-haskell"
        , branch = Some "some-branch"
        , source =
            mr.Source.GitHubSsh { user = "jfroche", repository = "dhall-lang" }
        , remotes = Some
            (   [ mr.Remote::{
                  , source =
                      mr.Source.GitHubHttps
                        { user = "dhall-haskell", repository = "dhall-lang" }
                  }
                ]
              : List mr.Remote.Type
            )
        }
      ]

let companyRepositories =
      [ mr.Repository::{
        , prefix = "projects/company/website"
        , name = Some "website"
        , source =
            mr.Source.Https
              mr.HTTPS::{
              , host = "gitea.mycompany.be"
              , repository = "website"
              , path = "internal"
              }
        }
      ]

in  Text/concat
      ( List/map
          mr.Repository.Type
          Text
          mr.Repository/show
          ( List/concat
              mr.Repository.Type
              [ dhallRepositories, companyRepositories ]
          )
      )
