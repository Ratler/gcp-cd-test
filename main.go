package main

import (
	"io"
	"net/http"
)

func hello(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "This is production worthy, running v1.2")
}

func healthcheck(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "OK")
}

func main() {
	http.HandleFunc("/", hello)
	http.HandleFunc("/healthcheck", healthcheck)
	http.ListenAndServe(":8080", nil)
}
