{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QualifiedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE StringInterpolation #-}

import Data.List (isInfixOf)
import Data.String (IsString)
import Data.String.Interpolate.Basic.Experimental qualified as B
import Data.Text (Text)
import Data.Text qualified as Text
import Data.Text.Lazy qualified as Text.Lazy
import Data.Text.Lazy.Builder qualified as B
import Data.Text.Lazy.Builder.Int qualified as B
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
      , bench "interpolated explicit" (nf textInterpolatedExplicit input)
      ]
  , bgroup' "text qualified" $
      [ bench "naive (BASE)" (nf textQualNaive input)
      , bench "interpolated" (nf textQualInterpolated input)
      , bench "interpolated explicit" (nf textQualInterpolatedExplicit input)
      ]
  , bgroup' "text builder" $
      [ bench "naive (BASE)" (nf builderNaive input)
      , bench "interpolated" (nf builderInterpolated input)
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

textInterpolatedExplicit :: Input Text -> Text
textInterpolatedExplicit Input{..} = B.s"Name = ${name}, age = ${Text.show age}, description = ${description}, bigint = ${Text.show bigint}"

textQualNaive :: Input Text -> Text
textQualNaive Input{..} =
  Text.Lazy.toStrict . B.toLazyText $
  "Name = " <> B.fromText name <>
  ", age = " <> B.decimal age <>
  ", description = " <> B.fromText description <>
  ", bigint = " <> B.decimal bigint

textQualInterpolated :: Input Text -> Text
textQualInterpolated Input{..} = Text.s"Name = ${name}, age = ${age}, description = ${description}, bigint = ${bigint}"

textQualInterpolatedExplicit :: Input Text -> Text
textQualInterpolatedExplicit Input{..} =
  Text.Lazy.toStrict . B.toLazyText $
  B.s"Name = ${B.fromText name}, age = ${B.decimal age}, description = ${B.fromText description}, bigint = ${B.decimal bigint}"

builderNaive :: Input B.Builder -> B.Builder
builderNaive Input{..} =
  "Name = " <> name <>
  ", age = " <> B.decimal age <>
  ", description = " <> description <>
  ", bigint = " <> B.decimal bigint

builderInterpolated :: Input B.Builder -> B.Builder
builderInterpolated Input{..} = s"Name = ${name}, age = ${age}, description = ${description}, bigint = ${bigint}"

builderInterpolatedExplicit :: Input B.Builder -> B.Builder
builderInterpolatedExplicit Input{..} =
  B.s"Name = ${name}, age = ${B.decimal age}, description = ${description}, bigint = ${B.decimal bigint}"
