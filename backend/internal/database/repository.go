package database

type Authorization interface {
	Add(u *User) error
	GetById(u *User) (*User, error)
	Check(u *User) (*User, error)
	Delete(u *User) error
}

type NewsRepo interface {
	Add(u *News) error
	GetById(u *News) (*News, error)
	Check(u *News) (*News, error)
	Delete(u *News) error
}

type AdvertisementRepo interface {
	Add(u *Advertisement) error
	GetById(u *Advertisement) (*Advertisement, error)
	Delete(u *Advertisement) error
}

type Schedule interface {
}

type Repository struct {
	Authorization
	NewsRepo
	AdvertisementRepo
	Schedule
}

func NewRepository() *Repository {
	return &Repository{
		//Authorization: NewAuthPostgres(),
		//NewsRepo: ,
		//AdvertisementRepo: ,
		//Schedule: ,
	}
}
