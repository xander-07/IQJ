package db_utils

import (
	"golang.org/x/exp/constraints"
)

func ConvertIntegerSlice[T constraints.Integer, U constraints.Integer](input []T) []U {
    output := make([]U, len(input))
    for i, v := range input {
        output[i] = U(v)
    }
    return output
}
