## Overview

Slice is not restricting the size like array, but slice s a reference to an array

```
var s []int
```

the value of empty slice is not `[0]` but `nil`

### Create slice from array

a := [5]int{1,2,3,4,5}

s := a[2:4]  -> array index 2 to 3

if we change value of a[2], a[3] it will change the value of slice

### capacity of slice

cap(slice) -> show capacity of the array it points to


### struct

slice is a struct

```
type slice struct {
    zerothElement *type //first element of the array that slices point to
    len int //length of slice
    cap int //cap of slice
}
```

&a[2] = pointer value which is a memory point -> 0xcsadwdw



### append

```
func append(slice []Type, elems ...Type) []Type
```

append will create a new slice with its own len and cap

but it will mutate the original array

so, we should use `s = append(s, ...)` to assign new slice back to old slice to prevent mistakes

### append more than original capacity

Go will automatically create new array and copy old slice to it


### Annonymous slice

```
 s := []int{1,2,3,4,5,6}
```

Go creates hidden array underneath, and if we append 2 new elements, Go will expand array to 12 as double of original 6

### Copy Slice

```
func copy(dst []Type, src []Type) int
```


### make

make is a built-in function to create empty slice

```
func make(t Type, size ...IntegerType) Type
```

```
s := make([]type, len, cap)

s1 := make([]int, 2, 4)
```

### Pass by value

When we pass slice into the function, we will pass its value which is a pointer to underlying array

so, modification of slice in another function will cause change in a hidden array

### Delete slice element

delete element is joining 2 slices of behind and ahead of that element

```
s := []int{1,2,3,4,5,6,7,8,9}
// delete element at index 2
s =  append(s[:2], s[3:]) 
```

### Compare

we need to iterate through its range to compare

== only works for comparing slice with nil
