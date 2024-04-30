FROM golang:latest

WORKDIR /iqj

COPY . .

RUN go mod download
RUN go build /iqj/app/main.go

CMD ["./main"]
