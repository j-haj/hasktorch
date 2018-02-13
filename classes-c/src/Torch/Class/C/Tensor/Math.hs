module Torch.Class.C.Tensor.Math where

import THTypes
import Foreign hiding (new)
import Foreign.C.Types
import Torch.Class.C.Internal
import GHC.Int
import Torch.Class.C.IsTensor (IsTensor(new))
import THRandomTypes (Generator)
import qualified THByteTypes   as B
import qualified THLongTypes   as L

constant :: (IsTensor t, TensorMath t) => HsReal t -> IO t
constant v = new >>= \t -> fill_ t v >> pure t

class TensorMath t where
  fill_        :: t -> HsReal t -> IO ()
  zero_        :: t -> IO ()
  maskedFill_  :: t -> B.DynTensor -> HsReal t -> IO ()
  maskedCopy_  :: t -> B.DynTensor -> t -> IO ()
  maskedSelect_ :: t -> t -> B.DynTensor -> IO ()
  nonzero_     :: L.DynTensor -> t -> IO ()
  indexSelect_ :: t -> t -> Int32 -> L.DynTensor -> IO ()
  indexCopy_   :: t -> Int32 -> L.DynTensor -> t -> IO ()
  indexAdd_    :: t -> Int32 -> L.DynTensor -> t -> IO ()
  indexFill_   :: t -> Int32 -> L.DynTensor -> HsReal t -> IO ()
  take_        :: t -> t -> L.DynTensor -> IO ()
  put_         :: t -> L.DynTensor -> t -> Int32 -> IO ()
  gather_      :: t -> t -> Int32 -> L.DynTensor -> IO ()
  scatter_     :: t -> Int32 -> L.DynTensor -> t -> IO ()
  scatterAdd_  :: t -> Int32 -> L.DynTensor -> t -> IO ()
  scatterFill_ :: t -> Int32 -> L.DynTensor -> HsReal t -> IO ()
  dot          :: t -> t -> IO (HsAccReal t)
  minall       :: t -> IO (HsReal t)
  maxall       :: t -> IO (HsReal t)
  medianall    :: t -> IO (HsReal t)
  sumall       :: t -> IO (HsAccReal t)
  prodall      :: t -> IO (HsAccReal t)
  add_         :: t -> t -> HsReal t -> IO ()
  sub_         :: t -> t -> HsReal t -> IO ()
  add_scaled_  :: t -> t -> HsReal t -> HsReal t -> IO ()
  sub_scaled_  :: t -> t -> HsReal t -> HsReal t -> IO ()
  mul_         :: t -> t -> HsReal t -> IO ()
  div_         :: t -> t -> HsReal t -> IO ()
  lshift_      :: t -> t -> HsReal t -> IO ()
  rshift_      :: t -> t -> HsReal t -> IO ()
  fmod_        :: t -> t -> HsReal t -> IO ()
  remainder_   :: t -> t -> HsReal t -> IO ()
  clamp_       :: t -> t -> HsReal t -> HsReal t -> IO ()
  bitand_      :: t -> t -> HsReal t -> IO ()
  bitor_       :: t -> t -> HsReal t -> IO ()
  bitxor_      :: t -> t -> HsReal t -> IO ()
  cadd_        :: t -> t -> HsReal t -> t -> IO ()
  csub_        :: t -> t -> HsReal t -> t -> IO ()
  cmul_        :: t -> t -> t -> IO ()
  cpow_        :: t -> t -> t -> IO ()
  cdiv_        :: t -> t -> t -> IO ()
  clshift_     :: t -> t -> t -> IO ()
  crshift_     :: t -> t -> t -> IO ()
  cfmod_       :: t -> t -> t -> IO ()
  cremainder_  :: t -> t -> t -> IO ()
  cbitand_     :: t -> t -> t -> IO ()
  cbitor_      :: t -> t -> t -> IO ()
  cbitxor_     :: t -> t -> t -> IO ()
  addcmul_     :: t -> t -> HsReal t -> t -> t -> IO ()
  addcdiv_     :: t -> t -> HsReal t -> t -> t -> IO ()
  addmv_       :: t -> HsReal t -> t -> HsReal t -> t -> t -> IO ()
  addmm_       :: t -> HsReal t -> t -> HsReal t -> t -> t -> IO ()
  addr_        :: t -> HsReal t -> t -> HsReal t -> t -> t -> IO ()
  addbmm_      :: t -> HsReal t -> t -> HsReal t -> t -> t -> IO ()
  baddbmm_     :: t -> HsReal t -> t -> HsReal t -> t -> t -> IO ()
  match_       :: t -> t -> t -> HsReal t -> IO ()
  numel        :: t -> IO Int64
  max_         :: (t, L.DynTensor) -> t -> Int32 -> Int32 -> IO ()
  min_         :: (t, L.DynTensor) -> t -> Int32 -> Int32 -> IO ()
  kthvalue_    :: (t, L.DynTensor) -> t -> Int64 -> Int32 -> Int32 -> IO ()
  mode_        :: (t, L.DynTensor) -> t -> Int32 -> Int32 -> IO ()
  median_      :: (t, L.DynTensor) -> t -> Int32 -> Int32 -> IO ()
  sum_         :: t -> t -> Int32 -> Int32 -> IO ()
  prod_        :: t -> t -> Int32 -> Int32 -> IO ()
  cumsum_      :: t -> t -> Int32 -> IO ()
  cumprod_     :: t -> t -> Int32 -> IO ()
  sign_        :: t -> t -> IO ()
  trace        :: t -> IO (HsAccReal t)
  cross_       :: t -> t -> t -> Int32 -> IO ()
  cmax_        :: t -> t -> t -> IO ()
  cmin_        :: t -> t -> t -> IO ()
  cmaxValue_   :: t -> t -> HsReal t -> IO ()
  cminValue_   :: t -> t -> HsReal t -> IO ()
  zeros_       :: t -> L.Storage -> IO ()
  zerosLike_   :: t -> t -> IO ()
  ones_        :: t -> L.Storage -> IO ()
  onesLike_    :: t -> t -> IO ()
  diag_        :: t -> t -> Int32 -> IO ()
  eye_         :: t -> Int64 -> Int64 -> IO ()
  arange_      :: t -> HsAccReal t-> HsAccReal t-> HsAccReal t-> IO ()
  range_       :: t -> HsAccReal t-> HsAccReal t-> HsAccReal t-> IO ()
  randperm_    :: t -> Generator -> Int64 -> IO ()
  reshape_     :: t -> t -> L.Storage -> IO ()
  sort_        :: t -> L.DynTensor -> t -> Int32 -> Int32 -> IO ()
  topk_        :: t -> L.DynTensor -> t -> Int64 -> Int32 -> Int32 -> Int32 -> IO ()
  tril_        :: t -> t -> Int64 -> IO ()
  triu_        :: t -> t -> Int64 -> IO ()
  cat_         :: t -> t -> t -> Int32 -> IO ()
  catArray_    :: t -> [t] -> Int32 -> Int32 -> IO ()
  equal        :: t -> t -> IO Int32
  ltValue_     :: B.DynTensor -> t -> HsReal t -> IO ()
  leValue_     :: B.DynTensor -> t -> HsReal t -> IO ()
  gtValue_     :: B.DynTensor -> t -> HsReal t -> IO ()
  geValue_     :: B.DynTensor -> t -> HsReal t -> IO ()
  neValue_     :: B.DynTensor -> t -> HsReal t -> IO ()
  eqValue_     :: B.DynTensor -> t -> HsReal t -> IO ()
  ltValueT_    :: t -> t -> HsReal t -> IO ()
  leValueT_    :: t -> t -> HsReal t -> IO ()
  gtValueT_    :: t -> t -> HsReal t -> IO ()
  geValueT_    :: t -> t -> HsReal t -> IO ()
  neValueT_    :: t -> t -> HsReal t -> IO ()
  eqValueT_    :: t -> t -> HsReal t -> IO ()
  ltTensor_    :: B.DynTensor -> t -> t -> IO ()
  leTensor_    :: B.DynTensor -> t -> t -> IO ()
  gtTensor_    :: B.DynTensor -> t -> t -> IO ()
  geTensor_    :: B.DynTensor -> t -> t -> IO ()
  neTensor_    :: B.DynTensor -> t -> t -> IO ()
  eqTensor_    :: B.DynTensor -> t -> t -> IO ()
  ltTensorT_   :: t -> t -> t -> IO ()
  leTensorT_   :: t -> t -> t -> IO ()
  gtTensorT_   :: t -> t -> t -> IO ()
  geTensorT_   :: t -> t -> t -> IO ()
  neTensorT_   :: t -> t -> t -> IO ()
  eqTensorT_   :: t -> t -> t -> IO ()

class TensorMathSigned t where
  neg_         :: t -> t -> IO ()
  abs_         :: t -> t -> IO ()

neg :: (IsTensor t, TensorMathSigned t) => t -> IO t
neg t = new >>= \r -> neg_ r t >> pure r

abs :: (IsTensor t, TensorMathSigned t) => t -> IO t
abs t = new >>= \r -> abs_ r t >> pure r

class TensorMathFloating t where
  cinv         :: t -> t -> IO ()
  sigmoid      :: t -> t -> IO ()
  log          :: t -> t -> IO ()
  lgamma       :: t -> t -> IO ()
  log1p        :: t -> t -> IO ()
  exp          :: t -> t -> IO ()
  cos          :: t -> t -> IO ()
  acos         :: t -> t -> IO ()
  cosh         :: t -> t -> IO ()
  sin          :: t -> t -> IO ()
  asin         :: t -> t -> IO ()
  sinh         :: t -> t -> IO ()
  tan          :: t -> t -> IO ()
  atan         :: t -> t -> IO ()
  atan2        :: t -> t -> t -> IO ()
  tanh         :: t -> t -> IO ()
  erf          :: t -> t -> IO ()
  erfinv       :: t -> t -> IO ()
  pow          :: t -> t -> HsReal t -> IO ()
  tpow         :: t -> HsReal t -> t -> IO ()
  sqrt         :: t -> t -> IO ()
  rsqrt        :: t -> t -> IO ()
  ceil         :: t -> t -> IO ()
  floor        :: t -> t -> IO ()
  round        :: t -> t -> IO ()
  trunc        :: t -> t -> IO ()
  frac         :: t -> t -> IO ()
  lerp         :: t -> t -> t -> HsReal t -> IO ()
  mean         :: t -> t -> Int32 -> Int32 -> IO ()
  std          :: t -> t -> Int32 -> Int32 -> Int32 -> IO ()
  var          :: t -> t -> Int32 -> Int32 -> Int32 -> IO ()
  norm         :: t -> t -> HsReal t -> Int32 -> Int32 -> IO ()
  renorm       :: t -> t -> HsReal t -> Int32 -> HsReal t -> IO ()
  dist         :: t -> t -> HsReal t -> IO (HsAccReal t)
  histc        :: t -> t -> Int64 -> HsReal t -> HsReal t -> IO ()
  bhistc       :: t -> t -> Int64 -> HsReal t -> HsReal t -> IO ()
  meanall      :: t -> IO (HsAccReal t)
  varall       :: t -> Int32 -> IO (HsAccReal t)
  stdall       :: t -> Int32 -> IO (HsAccReal t)
  normall      :: t -> HsReal t -> IO (HsAccReal t)
  linspace     :: t -> HsReal t -> HsReal t -> Int64 -> IO ()
  logspace     :: t -> HsReal t -> HsReal t -> Int64 -> IO ()
  rand         :: t -> Generator -> L.Storage -> IO ()
  randn        :: t -> Generator -> L.Storage -> IO ()
