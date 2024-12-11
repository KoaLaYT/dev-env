package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"strconv"
	"strings"
)

type config interface {
	ServerName() string
	ToYAML() string
}

type ssConfig struct {
	Name     string
	Port     int
	Server   string
	UDP      bool
	Password string
	Cipher   string
}

func (c *ssConfig) ServerName() string {
	return c.Name
}

func (c *ssConfig) ToYAML() string {
	var sb strings.Builder
	sb.WriteString("name: ")
	sb.WriteString(c.Name)
	sb.WriteByte('\n')

	sb.WriteString("    port: ")
	sb.WriteString(fmt.Sprintf("%d", c.Port))
	sb.WriteByte('\n')

	sb.WriteString("    server: ")
	sb.WriteString(c.Server)
	sb.WriteByte('\n')

	sb.WriteString("    type: ss\n")

	sb.WriteString("    udp: ")
	sb.WriteString(fmt.Sprintf("%v", c.UDP))
	sb.WriteByte('\n')

	sb.WriteString("    password: ")
	sb.WriteString(c.Password)
	sb.WriteByte('\n')

	sb.WriteString("    cipher: ")
	sb.WriteString(c.Cipher)
	sb.WriteByte('\n')
	return sb.String()
}

func parseSsConfig(data []byte) (*ssConfig, error) {
	i := bytes.IndexByte(data, '#')
	if i == -1 {
		return nil, fmt.Errorf("Bad ss config %s, cannot find symbol `#`", string(data))
	}
	name := string(data[i+1:])
	decoded, err := base64Decode(data[:i])
	if err != nil {
		return nil, fmt.Errorf("Bad ss config %s, cannot base64 decode first part: %w", string(data), err)
	}

	i = bytes.IndexByte(decoded, ':')
	if i == -1 {
		return nil, fmt.Errorf("Bad ss config %s, cannot find first symbol `:`", string(decoded))
	}
	cipher := string(decoded[:i])
	decoded = decoded[i+1:]

	i = bytes.IndexByte(decoded, '@')
	if i == -1 {
		return nil, fmt.Errorf("Bad ss config %s, cannot find symbol `@`", string(decoded))
	}
	password := string(decoded[:i])
	decoded = decoded[i+1:]

	i = bytes.IndexByte(decoded, ':')
	if i == -1 {
		return nil, fmt.Errorf("Bad ss config %s, cannot find second symbol `:`", string(decoded))
	}
	server := string(decoded[:i])
	port, err := strconv.Atoi(string(decoded[i+1:]))
	if err != nil {
		return nil, fmt.Errorf("Bad ss config %s, cannot parse port: %w", string(decoded[i+1:]), err)
	}

	return &ssConfig{
		Name:     name,
		Port:     port,
		Server:   server,
		UDP:      true,
		Password: password,
		Cipher:   cipher,
	}, nil
}

type rawVmessConfig struct {
	PS   string `json:"ps"`
	Port string `json:"port"`
	ID   string `json:"id"`
	AID  int    `json:"aid"`
	Net  string `json:"net"`
	Type string `json:"type"`
	TLS  string `json:"tls"`
	Add  string `json:"add"`
}

type vmessConfig struct {
	Name           string
	Port           int
	Server         string
	Network        string
	TLS            bool
	UDP            bool
	SkipCertVerify bool
	Cipher         string
	UUID           string
	AlterId        int
}

func (c *vmessConfig) ServerName() string {
	return c.Name
}

func (c *vmessConfig) ToYAML() string {
	var sb strings.Builder
	sb.WriteString("name: ")
	sb.WriteString(c.Name)
	sb.WriteByte('\n')

	sb.WriteString("    port: ")
	sb.WriteString(fmt.Sprintf("%d", c.Port))
	sb.WriteByte('\n')

	sb.WriteString("    server: ")
	sb.WriteString(c.Server)
	sb.WriteByte('\n')

	sb.WriteString("    type: vmess\n")

	sb.WriteString("    network: ")
	sb.WriteString(c.Network)
	sb.WriteByte('\n')

	sb.WriteString("    tls: ")
	sb.WriteString(fmt.Sprintf("%v", c.TLS))
	sb.WriteByte('\n')

	sb.WriteString("    udp: ")
	sb.WriteString(fmt.Sprintf("%v", c.UDP))
	sb.WriteByte('\n')

	sb.WriteString("    skip-cert-verify: ")
	sb.WriteString(fmt.Sprintf("%v", c.SkipCertVerify))
	sb.WriteByte('\n')

	sb.WriteString("    cipher: ")
	sb.WriteString(c.Cipher)
	sb.WriteByte('\n')

	sb.WriteString("    uuid: ")
	sb.WriteString(c.UUID)
	sb.WriteByte('\n')

	sb.WriteString("    alterId: ")
	sb.WriteString(fmt.Sprintf("%d", c.AlterId))
	sb.WriteByte('\n')

	return sb.String()
}

func parseVmessConfig(data []byte) (*vmessConfig, error) {
	decoded, err := base64Decode(data)
	if err != nil {
		return nil, fmt.Errorf("Bad vmess config %s, cannot base64 decode: %w", string(data), err)
	}

	var raw rawVmessConfig
	err = json.Unmarshal(decoded, &raw)
	if err != nil {
		return nil, fmt.Errorf("Bad vmess config %s, cannot json decode: %w", string(decoded), err)
	}

	port, err := strconv.Atoi(raw.Port)
	if err != nil {
		return nil, fmt.Errorf("Bad vmess config %s, cannot parse port: %w", string(decoded), err)
	}

	return &vmessConfig{
		Name:           raw.PS,
		Port:           port,
		Server:         raw.Add,
		Network:        raw.Net,
		TLS:            raw.TLS != "none",
		UDP:            true,
		SkipCertVerify: true,
		Cipher:         "auto",
		UUID:           raw.ID,
		AlterId:        raw.AID,
	}, nil
}

func parseConfig(data []byte) (config, error) {
	if bytes.HasPrefix(data, []byte("ss://")) {
		return parseSsConfig(data[5:])
	}

	if bytes.HasPrefix(data, []byte("vmess://")) {
		return parseVmessConfig(data[8:])
	}

	return nil, fmt.Errorf("Unknown config type: %s", string(data))
}
