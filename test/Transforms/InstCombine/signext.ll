; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

target datalayout = "n8:16:32:64"

define i32 @test1(i32 %x) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[SEXT:%.*]] = shl i32 %x, 16
; CHECK-NEXT:    [[TMP_3:%.*]] = ashr exact i32 [[SEXT]], 16
; CHECK-NEXT:    ret i32 [[TMP_3]]
;
  %tmp.1 = and i32 %x, 65535
  %tmp.2 = xor i32 %tmp.1, -32768
  %tmp.3 = add i32 %tmp.2, 32768
  ret i32 %tmp.3
}

define i32 @test2(i32 %x) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[SEXT:%.*]] = shl i32 %x, 16
; CHECK-NEXT:    [[TMP_3:%.*]] = ashr exact i32 [[SEXT]], 16
; CHECK-NEXT:    ret i32 [[TMP_3]]
;
  %tmp.1 = and i32 %x, 65535
  %tmp.2 = xor i32 %tmp.1, 32768
  %tmp.3 = add i32 %tmp.2, -32768
  ret i32 %tmp.3
}

define i32 @test3(i16 %P) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[TMP_5:%.*]] = sext i16 %P to i32
; CHECK-NEXT:    ret i32 [[TMP_5]]
;
  %tmp.1 = zext i16 %P to i32
  %tmp.4 = xor i32 %tmp.1, 32768
  %tmp.5 = add i32 %tmp.4, -32768
  ret i32 %tmp.5
}

define i32 @test4(i32 %x) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[SEXT:%.*]] = shl i32 %x, 24
; CHECK-NEXT:    [[TMP_3:%.*]] = ashr exact i32 [[SEXT]], 24
; CHECK-NEXT:    ret i32 [[TMP_3]]
;
  %tmp.1 = and i32 %x, 255
  %tmp.2 = xor i32 %tmp.1, 128
  %tmp.3 = add i32 %tmp.2, -128
  ret i32 %tmp.3
}

define i32 @test5(i32 %x) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[TMP_2:%.*]] = shl i32 %x, 16
; CHECK-NEXT:    [[TMP_4:%.*]] = ashr exact i32 [[TMP_2]], 16
; CHECK-NEXT:    ret i32 [[TMP_4]]
;
  %tmp.2 = shl i32 %x, 16
  %tmp.4 = ashr i32 %tmp.2, 16
  ret i32 %tmp.4
}

;  If the shift amount equals the difference in width of the destination
;  and source scalar types:
;  ashr (shl (zext X), C), C --> sext X

define i32 @test6(i16 %P) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[TMP_5:%.*]] = sext i16 %P to i32
; CHECK-NEXT:    ret i32 [[TMP_5]]
;
  %tmp.1 = zext i16 %P to i32
  %sext1 = shl i32 %tmp.1, 16
  %tmp.5 = ashr i32 %sext1, 16
  ret i32 %tmp.5
}

; Vectors should get the same fold as above.

define <2 x i32> @test6_splat_vec(<2 x i12> %P) {
; CHECK-LABEL: @test6_splat_vec(
; CHECK-NEXT:    [[ASHR:%.*]] = sext <2 x i12> %P to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[ASHR]]
;
  %z = zext <2 x i12> %P to <2 x i32>
  %shl = shl <2 x i32> %z, <i32 20, i32 20>
  %ashr = ashr <2 x i32> %shl, <i32 20, i32 20>
  ret <2 x i32> %ashr
}

define i32 @test7(i32 %x) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[SUB:%.*]] = ashr i32 %x, 5
; CHECK-NEXT:    ret i32 [[SUB]]
;
  %shr = lshr i32 %x, 5
  %xor = xor i32 %shr, 67108864
  %sub = add i32 %xor, -67108864
  ret i32 %sub
}

