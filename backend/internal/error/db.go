package error

import "fmt"

type AppError struct {
	StatusCode int
	Code       int    `json:"error_code"`
	Message    string `json:"error_message"`
}

func (err AppError) Error() string {
	return fmt.Sprintf("err #%d: %s", err.Code, err.Message)
}
