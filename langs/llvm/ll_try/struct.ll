;struct { char a, int b[10][20], char c }
%struct.RT = type { i8, [10 x [20 x i32]], i8}
%struct.ST = type { i32, double, %struct.RT }

define i32* @foo(%struct.ST* %s) nounwind uwtable optsize ssp {
entry:
  %array
}
