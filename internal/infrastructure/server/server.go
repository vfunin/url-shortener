package server

import (
	"context"
	"log"
	"net/http"
	"time"
)

type Server struct {
	srv http.Server
}

const defaultTimeout = 30
const defaultTimeoutMin = 2

func NewServer(addr string, h http.Handler) *Server {
	s := &Server{}

	s.srv = http.Server{
		Addr:              addr,
		Handler:           h,
		ReadTimeout:       defaultTimeout * time.Second,
		WriteTimeout:      defaultTimeout * time.Second,
		ReadHeaderTimeout: defaultTimeout * time.Second,
	}

	return s
}

func (s *Server) Stop() {
	ctx, cancel := context.WithTimeout(context.Background(), defaultTimeoutMin*time.Second)
	err := s.srv.Shutdown(ctx)

	if err != nil {
		log.Fatal(err)
	}

	cancel()
}

func (s *Server) Start() {
	go func() {
		err := s.srv.ListenAndServe()
		if err != nil {
			log.Fatal(err)
		}
	}()
}
