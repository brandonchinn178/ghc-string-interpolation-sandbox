{-# LANGUAGE RankNTypes #-}

module Data.Text.Lazy.Builder.Interpolate (
  module X,
  interpolateFinalize,
) where

import Data.String (IsString, fromString)
import Data.String.Experimental as X hiding (interpolateFinalize)
import qualified Data.String.Experimental as S
import qualified Data.Text.Lazy.Builder as Text (Builder)

interpolateFinalize :: (forall s. (IsString s, Monoid s) => s) -> Text.Builder
interpolateFinalize x = fromString (S.interpolateFinalize x)
{-# INLINE interpolateFinalize #-}
