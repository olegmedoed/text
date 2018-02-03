@.str = unnamed_addr constant [4 x i8] c"%d\0a\00"

declare i32 @printf(i8*, ...)

define i32 @max(i32 %x, i32 %y) nounwind {
    %cond = icmp ugt i32 %x, %y
    br i1 %cond, label %if_true, label %if_false
if_true:
    ret i32 %x
if_false:
    ret i32 %y
}

define i32 @main() nounwind {
   %_x = alloca i32, align 4
   %_y = alloca i32, align 4
   store i32 4, i32* %_x, align 4
   store i32 4, i32* %_y, align 4
   %x = load i32, i32* %_x, align 4
   %y = load i32, i32* %_y, align 4
   %res = call i32 @max(i32 %x, i32 %y)
   call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 %res)
   ret i32 2
}
