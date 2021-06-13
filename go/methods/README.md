## Overview

A method is a function that belongs to certain type

### Declaration

it needs receiver // types that function belongs to

```
func (r Type ) functionType(...Type) ReturnType {

}
```


### Pointer Receiver

normally, receiver recieves copy of that type.

change struct will not change original object

we need to use 

```
func (r *Type) functionType(...Type) ReturnType {
    (*r).data = newData
}

ep := &e

ep.ChangeName()
```

but Go helps reduce, so wa can

```
define method with r *Type

and when use we can just use

struct.Method

Go will automatically convert struct to *struct
```