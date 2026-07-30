module Data.Text.Interpolate where

import Data.String (fromString)
import Data.String.Interpolate.Experimental (Interpolate (..))
import Data.Text (Text)
import Data.Text qualified as Text
import Data.Text.Lazy (LazyText)
import Data.Text.Lazy qualified as Text.Lazy
import Data.Text.Lazy.Builder qualified as Text (Builder)
import Data.Text.Lazy.Builder qualified as Text.Builder
import Data.Text.Lazy.Builder.Int qualified as Text.Builder

interpolateRaw :: String -> Text.Builder
interpolateRaw = Text.Builder.fromString
{-# INLINE [1] interpolateRaw #-}

interpolateValue :: Interpolate a => a -> Text.Builder
interpolateValue = Text.Builder.fromText . interpolate
{-# INLINE [1] interpolateValue #-}

interpolateAppend :: Text.Builder -> Text.Builder -> Text.Builder
interpolateAppend = mappend
{-# INLINE [1] interpolateAppend #-}

interpolateEmpty :: Text.Builder
interpolateEmpty = mempty
{-# INLINE [1] interpolateEmpty #-}

interpolateFinalize :: Text.Builder -> Text
interpolateFinalize = Text.Lazy.toStrict . Text.Builder.toLazyText
{-# INLINE [1] interpolateFinalize #-}

-- Speeds up Text.interpolateValue by 9x
{-# RULES
"interpolateValue/Text" [2] forall (s :: Text).
  interpolateValue s = Text.Builder.fromText s
"interpolateValue/Int" [2] forall (n :: Int).
  interpolateValue n = Text.Builder.decimal n
#-}

instance Interpolate Text where
  interpolate = fromString . Text.unpack
  {-# INLINE [1] interpolate #-}
instance Interpolate LazyText where
  interpolate = fromString . Text.unpack . Text.Lazy.toStrict
  {-# INLINE [1] interpolate #-}
instance Interpolate Text.Builder where
  interpolate = fromString . Text.unpack . Text.Lazy.toStrict . Text.Builder.toLazyText
  {-# INLINE [1] interpolate #-}

-- Speeds up interpolation by 9x
{-# RULES
"interpolate/Text.Builder/Text" [2]
  interpolate @Text @Text.Builder = Text.Builder.fromText

"interpolate/Text.Builder/Int" [2]
  interpolate @Int @Text.Builder = Text.Builder.decimal
#-}
