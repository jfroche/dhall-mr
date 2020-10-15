let Source = ./Source.dhall

let Remote = ./Remote.dhall

let Repository =
      { Type =
          { prefix : Text
          , name : Optional Text
          , source : Source.Source
          , branch : Optional Text
          , submodule : Bool
          , skip : Optional Text
          , fixups : Optional Text
          , order : Optional Natural
          , chain : Optional Bool
          , remotes : Optional (List Remote.Type)
          }
      , default =
        { submodule = False
        , name = None Text
        , skip = None Text
        , fixups = None Text
        , chain = None Bool
        , order = None Natural
        , branch = None Text
        , remotes = None (List Remote.Type)
        }
      }

in  Repository
