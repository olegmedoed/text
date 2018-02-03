; ModuleID = 'fact.c'
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i586-pc-linux-gnu"

; Function Attrs: nounwind readnone
define i32 @fact(i32 %n) #0 {
  %i.0.1 = add nsw i32 %n, -1
  %1 = icmp sgt i32 %i.0.1, 1
  br i1 %1, label %.lr.ph, label %._crit_edge

.lr.ph:                                           ; preds = %0, %.lr.ph
  %i.03 = phi i32 [ %i.0, %.lr.ph ], [ %i.0.1, %0 ]
  %res.02 = phi i32 [ %2, %.lr.ph ], [ %n, %0 ]
  %2 = mul nsw i32 %i.03, %res.02
  %i.0 = add nsw i32 %i.03, -1
  %3 = icmp sgt i32 %i.0, 1
  br i1 %3, label %.lr.ph, label %._crit_edge

._crit_edge:                                      ; preds = %.lr.ph, %0
  %res.0.lcssa = phi i32 [ %n, %0 ], [ %2, %.lr.ph ]
  ret i32 %res.0.lcssa
}

; Function Attrs: nounwind readnone
define i32 @main() #0 {
  %1 = tail call i32 @fact(i32 5)
  ret i32 %1
}

attributes #0 = { nounwind readnone "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"Debian clang version 3.7.1-svn253742-1~exp1 (branches/release_37) (based on LLVM 3.7.1)"}
