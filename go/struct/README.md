## Overview
```
type StructName struct {
    field1 fieldType1
    field2 fieldType2
}
```

```

type Employee struct {
	firstName string
	lastName string
	salary int
	fullTime bool
}
```

### Create new struct

```
var emp1 Employee
fmt.Println(emp1) // { 0 false}  string zero-value is ""
```

set value
```
emp1.firstName = "sss"
```

initialize

```

emp2 := Employee{
    firstName: "name1",
    lastName: "lastname1",
}

or 

emp3 := Employee{"name1", "lastname1", 1200, true}

```


### Anonymous struct

```
anonymous := struct {
    firstName string
}{
    firstName : "name1"
}
```

### Pointer to a struct

```
s := &StructType{...}
```

```
shorthand
ross := &Employee {
    firstName: "ross",
    lastName:  "Bing",
    salary:    1200,
    fullTime:  true,
}
fmt.Println("firstName", ross.firstName) // ross is a pointer
```
instead of 
```
(*ross).firstName
```

### Nested Struct

```
type Employee struct {
	firstName string
	lastName string
	salary Salary
	fullTime bool
}

type Salary struct {
    basic int,
    allowace int
}

emp := Employee{
    firstName : "Por",
    salary : Salary{10000,500}
}

```

### Exported Fields

use Capital Letter for fields that we want to export

### Functions

Struct field type can also be function

### Compare

same struct type and value = true

### Metadata

used for encode / decode

```
type Employee struct {
	firstName string `json:"firstName"`
	lastName  string `json:"lastName"`
	salary    int    `json: "salary"`
	fullTime  int    `json: "fullTime"`
}
```