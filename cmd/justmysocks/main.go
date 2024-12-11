package main

import (
	"bytes"
	"context"
	"encoding/base64"
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
	"os"
	"text/template"
	"time"
)

func main() {
	log.SetOutput(os.Stderr)

	if len(os.Args) != 2 {
		log.Fatalf("Usage: go run ./cmd/justmysocks <url>")
	}
	url := os.Args[1]
	log.Println("Subscription url", url)

	data := must(getDataFrom(url))
	decoded := must(base64Decode(data))
	rawConfigs := bytes.Split(decoded, []byte{'\n'})

	log.Printf("Get %d configs\n%s\n", len(rawConfigs), string(decoded))
	var proxies []string
	var servers []string
	for _, rawConfig := range rawConfigs {
		config := must(parseConfig(rawConfig))
		proxies = append(proxies, config.ToYAML())
		servers = append(servers, config.ServerName())
	}

	t := template.Must(template.ParseFiles("./justmysocks.yaml.tmpl"))
	err := t.Execute(os.Stdout, map[string][]string{
		"proxies": proxies,
		"servers": servers,
	})
	if err != nil {
		panic(err)
	}
}

func getDataFrom(rawURL string) ([]byte, error) {
	u, err := url.Parse(rawURL)
	if err != nil {
		return nil, fmt.Errorf("Parse url %s failed: %w", rawURL, err)
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	req := http.Request{
		Method: http.MethodGet,
		URL:    u,
	}
	res, err := http.DefaultClient.Do(req.WithContext(ctx))
	if err != nil {
		return nil, fmt.Errorf("Get request %s failed: %w", rawURL, err)
	}
	defer res.Body.Close()

	return io.ReadAll(res.Body)
}

func base64Decode(data []byte) ([]byte, error) {
	src := make([]byte, len(data))
	copy(src, data)

	// make sure its padded!
	for len(src)%4 != 0 {
		src = append(src, '=')
	}

	dst := make([]byte, base64.StdEncoding.DecodedLen(len(src)))
	n, err := base64.StdEncoding.Decode(dst, src)
	if err != nil {
		return nil, fmt.Errorf("Base64 decode failed: %w", err)
	}

	return dst[:n], nil
}

func must[T any](r T, err error) T {
	if err != nil {
		panic(err)
	}
	return r
}
