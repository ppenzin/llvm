; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx,+xop | FileCheck %s --check-prefix=XOP
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512vl | FileCheck %s --check-prefix=AVX512

; fold (rot (rot x, c1), c2) -> rot x, c1+c2
define <4 x i32> @combine_vec_rot_rot(<4 x i32> %x) {
; XOP-LABEL: combine_vec_rot_rot:
; XOP:       # %bb.0:
; XOP-NEXT:    vprotd {{.*}}(%rip), %xmm0, %xmm0
; XOP-NEXT:    retq
;
; AVX512-LABEL: combine_vec_rot_rot:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vprolvd {{.*}}(%rip), %xmm0, %xmm0
; AVX512-NEXT:    retq
  %1 = lshr <4 x i32> %x, <i32 1, i32 2, i32 3, i32 4>
  %2 = shl <4 x i32> %x, <i32 31, i32 30, i32 29, i32 28>
  %3 = or <4 x i32> %1, %2
  %4 = lshr <4 x i32> %3, <i32 12, i32 13, i32 14, i32 15>
  %5 = shl <4 x i32> %3, <i32 20, i32 19, i32 18, i32 17>
  %6 = or <4 x i32> %4, %5
  ret <4 x i32> %6
}

define <4 x i32> @combine_vec_rot_rot_splat(<4 x i32> %x) {
; XOP-LABEL: combine_vec_rot_rot_splat:
; XOP:       # %bb.0:
; XOP-NEXT:    vprotd $7, %xmm0, %xmm0
; XOP-NEXT:    retq
;
; AVX512-LABEL: combine_vec_rot_rot_splat:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vprold $7, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %1 = lshr <4 x i32> %x, <i32 3, i32 3, i32 3, i32 3>
  %2 = shl <4 x i32> %x, <i32 29, i32 29, i32 29, i32 29>
  %3 = or <4 x i32> %1, %2
  %4 = lshr <4 x i32> %3, <i32 22, i32 22, i32 22, i32 22>
  %5 = shl <4 x i32> %3, <i32 10, i32 10, i32 10, i32 10>
  %6 = or <4 x i32> %4, %5
  ret <4 x i32> %6
}

define <4 x i32> @combine_vec_rot_rot_splat_zero(<4 x i32> %x) {
; XOP-LABEL: combine_vec_rot_rot_splat_zero:
; XOP:       # %bb.0:
; XOP-NEXT:    retq
;
; AVX512-LABEL: combine_vec_rot_rot_splat_zero:
; AVX512:       # %bb.0:
; AVX512-NEXT:    retq
  %1 = lshr <4 x i32> %x, <i32 1, i32 1, i32 1, i32 1>
  %2 = shl <4 x i32> %x, <i32 31, i32 31, i32 31, i32 31>
  %3 = or <4 x i32> %1, %2
  %4 = lshr <4 x i32> %3, <i32 31, i32 31, i32 31, i32 31>
  %5 = shl <4 x i32> %3, <i32 1, i32 1, i32 1, i32 1>
  %6 = or <4 x i32> %4, %5
  ret <4 x i32> %6
}
