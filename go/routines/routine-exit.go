package main

import (
	"fmt"
	"time"
)

func main() {

	go func() {
		for i := 0; i < 10; i++ {
			fmt.Println("test")
			time.Sleep(2 * time.Second)
		}
	}()

	fmt.Println("test")

}
