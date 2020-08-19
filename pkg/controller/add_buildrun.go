package controller

import (
	"github.com/shipwright-io/build/pkg/controller/buildrun"
)

func init() {
	// AddToManagerFuncs is a list of functions to create controllers and add them to a manager.
	AddToManagerFuncs = append(AddToManagerFuncs, buildrun.Add)
}
