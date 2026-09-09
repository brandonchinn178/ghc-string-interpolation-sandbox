{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QualifiedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE StringInterpolation #-}

import Control.DeepSeq (NFData (..))
import Data.List (isInfixOf)
import Data.String (IsString)
import Data.Text (Text)
import Data.Text qualified as Text
import Data.Text.Lazy qualified as Text.Lazy
import Data.Text.Lazy.Builder qualified as B
import Data.Text.Lazy.Builder.Int qualified as B
import Data.Text.Lazy.Builder.Interpolate qualified as B
import Data.Text.Interpolate qualified as Text
import Test.Tasty.Bench
import Test.Tasty.Runners (TestTree (SingleTest))

main :: IO ()
main = defaultMain
  [ bgroup' "string" $
      [ bench "naive (BASE)" (nf stringNaive input)
      , bench "interpolated" (nf stringInterpolated input)
      ]
  , bgroup' "text" $
      [ bench "naive (BASE)" (nf textNaive input)
      , bench "interpolated" (nf textInterpolated input)
      , bench "qualified" (nf textInterpolatedQual input)
      ]
  , bgroup' "text builder" $
      [ bench "naive (BASE)" (nf builderNaive input)
      , bench "interpolated" (nf builderInterpolated input)
      , bench "qualified" (nf builderInterpolatedQual input)
      , bench "explicit" (nf builderInterpolatedExplicit input)
      ]
  ]
  where
    bgroup' name benchmarks =
      bgroup name $
        [ (if isBase then id else bcompare $ "$(NF-1) == " <> show name <> " && $NF ~ /BASE/")
            benchmark
        | benchmark <- benchmarks
        , let isBase =
                case benchmark of
                  SingleTest name _ -> "BASE" `isInfixOf` name
                  _ -> False
        ]

    input :: IsString s => Input s
    input =
      Input
        { name = "example"
        , age = 10
        , description = "This is a very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very long description"
        , bigint = maxBound
        }

data Input s = Input
  { name :: s
  , age :: Int
  , description :: s
  , bigint :: Int
  }

stringNaive :: Input String -> String
stringNaive Input{..} =
  "Name = " <> name <>
  ", age = " <> show age <>
  ", description = " <> description <>
  ", bigint = " <> show bigint

stringInterpolated :: Input String -> String
stringInterpolated Input{..} = s"Name = ${name}, age = ${age}, description = ${description}, bigint = ${bigint}"

textNaive :: Input Text -> Text
textNaive Input{..} =
  "Name = " <> name <>
  ", age = " <> Text.show age <>
  ", description = " <> description <>
  ", bigint = " <> Text.show bigint

textInterpolated :: Input Text -> Text
textInterpolated Input{..} = s"Name = ${name}, age = ${age}, description = ${description}, bigint = ${bigint}"

textInterpolatedQual :: Input Text -> Text
textInterpolatedQual Input{..} = Text.s"Name = ${name}, age = ${age}, description = ${description}, bigint = ${bigint}"

builderNaive :: Input B.Builder -> B.Builder
builderNaive Input{..} =
  "Name = " <> name <>
  ", age = " <> B.decimal age <>
  ", description = " <> description <>
  ", bigint = " <> B.decimal bigint

builderInterpolated :: Input B.Builder -> B.Builder
builderInterpolated Input{..} = s"Name = ${name}, age = ${age}, description = ${description}, bigint = ${bigint}"

builderInterpolatedQual :: Input B.Builder -> B.Builder
builderInterpolatedQual Input{..} = B.s"Name = ${name}, age = ${age}, description = ${description}, bigint = ${bigint}"

builderInterpolatedExplicit :: Input B.Builder -> B.Builder
builderInterpolatedExplicit Input{..} =
  B.s"Name = ${name}, age = ${B.decimal age}, description = ${description}, bigint = ${B.decimal bigint}"

instance NFData B.Builder where
  rnf = rnf . B.toLazyText
