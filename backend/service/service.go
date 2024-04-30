package service

import "iqj/database"

type Authorization interface {
	Add(u *database.User) error
	GetById(u *database.User) (*database.User, error)
	Check(u *database.User) (*database.User, error)
	Delete(u *database.User) error
}

type News interface {
	Add(u *database.News) error
	GetById(u *database.News) (*database.News, error)
	Check(u *database.News) (*database.News, error)
	Delete(u *database.News) error
}

type Advertisement interface {
	Add(u *database.Advertisement) error
	GetById(u *database.Advertisement) (*database.Advertisement, error)
	Delete(u *database.Advertisement) error
}

type Schedule interface {
}

type Service struct {
	Authorization
	News
	Advertisement
	Schedule
}

func NewService(repository *database.Repository) *Service {
	return &Service{
		Authorization: NewAuthService(repository.Authorization),
		//News: ,
		//Advertisement: ,
		//Schedule:
	}
}
