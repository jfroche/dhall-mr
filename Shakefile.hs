import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util
import Development.Shake.Dhall

import System.Directory (getHomeDirectory)

main :: IO ()

main = do
    sharedDir <- (<> "/.cache/mr-dhall") <$> getHomeDirectory
    shakeArgs shakeOptions{shakeShare = Just sharedDir, shakeChange = ChangeDigest} $ do

    "clean" ~> do
        putInfo "Cleaning files in _build"
        removeFilesAfter sharedDir ["//*"]
        removeFilesAfter ".shake" ["//*"]

    "generate" ~> do
        ds <- getDirectoryFiles "" ["examples/*.dhall"]
        let ys = [ d -<.> "mr" | d <- ds]
        need ys

    "*//*.mr" %> \out -> do
        let src = out -<.> "dhall"
        needDhall [src]
        Stdout result <- cmd "dhall text" "--file" src
        writeFile' out result
