{-# LANGUAGE TypeFamilies #-}

module Data.OverloadedStringsAlt where

import Data.Monoid (Endo (..))
import Data.String (IsString (..))
import Data.String.Interpolate.Experimental (Interpolate (..))
import Data.Text (Text)
import Data.Text.Lazy qualified as Text.Lazy
import Data.Text.Lazy.Builder qualified as Text (Builder)
import Data.Text.Lazy.Builder qualified as Builder
import Data.Text.Lazy.Builder.Int qualified as Builder

interpolateRaw :: (IsString builder) => String -> builder
interpolateRaw = fromString
{-# INLINE [1] interpolateRaw #-}

interpolateValue :: (Interpolate a, IsString builder, Monoid builder) => a -> builder
interpolateValue = interpolate
{-# INLINE [1] interpolateValue #-}

interpolateAppend :: (Monoid builder) => builder -> builder -> builder
interpolateAppend = mappend
{-# INLINE [1] interpolateAppend #-}

interpolateEmpty :: (Monoid builder) => builder
interpolateEmpty = mempty
{-# INLINE [1] interpolateEmpty #-}

interpolateFinalize :: HasBuilder s => Builder s -> s
interpolateFinalize = fromBuilder
{-# INLINE [1] interpolateFinalize #-}

{----- HasBuilder -----}

class Monoid (Builder s) => HasBuilder s where
  type Builder s
  fromBuilder :: Builder s -> s

{----- String -----}

instance HasBuilder String where
  type Builder String = StringBuilder
  fromBuilder = buildString
  {-# INLINE [1] fromBuilder #-}

newtype StringBuilder = StringBuilder (Endo String)
  deriving newtype (Semigroup, Monoid)
instance IsString StringBuilder where
  fromString s = StringBuilder (Endo (s <>))
  {-# INLINE [1] fromString #-}

buildString :: StringBuilder -> String
buildString (StringBuilder (Endo f)) = f ""
{-# INLINE [1] buildString #-}

{----- Text -----}

instance HasBuilder Text where
  type Builder Text = Text.Builder
  fromBuilder = Text.Lazy.toStrict . Builder.toLazyText
  {-# INLINE [1] fromBuilder #-}
