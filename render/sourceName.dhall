let Source = ../schemas/Source.dhall

in  λ(source : Source.Source) →
      merge
        { Http = λ(source : Source.HTTP.Type) → source.repository
        , Https = λ(source : Source.HTTPS.Type) → source.repository
        , Ssh = λ(source : Source.SSH.Type) → source.repository
        , GitHubSsh = λ(source : Source.GitHubSSH.Type) → source.repository
        , GitHubHttps = λ(source : Source.GitHubHTTPS.Type) → source.repository
        , GitLabSsh = λ(source : Source.GitLabSSH.Type) → source.repository
        , GitLabHttps = λ(source : Source.GitLabHTTPS.Type) → source.repository
        }
        source
