let Source = ./Source.dhall

in  { Type = { name : Text, source : Source.Source }
    , default.name = "upstream"
    }
