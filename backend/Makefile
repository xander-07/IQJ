# Название исполняемого файла
BINARY_NAME := iqj_bin

# Путь к пакету
PKG := cmd/app/main.go

# Опции компиляции
LDFLAGS := -ldflags "-s -w"

# Основной таргет для сборки и запуска
all: build run

# Таргет для сборки
build:
	go build $(LDFLAGS) -o $(BINARY_NAME) $(PKG)

# Таргет для запуска
run:
	./$(BINARY_NAME)
