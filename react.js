<ScrollingTable
  width="123"
  style="blue"
  scrollTop={props.offsetTop}>
</ScrollingTable>
//    |
//    v
<OuterScroller scrollTop={props.offsetTop}>
  <InnerScrol width="123" style="red"></InnerScrol>
</OuterScroller>
//
// as result - OuterScroller doesn't care about `width/style`
// separate of concerns


