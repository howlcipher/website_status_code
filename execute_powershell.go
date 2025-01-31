package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
)

// can be built into an exe using "go run <filename>.go"

func main() {
	// Run PowerShell script
	err := runPowerShellScript("status_code.ps1")
	if err != nil {
		log.Fatal(err)
	}
}

func runPowerShellScript(scriptPath string) error {
	// Read configuration.json file
	configPath := ".\\configuration.json"
	cmd := exec.Command("powershell", "-ExecutionPolicy", "Bypass", "-File", scriptPath)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	// Set environment variable for PowerShell script to access the configuration.json file
	env := os.Environ()
	env = append(env, fmt.Sprintf("CONFIG_JSON=%s", configPath))
	cmd.Env = env

	// Execute PowerShell script
	err := cmd.Run()
	if err != nil {
		return fmt.Errorf("failed to execute PowerShell script: %w", err)
	}

	return nil
}
