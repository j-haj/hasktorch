{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}

module Main where

import Control.Monad (foldM)
import Data.Maybe (catMaybes)
import Data.Generics.Product.Fields (field)
import GHC.Generics (Generic)
import Prelude as P
import Text.Printf (printf)
import System.IO (hFlush, stdout)
    
import Numeric.Backprop as Bp
import Torch.Double as Torch hiding (add)
import Torch.Double.NN.Linear (Linear(..), linearBatch)
import Torch.Double.NN.Activation (Relu(..), relu)
import qualified Torch.Core.Random as RNG

type DataDim = 64
type BatchSize = 100

data Autoencoder = Autoencoder {
    enc1 :: Linear DataDim 32
    , enc2 :: Linear 32 16
    , dec1 :: Linear 16 32
    , dec2 :: Linear 32 DataDim
} deriving (Generic, Show)

instance Backprop Autoencoder where
    add a b = Autoencoder 
        (Bp.add (enc1 a) (enc1 b)) (Bp.add (enc2 a) (enc2 b))
        (Bp.add (dec1 a) (dec1 b)) (Bp.add (dec2 a) (dec2 b))
    one _ = Autoencoder 
        (Bp.one undefined) (Bp.one undefined)  
        (Bp.one undefined) (Bp.one undefined) 
    zero _ = Autoencoder 
        (Bp.zero undefined) (Bp.zero undefined)  
        (Bp.zero undefined) (Bp.zero undefined) 

seedVal = 31415926535

newLayerWithBias :: All Dimensions '[d,d'] => Word -> IO (Tensor d, Tensor d')
newLayerWithBias n = do
  g <- newRNG
  let Just pair = ord2Tuple (-stdv, stdv)
  manualSeed g seedVal
  (,) <$> uniform g pair
      <*> uniform g pair
  where
    stdv :: Double
    stdv = 1 / P.sqrt (fromIntegral n)

newLinear :: forall o i . All KnownDim '[i,o] => IO (Linear i o)
newLinear = fmap Linear . newLayerWithBias $ dimVal (dim :: Dim i)

forward :: forall s . Reifies s W =>
    BVar s Autoencoder -- model architecture
    -> BVar s (Tensor '[BatchSize, DataDim]) -- input
    -> BVar s (Tensor '[BatchSize, DataDim]) -- output
forward modelArch input =
    relu $ (linearBatch (modelArch ^^. (field @"dec2"))) $
    relu $ (linearBatch (modelArch ^^. (field @"dec1"))) $
    relu $ (linearBatch (modelArch ^^. (field @"enc2"))) $
    relu $ (linearBatch (modelArch ^^. (field @"enc1"))) input

genBatch ::
  Generator -- RNG
  -> IO (Tensor '[BatchSize, DataDim])
genBatch gen = do
  let Just scale = positive 5
  -- data drawn from a gaussian mixture
  x1 :: Tensor '[25, DataDim] <- normal gen 0 scale
  x2 :: Tensor '[25, DataDim] <- normal gen 10 scale
  x3 :: Tensor '[25, DataDim] <- normal gen 20 scale
  x4 :: Tensor '[25, DataDim] <- normal gen 30 scale
  pure $ cat2d0 x1 $ cat2d0 x2 $ cat2d0 x3 x4

trainStep ::
  HsReal                               -- learning rate
  -> (Autoencoder, [(Tensor '[1])])    -- (network, history)
  -> Tensor '[BatchSize, DataDim]      -- input
  -> IO (Autoencoder, [(Tensor '[1])]) -- (updated network, history)
trainStep learningRate (net, hist) x = do
  pure (Bp.add net gnet, (out):hist)
  where
    (out, (Autoencoder e1 e2 d1 d2, _)) =
      backprop2 (mSECriterion x .: forward) net x
    gnet = Autoencoder 
        (e1 ^* (-learningRate)) (e2 ^* (-learningRate))
        (d1 ^* (-learningRate)) (d2 ^* (-learningRate))

epochs ::
  HsReal                            -- learning rate
  -> Int                            -- max # of epochs
  -> [Tensor '[BatchSize, DataDim]] -- data to run batch on
  -> Autoencoder
  -> IO Autoencoder
epochs learningRate maxEpochs tset net0 = do
  runEpoch 0 net0
  where
    runEpoch :: Int -> Autoencoder -> IO Autoencoder
    runEpoch epoch net
      | epoch > maxEpochs = pure net
      | otherwise = do
        (net', hist) <- foldM (trainStep learningRate) (net, []) tset
        let val =  P.sum $ catMaybes (map (`get1d` 0) $ hist :: [Maybe Double])
        if epoch `mod` 50 == 0 then
          printf "[Epoch %d][Loss %.4f]\n" epoch val
        else
          pure ()
        hFlush stdout
        runEpoch (epoch + 1) net'

main = do

    -- model parameters
    let numBatch = 1
    let learningRate = 1.5e-6
    let numEpochs = 5000

    -- produce simulated data
    gen <- newRNG
    RNG.manualSeed gen seedVal
    batches <- mapM (\_ -> genBatch gen)  ([1..numBatch] :: [Integer])

    -- train model
    net0 <- Autoencoder <$> 
        newLinear <*> newLinear <*> newLinear <*> newLinear

    print net0

    putStrLn "\nTraining ========================================\n"
    net <- epochs learningRate numEpochs batches net0

    putStrLn "Done"
    pure net