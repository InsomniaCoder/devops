## Overview

Use `&variableName` to get memory address of the pointer

memory number is hexadecimal (base 16)

### Declaration

```
var pointer *int
var p *Type  (type that this pointer points to)
```

pointer is of Type -> *int and value is `nil`

```

a := 1

var p *int

p = &a

```

Print pa = 0xxxxxxx

### Dereference (get the value)

```
a := 1

p := &a

fmt.Println("%v", *pa) //1

```

we can also change value at pointer 

```
*pa = 2  //write value 2 to the memory location of pa. so, it replaces new value
```

### New function
```
func new(Type) *Type
```

allocates memory and returns a pointer to that memory

pa := new(int) //allocate some memory, write a zero-value of the Type at that memory location and return a pointer to that memory location.



