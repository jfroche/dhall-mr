let Bool/show = https://prelude.dhall-lang.org/Bool/show

let Text/concatMapSep = https://prelude.dhall-lang.org/Text/concatMapSep

let Schemas = ../schemas/package.dhall

let Source/show = ./source.dhall

let Source/showName = ./sourceName.dhall

let Remote/show = ./remote.dhall

in  λ(repo : Schemas.Repository.Type) →
      let submoduleParameter =
            if repo.submodule then "--recurse-submodules " else ""

      let branchParameter =
            merge { Some = λ(t : Text) → "-b ${t} ", None = "" } repo.branch

      let id = λ(t : Text) → t

      let name =
            merge { Some = id, None = Source/showName repo.source } repo.name

      let optionalName = merge { Some = id, None = "" } repo.name

      let parameters = branchParameter ++ submoduleParameter ++ optionalName

      let remotes =
            merge
              { Some =
                  λ(remotes : List Schemas.Remote.Type) →
                        ''
                        git_add_remotes "
                            ''
                    ++  Text/concatMapSep
                          "\n"
                          Schemas.Remote.Type
                          Remote/show
                          remotes
                    ++  ''
                        "
                        ''
              , None = ""
              }
              repo.remotes

      in      ''
              [$HOME/${repo.prefix}/${name}]
              checkout = git clone ${Source/show repo.source} ${parameters}
              ''
          ++  merge
                { Some =
                    λ(t : Text) →
                      ''
                      skip = ${t}
                      ''
                , None = ""
                }
                repo.skip
          ++  merge
                { Some =
                    λ(t : Text) →
                      ''
                      fixups = ${t}
                      remotes =
                        ${remotes}
                      ''
                , None =
                    ''
                    fixups = true
                    remotes =
                      ${remotes}
                    ''
                }
                repo.fixups
          ++  merge
                { Some =
                    λ(t : Natural) →
                      ''
                      order = ${Natural/show t}
                      ''
                , None = ""
                }
                repo.order
          ++  merge
                { Some =
                    λ(t : Bool) →
                      ''
                      chain = ${Bool/show t}
                      ''
                , None = ""
                }
                repo.chain
