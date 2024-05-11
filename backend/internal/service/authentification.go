package service

import (
	database "iqj/internal/database"
)

type AuthService struct {
	repo database.Authorization
}

func NewAuthService(repo database.Authorization) *AuthService {
	return &AuthService{repo: repo}
}

func (s *AuthService) Add(u *database.User) error {
	return nil
}

func (s *AuthService) GetById(u *database.User) (*database.User, error) {
	return u, nil
}

func (s *AuthService) Check(u *database.User) (*database.User, error) {
	return u, nil
}

func (s *AuthService) Delete(u *database.User) error {
	return nil
}
