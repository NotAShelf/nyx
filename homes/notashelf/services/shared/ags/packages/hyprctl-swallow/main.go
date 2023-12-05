package main

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"strings"
)

type SwallowStatus struct {
	Status string `json:"status"`
}

func main() {
	hyprctl := "hyprctl"
	notifySend := "notify-send"

	if len(os.Args) > 1 && os.Args[1] == "query" {
		getSwallowStatus(hyprctl)
		return
	}

	cmd := exec.Command(hyprctl, "getoption", "misc:enable_swallow")
	output, err := cmd.Output()
	if err != nil {
		fmt.Println(err)
		return
	}

	if strings.Contains(string(output), "int: 1") {
		switchSwallowStatus(hyprctl, notifySend, false)
	} else {
		switchSwallowStatus(hyprctl, notifySend, true)
	}
}

func getSwallowStatus(hyprctl string) {
	cmd := exec.Command(hyprctl, "getoption", "misc:enable_swallow")
	output, err := cmd.Output()
	if err != nil {
		fmt.Println(err)
		return
	}

	var status string
	if strings.Contains(string(output), "int: 1") {
		status = "off"
	} else {
		status = "on"
	}

	swallow := SwallowStatus{Status: status}
	jsonData, err := json.Marshal(swallow)
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println(string(jsonData))
}

func switchSwallowStatus(hyprctl, notifySend string, enable bool) {
	var statusMsg string
	var keyword string

	if enable {
		statusMsg = "Turned on swallowing"
		keyword = "true"
	} else {
		statusMsg = "Turned off swallowing"
		keyword = "false"
	}

	cmd := exec.Command(hyprctl, "keyword", "misc:enable_swallow", keyword)
	_, err := cmd.Output()
	if err != nil {
		fmt.Println(err)
		return
	}

	cmd = exec.Command(notifySend, "Hyprland", statusMsg)
	_, err = cmd.Output()
	if err != nil {
		fmt.Println(err)
		return
	}
}
