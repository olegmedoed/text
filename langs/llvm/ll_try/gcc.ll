; ModuleID = 'gcc.c'
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i586-pc-linux-gnu"

@x = global i32 33, align 4
@a = global [3 x i32] [i32 1, i32 2, i32 3], align 4
@.str = private unnamed_addr constant [6 x i8] c"hello\00", align 1

; Function Attrs: nounwind
define i32 @main() #0 {
  %zzz = alloca i32, align 4
  %y = alloca i32, align 4
  %arr = alloca i32*, align 4
  store i32 4, i32* %zzz, align 4
  %1 = load i32, i32* @x, align 4
  store i32 %1, i32* %y, align 4
  store i32* getelementptr inbounds ([3 x i32], [3 x i32]* @a, i32 1, i32 2), i32** %arr, align 4
  %2 = call i32 @puts(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str, i32 0, i32 0))
  ret i32 0
}

declare i32 @puts(i8*) #1

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"Debian clang version 3.7.1-svn253742-1~exp1 (branches/release_37) (based on LLVM 3.7.1)"}
