let SSH =
      { Type =
          { host : Text, project : Text, repository : Text, port : Natural, user: Text }
      , default = { port = 22, user = "git" }
      }

let GitHubSSH = { Type = { user : Text, repository : Text } }

let GitHubHTTPS = GitHubSSH

let GitLabSSH = GitHubSSH

let GitLabHTTPS = GitHubSSH

let BaseSource = { host : Text, path : Text, repository : Text, port : Natural }

let HTTPS = { Type = BaseSource, default.port = 443 }

let HTTP = { Type = BaseSource, default.port = 80 }

let Source =
      < Ssh : SSH.Type
      | Https : HTTPS.Type
      | GitHubSsh : GitHubSSH.Type
      | GitHubHttps : GitHubHTTPS.Type
      | GitLabSsh : GitLabSSH.Type
      | GitLabHttps : GitLabHTTPS.Type
      | Http : HTTP.Type
      >

in  { Source, HTTPS, SSH, GitHubHTTPS, GitHubSSH, GitLabHTTPS, GitLabSSH, HTTP }
