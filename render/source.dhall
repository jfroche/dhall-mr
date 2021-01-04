let Source = ../schemas/Source.dhall

let equal = https://prelude.dhall-lang.org/Natural/equal

let show = https://prelude.dhall-lang.org/Natural/show

let httpsSource =
      λ(source : Source.HTTPS.Type) →
        if    equal source.port 443
        then  "https://${source.host}/${source.path}/${source.repository}.git"
        else  "https://${source.host}:${show
                                          source.port}/${source.path}/${source.repository}.git"

let sshSource =
      λ(source : Source.SSH.Type) →
        if    equal source.port 22
        then  "git@${source.host}:${source.project}/${source.repository}.git"
        else  "ssh://git@${source.host}:${show
                                            source.port}/${source.project}/${source.repository}.git"

in  λ(source : Source.Source) →
      merge
        { Http =
            λ(source : Source.HTTP.Type) →
              if    equal source.port 80
              then  "http://${source.host}/${source.path}/${source.repository}.git"
              else  "http://${source.host}:${show
                                               source.port}/${source.path}/${source.repository}.git"
        , Https = httpsSource
        , Ssh = sshSource
        , GitHubSsh =
            λ(source : Source.GitHubSSH.Type) →
              "git@github.com:${source.user}/${source.repository}.git"
        , GitHubHttps =
            λ(source : Source.GitHubHTTPS.Type) →
              "https://github.com/${source.user}/${source.repository}.git"
        , GitLabSsh =
            λ(source : Source.GitLabSSH.Type) →
              "git@gitlab.com:${source.user}/${source.repository}.git"
        , GitLabHttps =
            λ(source : Source.GitLabHTTPS.Type) →
              "https://gitlab.com/${source.user}/${source.repository}.git"
        }
        source
