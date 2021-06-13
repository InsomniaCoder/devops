## Overview

An interface is a collection of method signatures that a Type can implement (using methods). Hence interface defines (not declares) the behavior of the object (of the type Type).


### you do not explicitly mention if a type implements an interface

### Declaring

```
type Shape interface {
    Area() float64

}


type Rect struct {
    width float64
    height float64
}

//implement

func (r Rect) Area() float64{
    return r.width * r.height
}


func main(){
    var s Shape
    s = Rect{5.0, 4.0} // type = Rect, value = {5.0, 4.0}
    r := Rect{5.0, 4.0}

    s.Area() // return 20


}
```


### Polymorphism

```

type Object interface{
  Volume() float64
}

type Shape interface{
  Area() float64
}

type Cube struct {
    side float64
}

func (c Cube) Area() float64{
    return c.side * c.side
}

func (c Cube) Volume() float64{
    return c.side * c.side * c.side
}

func main(){
    c := Cube{3}
    var s Shape = c
    var o Object = c
}
```

