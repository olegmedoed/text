;.section	.rodata.str1.1,"aMS",@progbits,1   << if unnamed_addr is omited
@.str = unnamed_addr constant [11 x i8] c"hello man\0a\00"

declare i32 @puts(i8* nocapture) nounwind

; unsigned square_int(unsigned a) { return a*a; }
define i32 @square_int(i32 %a) #0 {
  %1 = mul i32 %a, %a
  ret i32 %1
}

define i32 @main() nounwind {
  %cast210 = getelementptr [11 x i8], [11 x i8]* @.str, i64 0, i64 0

  call i32 @puts(i8* %cast210)
  call i32 @square_int(i32 5)
  ret i32 0
}
