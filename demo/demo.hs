{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QualifiedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE StringInterpolation #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE NoFieldSelectors #-}

import Data.Complex (Complex (..))
import Data.Debug qualified as Debug
import Data.SQL qualified as SQL
import Data.String (fromString)
import Data.String.Interpolate.Experimental (Interpolate (..))
import Data.Ascii qualified as Ascii

main :: IO ()
main = do
  putStrLn "================================================================================"
  let x = 1 :: Int
      y = 2 :: Int
  putStrLn s"${x} + ${y} = ${x + y}"

  putStrLn "================================================================================"
  print $(Debug.s"I got: ${[| x + y |]}")

  putStrLn "================================================================================"
  let n1 = 2 :+ 3 :: Complex Int
      n2 = 4 :+ (-4) :: Complex Int
  putStrLn s"n1 = ${n1}, n2 = ${n2}"

  putStrLn "================================================================================"
  let loc = SrcLoc{file = "Example/Foo/Bar.hs", line = 12, col = 1}
  putStrLn s"Error at ${loc}"

  putStrLn "================================================================================"
  let name = "'Robert'; DROP TABLE Students;--" :: String
      age = 10 :: Int
  print SQL.s"SELECT * FROM tab WHERE name ILIKE ${name} AND age > ${age}"

  putStrLn "================================================================================"

  putStrLn Ascii.s"good example ${x}!"
  -- Uncommenting below is a type error
  -- putStrLn Ascii.s"🙂"
  -- Also works for QualifiedStrings:
  -- putStrLn Ascii."🙂"

  putStrLn "================================================================================"

-- | `2 :+ 3` => "2 + 3i"
instance (Interpolate a, Num a, Ord a) => Interpolate (Complex a) where
  interpolate (r :+ i) = s"${r} ${sign} ${abs i}i"
   where
    sign = if i < 0 then "-" else "+" :: String

data SrcLoc = SrcLoc
  { file :: FilePath
  , line :: Int
  , col :: Int
  }
instance Interpolate SrcLoc where
  interpolate SrcLoc{..} = s"${file}:${line}:${col}"
