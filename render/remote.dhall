let Remote = ../schemas/Remote.dhall

let renderSource = ./source.dhall

in  λ(remote : Remote.Type) → remote.name ++ " " ++ renderSource remote.source
