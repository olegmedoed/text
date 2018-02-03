@glob_var = internal constant i32 14
@hello    = internal constant [6 x i8] c"hello\00"

declare i32 @puts(i8* nocapture) nounwind

define i32 @main() nounwind {
  ;%1 = load i32, i32* @glob_bar
  %1 = load i32, i32* @glob_var
  %2 = add i32 %1, 3
  %3 = load 
  call i32 @puts(i8* @hello)
  ret i32 %2
}
