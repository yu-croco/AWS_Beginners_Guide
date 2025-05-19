package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
)

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}

func handler(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path == "/hello-nodejs-app" {
		fmt.Println("Accessing nodejs-app...")
		fmt.Println("endpoint: " + os.Getenv("NODEJS_APP_ENDPOINT"))

		resp, err := http.Get("http://" + os.Getenv("NODEJS_APP_ENDPOINT") + "/hello")
		if err != nil {
			http.Error(w, "Error making request to nodejs-app", http.StatusInternalServerError)
			return
		}
		defer resp.Body.Close()

		body, err := io.ReadAll(resp.Body)
		if err != nil {
			http.Error(w, "Error reading response", http.StatusInternalServerError)
			return
		}

		// Write the response back to the client
		w.Write(body)
		return
	}

	fmt.Fprintf(w, "Hello World from Golang")
}
