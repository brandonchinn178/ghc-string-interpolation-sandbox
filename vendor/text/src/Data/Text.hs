{-# LANGUAGE MagicHash #-}
{-# LANGUAGE PatternSynonyms #-}
{-# LANGUAGE TypeApplications #-}
{-# OPTIONS_GHC -Wno-orphans #-}

-- |
-- Module      : Data.Text
-- Copyright   : (c) 2009, 2010, 2011, 2012 Bryan O'Sullivan,
--               (c) 2009 Duncan Coutts,
--               (c) 2008, 2009 Tom Harper
--               (c) 2021 Andrew Lelechenko
--
-- License     : BSD-style
-- Maintainer  : bos@serpentine.com
-- Portability : GHC
--
-- A time and space-efficient implementation of Unicode text.
-- Suitable for performance critical use, both in terms of large data
-- quantities and high speed.
--
-- /Note/: Read below the synopsis for important notes on the use of
-- this module.
--
-- This module is intended to be imported @qualified@, to avoid name
-- clashes with "Prelude" functions, e.g.
--
-- > import qualified Data.Text as T
--
-- To use an extended and very rich family of functions for working
-- with Unicode text (including normalization, regular expressions,
-- non-standard encodings, text breaking, and locales), see the
-- <http://hackage.haskell.org/package/text-icu text-icu package >.
--

module Data.Text
    (
    -- * Strict vs lazy types
    -- $strict

    -- * Acceptable data
    -- $replacement

    -- * Definition of character
    -- $character_definition

    -- * Fusion
    -- $fusion

    -- * Types
      Text
    , StrictText

    -- * Creation and elimination
    , pack
    , unpack
    , singleton
    , empty

    -- * Pattern matching
    , pattern Empty
    , pattern (:<)
    , pattern (:>)

    -- * Basic interface
    , cons
    , snoc
    , append
    , uncons
    , unsnoc
    , head
    , last
    , tail
    , init
    , null
    , length
    , compareLength

    -- * Transformations
    , map
    , intercalate
    , intersperse
    , transpose
    , reverse
    , replace

    -- ** Case conversion
    -- $case
    , toCaseFold
    , toLower
    , toUpper
    , toTitle

    -- ** Justification
    , justifyLeft
    , justifyRight
    , center

    -- * Folds
    , foldl
    , foldl'
    , foldl1
    , foldl1'
    , foldr
    , foldr'
    , foldr1
    , foldlM'

    -- ** Special folds
    , concat
    , concatMap
    , any
    , all
    , maximum
    , minimum
    , isAscii

    -- * Construction

    -- ** Scans
    , scanl
    , scanl1
    , scanr
    , scanr1

    -- ** Accumulating maps
    , mapAccumL
    , mapAccumR

    -- ** Generation and unfolding
    , replicate
    , unfoldr
    , unfoldrN

    -- * Substrings

    -- ** Breaking strings
    , take
    , takeEnd
    , drop
    , dropEnd
    , takeWhile
    , takeWhileEnd
    , dropWhile
    , dropWhileEnd
    , dropAround
    , strip
    , stripStart
    , stripEnd
    , splitAt
    , breakOn
    , breakOnEnd
    , break
    , span
    , spanM
    , spanEnd
    , spanEndM
    , group
    , groupBy
    , inits
    , initsNE
    , tails
    , tailsNE

    -- ** Breaking into many substrings
    -- $split
    , splitOn
    , split
    , chunksOf

    -- ** Breaking into lines and words
    , lines
    --, lines'
    , words
    , unlines
    , unwords

    -- * Predicates
    , isPrefixOf
    , isSuffixOf
    , isInfixOf

    -- ** View patterns
    , stripPrefix
    , stripSuffix
    , commonPrefixes

    -- * Searching
    , filter
    , breakOnAll
    , find
    , elem
    , partition

    -- , findSubstring

    -- * Indexing
    -- $index
    , index
    , findIndex
    , count

    -- * Zipping
    , zip
    , zipWith

    -- * Showing values
    , show

    -- -* Ordered text
    -- , sort

    -- * Low level operations
    , copy
    , unpackCString#
    , unpackCStringAscii#

    , measureOff
    ) where

import Data.Text.Impl
import Prelude ()

import Data.Int (Int)
import Data.Monoid (Monoid)
import Data.String (IsString)
import qualified Data.Text.Lazy as L
import qualified Data.Text.Lazy.Builder as B
import qualified Data.Text.Lazy.Builder.Int as B
import qualified Data.String.Interpolate.Default.Experimental as I
import qualified Prelude

{-# RULES
"TEXT interpolateFinalize/Builder" [2]
    forall (x :: forall s. (IsString s, Monoid s) => s).
    B.fromString (I.interpolateFinalize x) = x @B.Builder
"TEXT interpolateFinalize/LazyText"
    forall (x :: forall s. (IsString s, Monoid s) => s).
    L.pack (I.interpolateFinalize x) = B.toLazyText (x @B.Builder)
"TEXT interpolateFinalize/Text"
    forall (x :: forall s. (IsString s, Monoid s) => s).
    pack (I.interpolateFinalize x) = L.toStrict (B.toLazyText (x @B.Builder))

"TEXT interpolateValue Text -> Builder"
    I.interpolateValue = B.fromText
"TEXT interpolateValue LazyText -> Builder"
    I.interpolateValue = B.fromLazyText
"TEXT interpolateValue Builder -> Builder"
    I.interpolateValue = Prelude.id @B.Builder
"TEXT interpolateValue Int -> Builder"
    I.interpolateValue = B.decimal @Int
#-}
