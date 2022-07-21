FROM golang:latest AS build

WORKDIR /app

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -tags netgo -ldflags '-w -extldflags "-static"' -o ./main ./cmd/url-shortener


FROM node:16-alpine as web

WORKDIR /app

COPY web .

RUN npm install
RUN npm run build


FROM scratch

WORKDIR /app

COPY --from=build /app/main /app/main
COPY --from=web /app/dist /app/web/dist
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /usr/share/zoneinfo /usr/share/zoneinfo
ENV TZ=Europe/Moscow

EXPOSE 80

CMD ["./main"]
