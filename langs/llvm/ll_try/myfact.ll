define i32 @fact(i32 %n) nounwind {
    %i.0.1 = add nsw i32 %n, -1
    %1 = icmp sgt i32 %i.0.1, 1         ; i > 1
    br i1 %1, label %do, label %done

do: ; preds = %0, %do
    %i.03   = phi i32 [%i.0, %do],  [%i.0.1, %0] 
    %res.02 = phi i32 [%2,   %do],  [%n,     %0]
    %2 = mul nsw i32 %i.03, %res.02 ; res *= i
    %i.0 = add nsw i32 %i.03, -1    ; --i
    %3 = icmp sgt i32 %i.0, 1
    br i1 %3, label %do, label %done

done: ; preds = %do, %0
    %res.lcssa = phi i32 [%n, %0], [%2, %do]
    ret i32 %res.lcssa
}
