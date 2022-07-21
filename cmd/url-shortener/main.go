package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"

	"github.com/go-chi/chi"
	"github.com/vfunin/url-shortener/internal/infrastructure/server"
)

func main() {
	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt)

	h := chi.NewRouter()

	FileServer(h)

	srv := server.NewServer(":80", h)

	srv.Start()
	log.Print("Start")

	<-ctx.Done()

	log.Print("Stop")
	srv.Stop()
	cancel()
}

func FileServer(router *chi.Mux) {
	root := "./web/dist"
	fs := http.FileServer(http.Dir(root))

	router.Get("/*", func(w http.ResponseWriter, r *http.Request) {
		if _, err := os.Stat(root + r.RequestURI); os.IsNotExist(err) {
			http.StripPrefix(r.RequestURI, fs).ServeHTTP(w, r)
		} else {
			fs.ServeHTTP(w, r)
		}
	})
}
