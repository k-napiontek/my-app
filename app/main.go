package main

import (
	"log"
	"net/http"

	"my-app/handlers"
	"my-app/middleware"

	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func main() {
	mux := http.NewServeMux()
	log.Println("Working....d")
	// Metrics middleware - liczy requesty, latency, status codes
	mux.Handle("/", middleware.Metrics(http.HandlerFunc(handlers.Home)))
	mux.Handle("/health", middleware.Metrics(http.HandlerFunc(handlers.Health)))
	mux.Handle("/api/hello", middleware.Metrics(http.HandlerFunc(handlers.Hello)))

	// Endpoint Prometheus - bez middleware (unikamy duplikacji)
	mux.Handle("/metrics", promhttp.Handler())

	log.Println("Server starting on :8080")
	log.Fatal(http.ListenAndServe(":8080", mux))
}