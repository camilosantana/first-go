/*
from parent README.md ...

Add code to `./check-pr-comment-status/main.go`

- is PR `mergeable`
  - yes continue
  - no comment/instruct and `os.Exit(73)`
- is PR `approved`
  - yes continue
  - no comment/instruct and `os.Exit(73)`
- is comment `terraform apply`
  - yes `os.Exit(0)`
  - no comment/instruct and `os.Exit(73)`
*/
package main

import (
	"fmt"
)

func main() {
	fmt.Println("placeholder")
}
