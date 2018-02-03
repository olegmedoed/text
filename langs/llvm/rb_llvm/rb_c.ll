; ModuleID = 'rb.c'
target datalayout = "e-m:e-p:32:32-f64:32:64-f80:32-n8:16:32-S128"
target triple = "i586-pc-linux-gnu"

%struct.Node = type { i32, %struct.RBNode*, %struct.RBNode*, %struct.RBNode*, i32 }
%struct.RBNode = type { i32, %struct.Node* }

@.str = private unnamed_addr constant [4 x i8] c"%x\0A\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: nounwind
define noalias %struct.Node* @create_node(i32 %key, %struct.RBNode* %l, %struct.RBNode* %r, %struct.RBNode* %p, i32 %color) #0 {
  %1 = tail call noalias i8* @malloc(i32 20) #1
  %2 = bitcast i8* %1 to %struct.Node*
  %3 = bitcast i8* %1 to i32*
  store i32 %key, i32* %3, align 4, !tbaa !1
  %4 = getelementptr inbounds i8, i8* %1, i32 4
  %5 = bitcast i8* %4 to %struct.RBNode**
  store %struct.RBNode* %l, %struct.RBNode** %5, align 4, !tbaa !7
  %6 = getelementptr inbounds i8, i8* %1, i32 8
  %7 = bitcast i8* %6 to %struct.RBNode**
  store %struct.RBNode* %r, %struct.RBNode** %7, align 4, !tbaa !8
  %8 = getelementptr inbounds i8, i8* %1, i32 12
  %9 = bitcast i8* %8 to %struct.RBNode**
  store %struct.RBNode* %p, %struct.RBNode** %9, align 4, !tbaa !9
  %10 = getelementptr inbounds i8, i8* %1, i32 16
  %11 = bitcast i8* %10 to i32*
  store i32 %color, i32* %11, align 4, !tbaa !10
  ret %struct.Node* %2
}

; Function Attrs: nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #1

; Function Attrs: nounwind
declare noalias i8* @malloc(i32) #0

; Function Attrs: nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #1

; Function Attrs: nounwind readonly
define i32 @color(%struct.RBNode* nocapture readonly %rbnode) #2 {
  %1 = getelementptr inbounds %struct.RBNode, %struct.RBNode* %rbnode, i32 0, i32 0
  %2 = load i32, i32* %1, align 4, !tbaa !11
  %cond = icmp eq i32 %2, 1
  br i1 %cond, label %3, label %8

; <label>:3                                       ; preds = %0
  %4 = getelementptr inbounds %struct.RBNode, %struct.RBNode* %rbnode, i32 0, i32 1
  %5 = load %struct.Node*, %struct.Node** %4, align 4, !tbaa !13
  %6 = getelementptr inbounds %struct.Node, %struct.Node* %5, i32 0, i32 4
  %7 = load i32, i32* %6, align 4, !tbaa !10
  br label %8

; <label>:8                                       ; preds = %0, %3
  %.0 = phi i32 [ %7, %3 ], [ 1, %0 ]
  ret i32 %.0
}

; Function Attrs: nounwind
define void @left_rotate(%struct.RBNode** nocapture %rootp, %struct.RBNode* %x) #0 {
  %1 = getelementptr inbounds %struct.RBNode, %struct.RBNode* %x, i32 0, i32 0
  %2 = load i32, i32* %1, align 4, !tbaa !11
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %59, label %4

; <label>:4                                       ; preds = %0
  %5 = load %struct.RBNode*, %struct.RBNode** %rootp, align 4, !tbaa !14
  %6 = getelementptr inbounds %struct.RBNode, %struct.RBNode* %5, i32 0, i32 0
  %7 = load i32, i32* %6, align 4, !tbaa !11
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %59, label %9

; <label>:9                                       ; preds = %4
  %10 = getelementptr inbounds %struct.RBNode, %struct.RBNode* %x, i32 0, i32 1
  %11 = load %struct.Node*, %struct.Node** %10, align 4, !tbaa !13
  %12 = getelementptr inbounds %struct.Node, %struct.Node* %11, i32 0, i32 2
  %13 = load %struct.RBNode*, %struct.RBNode** %12, align 4, !tbaa !8
  %14 = getelementptr inbounds %struct.RBNode, %struct.RBNode* %13, i32 0, i32 1
  %15 = load %struct.Node*, %struct.Node** %14, align 4, !tbaa !13
  %16 = getelementptr inbounds %struct.Node, %struct.Node* %15, i32 0, i32 1
  %17 = bitcast %struct.RBNode** %16 to i32*
  %18 = load i32, i32* %17, align 4, !tbaa !7
  %19 = bitcast %struct.RBNode** %12 to i32*
  store i32 %18, i32* %19, align 4, !tbaa !8

  %20 = load %struct.Node*, %struct.Node** %14, align 4, !tbaa !13
  %21 = getelementptr inbounds %struct.Node, %struct.Node* %20, i32 0, i32 1
  %22 = load %struct.RBNode*, %struct.RBNode** %21, align 4, !tbaa !7
  %23 = getelementptr inbounds %struct.RBNode, %struct.RBNode* %22, i32 0, i32 0
  %24 = load i32, i32* %23, align 4, !tbaa !11
  %25 = icmp eq i32 %24, 1
  br i1 %25, label %26, label %30

; <label>:26                                      ; preds = %9
  %27 = getelementptr inbounds %struct.RBNode, %struct.RBNode* %22, i32 0, i32 1
  %28 = load %struct.Node*, %struct.Node** %27, align 4, !tbaa !13
  %29 = getelementptr inbounds %struct.Node, %struct.Node* %28, i32 0, i32 3
  store %struct.RBNode* %x, %struct.RBNode** %29, align 4, !tbaa !9
  br label %30

; <label>:30                                      ; preds = %26, %9
  %31 = load %struct.Node*, %struct.Node** %10, align 4, !tbaa !13
  %32 = getelementptr inbounds %struct.Node, %struct.Node* %31, i32 0, i32 3
  %33 = bitcast %struct.RBNode** %32 to i32*
  %34 = load i32, i32* %33, align 4, !tbaa !9
  %35 = load %struct.Node*, %struct.Node** %14, align 4, !tbaa !13
  %36 = getelementptr inbounds %struct.Node, %struct.Node* %35, i32 0, i32 3
  %37 = bitcast %struct.RBNode** %36 to i32*
  store i32 %34, i32* %37, align 4, !tbaa !9
  %38 = load %struct.Node*, %struct.Node** %10, align 4, !tbaa !13
  %39 = getelementptr inbounds %struct.Node, %struct.Node* %38, i32 0, i32 3
  %40 = load %struct.RBNode*, %struct.RBNode** %39, align 4, !tbaa !9
  %41 = getelementptr inbounds %struct.RBNode, %struct.RBNode* %40, i32 0, i32 0
  %42 = load i32, i32* %41, align 4, !tbaa !11
  %43 = icmp eq i32 %42, 0
  br i1 %43, label %44, label %45

; <label>:44                                      ; preds = %30
  store %struct.RBNode* %13, %struct.RBNode** %rootp, align 4, !tbaa !14
  br label %54

; <label>:45                                      ; preds = %30
  %46 = getelementptr inbounds %struct.RBNode, %struct.RBNode* %40, i32 0, i32 1
  %47 = load %struct.Node*, %struct.Node** %46, align 4, !tbaa !13
  %48 = getelementptr inbounds %struct.Node, %struct.Node* %47, i32 0, i32 1
  %49 = load %struct.RBNode*, %struct.RBNode** %48, align 4, !tbaa !7
  %50 = icmp eq %struct.RBNode* %49, %x
  br i1 %50, label %51, label %52

; <label>:51                                      ; preds = %45
  store %struct.RBNode* %13, %struct.RBNode** %48, align 4, !tbaa !7
  br label %54

; <label>:52                                      ; preds = %45
  %53 = getelementptr inbounds %struct.Node, %struct.Node* %47, i32 0, i32 2
  store %struct.RBNode* %13, %struct.RBNode** %53, align 4, !tbaa !8
  br label %54

; <label>:54                                      ; preds = %51, %52, %44
  %55 = load %struct.Node*, %struct.Node** %14, align 4, !tbaa !13
  %56 = getelementptr inbounds %struct.Node, %struct.Node* %55, i32 0, i32 1
  store %struct.RBNode* %x, %struct.RBNode** %56, align 4, !tbaa !7
  %57 = load %struct.Node*, %struct.Node** %10, align 4, !tbaa !13
  %58 = getelementptr inbounds %struct.Node, %struct.Node* %57, i32 0, i32 3
  store %struct.RBNode* %13, %struct.RBNode** %58, align 4, !tbaa !9
  br label %59

; <label>:59                                      ; preds = %0, %4, %54
  ret void
}

; Function Attrs: nounwind
define void @right_rotate(%struct.RBNode** nocapture %rootp, %struct.RBNode* %x) #0 {
  %1 = getelementptr inbounds %struct.RBNode, %struct.RBNode* %x, i32 0, i32 0
  %2 = load i32, i32* %1, align 4, !tbaa !11
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %59, label %4

; <label>:4                                       ; preds = %0
  %5 = load %struct.RBNode*, %struct.RBNode** %rootp, align 4, !tbaa !14
  %6 = getelementptr inbounds %struct.RBNode, %struct.RBNode* %5, i32 0, i32 0
  %7 = load i32, i32* %6, align 4, !tbaa !11
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %9, label %59

; <label>:9                                       ; preds = %4
  %10 = getelementptr inbounds %struct.RBNode, %struct.RBNode* %x, i32 0, i32 1
  %11 = load %struct.Node*, %struct.Node** %10, align 4, !tbaa !13
  %12 = getelementptr inbounds %struct.Node, %struct.Node* %11, i32 0, i32 1
  %13 = load %struct.RBNode*, %struct.RBNode** %12, align 4, !tbaa !7
  %14 = getelementptr inbounds %struct.RBNode, %struct.RBNode* %13, i32 0, i32 1
  %15 = load %struct.Node*, %struct.Node** %14, align 4, !tbaa !13
  %16 = getelementptr inbounds %struct.Node, %struct.Node* %15, i32 0, i32 2
  %17 = bitcast %struct.RBNode** %16 to i32*
  %18 = load i32, i32* %17, align 4, !tbaa !8
  %19 = bitcast %struct.RBNode** %12 to i32*
  store i32 %18, i32* %19, align 4, !tbaa !7
  %20 = load %struct.Node*, %struct.Node** %10, align 4, !tbaa !13
  %21 = getelementptr inbounds %struct.Node, %struct.Node* %20, i32 0, i32 1
  %22 = load %struct.RBNode*, %struct.RBNode** %21, align 4, !tbaa !7
  %23 = getelementptr inbounds %struct.RBNode, %struct.RBNode* %22, i32 0, i32 0
  %24 = load i32, i32* %23, align 4, !tbaa !11
  %25 = icmp eq i32 %24, 1
  br i1 %25, label %26, label %30

; <label>:26                                      ; preds = %9
  %27 = getelementptr inbounds %struct.RBNode, %struct.RBNode* %22, i32 0, i32 1
  %28 = load %struct.Node*, %struct.Node** %27, align 4, !tbaa !13
  %29 = getelementptr inbounds %struct.Node, %struct.Node* %28, i32 0, i32 3
  store %struct.RBNode* %x, %struct.RBNode** %29, align 4, !tbaa !9
  br label %30

; <label>:30                                      ; preds = %26, %9
  %31 = load %struct.Node*, %struct.Node** %10, align 4, !tbaa !13
  %32 = getelementptr inbounds %struct.Node, %struct.Node* %31, i32 0, i32 3
  %33 = bitcast %struct.RBNode** %32 to i32*
  %34 = load i32, i32* %33, align 4, !tbaa !9
  %35 = load %struct.Node*, %struct.Node** %14, align 4, !tbaa !13
  %36 = getelementptr inbounds %struct.Node, %struct.Node* %35, i32 0, i32 3
  %37 = bitcast %struct.RBNode** %36 to i32*
  store i32 %34, i32* %37, align 4, !tbaa !9
  %38 = load %struct.Node*, %struct.Node** %10, align 4, !tbaa !13
  %39 = getelementptr inbounds %struct.Node, %struct.Node* %38, i32 0, i32 3
  %40 = load %struct.RBNode*, %struct.RBNode** %39, align 4, !tbaa !9
  %41 = getelementptr inbounds %struct.RBNode, %struct.RBNode* %40, i32 0, i32 0
  %42 = load i32, i32* %41, align 4, !tbaa !11
  %43 = icmp eq i32 %42, 0
  br i1 %43, label %44, label %45

; <label>:44                                      ; preds = %30
  store %struct.RBNode* %13, %struct.RBNode** %rootp, align 4, !tbaa !14
  br label %54

; <label>:45                                      ; preds = %30
  %46 = getelementptr inbounds %struct.RBNode, %struct.RBNode* %40, i32 0, i32 1
  %47 = load %struct.Node*, %struct.Node** %46, align 4, !tbaa !13
  %48 = getelementptr inbounds %struct.Node, %struct.Node* %47, i32 0, i32 1
  %49 = load %struct.RBNode*, %struct.RBNode** %48, align 4, !tbaa !7
  %50 = icmp eq %struct.RBNode* %49, %x
  br i1 %50, label %51, label %52

; <label>:51                                      ; preds = %45
  store %struct.RBNode* %13, %struct.RBNode** %48, align 4, !tbaa !7
  br label %54

; <label>:52                                      ; preds = %45
  %53 = getelementptr inbounds %struct.Node, %struct.Node* %47, i32 0, i32 2
  store %struct.RBNode* %13, %struct.RBNode** %53, align 4, !tbaa !8
  br label %54

; <label>:54                                      ; preds = %51, %52, %44
  %55 = load %struct.Node*, %struct.Node** %10, align 4, !tbaa !13
  %56 = getelementptr inbounds %struct.Node, %struct.Node* %55, i32 0, i32 3
  store %struct.RBNode* %13, %struct.RBNode** %56, align 4, !tbaa !9
  %57 = load %struct.Node*, %struct.Node** %14, align 4, !tbaa !13
  %58 = getelementptr inbounds %struct.Node, %struct.Node* %57, i32 0, i32 2
  store %struct.RBNode* %x, %struct.RBNode** %58, align 4, !tbaa !8
  br label %59

; <label>:59                                      ; preds = %4, %0, %54
  ret void
}

; Function Attrs: nounwind
define i32 @main() #0 {
  %node = alloca %struct.RBNode, align 4
  %1 = bitcast %struct.RBNode* %node to i8*
  call void @llvm.lifetime.start(i64 8, i8* %1) #1
  %2 = getelementptr inbounds %struct.RBNode, %struct.RBNode* %node, i32 0, i32 0
  store i32 1, i32* %2, align 4, !tbaa !11
  %3 = getelementptr inbounds %struct.RBNode, %struct.RBNode* %node, i32 0, i32 1
  %4 = tail call %struct.Node* @create_node(i32 33, %struct.RBNode* null, %struct.RBNode* null, %struct.RBNode* null, i32 1)
  store %struct.Node* %4, %struct.Node** %3, align 4, !tbaa !13
  %5 = ptrtoint %struct.RBNode* %node to i32
  %6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 %5) #1
  %7 = load i32, i32* %2, align 4, !tbaa !11
  %8 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0), i32 %7) #1
  call void @llvm.lifetime.end(i64 8, i8* %1) #1
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @printf(i8* nocapture readonly, ...) #0

attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }
attributes #2 = { nounwind readonly "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"Debian clang version 3.7.1-svn253742-1~exp1 (branches/release_37) (based on LLVM 3.7.1)"}
!1 = !{!2, !3, i64 0}
!2 = !{!"Node", !3, i64 0, !6, i64 4, !6, i64 8, !6, i64 12, !4, i64 16}
!3 = !{!"int", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = !{!"any pointer", !4, i64 0}
!7 = !{!2, !6, i64 4}
!8 = !{!2, !6, i64 8}
!9 = !{!2, !6, i64 12}
!10 = !{!2, !4, i64 16}
!11 = !{!12, !4, i64 0}
!12 = !{!"RBNode", !4, i64 0, !6, i64 4}
!13 = !{!12, !6, i64 4}
!14 = !{!6, !6, i64 0}
