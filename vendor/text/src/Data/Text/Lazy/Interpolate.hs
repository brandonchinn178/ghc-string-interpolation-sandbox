{-# LANGUAGE RankNTypes #-}

module Data.Text.Lazy.Interpolate (
  module X,
  interpolateFinalize,
) where

import Data.String (IsString, fromString)
import Data.String.Experimental as X hiding (interpolateFinalize)
import qualified Data.String.Experimental as S
import Data.Text.Lazy (LazyText)

interpolateFinalize :: (forall s. (IsString s, Monoid s) => s) -> LazyText
interpolateFinalize x = fromString (S.interpolateFinalize x)
{-# INLINE interpolateFinalize #-}
