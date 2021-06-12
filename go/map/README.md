## Overview

map is an array with string or other type as key instead of integer

```
{
  stringKey: intValue,
  stringKey: intValue
  ...
}
```

### Declare a map

```
var theMap map[keyType]valueType

...

var phoneBook map[string]int

```


print value of phoneBook will show `map[]`
and phoneBook is equal to `nil`

map cannot hold data the same as struct.

it references internal data structure.


### Create an empty map

```
use make

m := make(map[keyType]valueType)

age := make(map[string]int)

age["por"] = 27
```

or 

```

age := map[string]int{
    "a" : 5,
    "b" : 6,
}

```

### accessing value

we can get to the value by mapName["key"]

and if the key does not exist, it will return zero value of the value type


### length

len(map) also works

### delete is easy 

```
func delete(m map[Type]Type1, key Type)
```


### compare

use DeepEqual function (https://golang.org/pkg/reflect/).

### iterate

```
for key, value := range map {

}
```

### Reference

Maps are reference type


### Copy

use for loop to copy a map