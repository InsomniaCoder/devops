## Declaration

```
var a [3]int

fmt.Println(a) -> [0 0 0] because we have not assigned a value
```

## Initial Value

```
var a [3]int = [3]int{1, 2, 3}

var a = [3]int{1, 2, 3}

a := [3]int{1, 2, 3}
```

only for array with initial value, we can shorthand the length like this

```

a := [...]string{
    "a",
    "b",
}
```

## Len

len is a built-in function that is used to calculate the length of many data types

`len(array)`

## Compare

for array a to be equal to b

a and b must be the same array type and same size and all element must be the same with correct order

## iteration

```
for i:=0; i< len(array); i++ {

}
```

use range to loop

```
for index,value := range a {

}
```

we can ignore range in loop by

```
for _ , value := range a {

}
```

## Multi dimensional

```
 a := [2][2]int{
     [2]int{1,2},
     [2]int{4,5},
 }
```

or

```
 a := [3][2]int{{1,2},{2,4},{3,6}}
```

## Pass by value

when pass array to function, it will be passed by value

it means it will send a copy version of array