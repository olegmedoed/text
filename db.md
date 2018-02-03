# 1

## DB nomalization levels

### 1 level
1. Unique rows.
2. Unique cols
3. Every cell has only one value.
### 2 level
1. `Primary key` (it can be composed of several columns, in such case it's called - composed)
2. If `primary key` is composed, then all other cols should be uniquelly determined by **whole**
  `primary key`
### 3 level
1. Must not have `transaction dependencies`

------------------------------------------------------------------------------
