package main

import (
	"fmt"
	"os/exec"
	"strings"
)

func main() {
	hyprctl := "hyprctl"
	notifySend := "notify-send"

	cmd := exec.Command(hyprctl, "getoption", "misc:enable_swallow")
	output, err := cmd.Output()
	if err != nil {
		fmt.Println(err)
		return
	}

	if strings.Contains(string(output), "int: 1") {
		cmd := exec.Command(hyprctl, "keyword", "misc:enable_swallow", "false")
		_, err := cmd.Output()
		if err != nil {
			fmt.Println(err)
			return
		}

		cmd = exec.Command(notifySend, "Hyprland", "Turned off swallowing")
		_, err = cmd.Output()
		if err != nil {
			fmt.Println(err)
			return
		}
	} else {
		cmd := exec.Command(hyprctl, "keyword", "misc:enable_swallow", "true")
		_, err := cmd.Output()
		if err != nil {
			fmt.Println(err)
			return
		}

		cmd = exec.Command(notifySend, "Hyprland", "Turned on swallowing")
		_, err = cmd.Output()
		if err != nil {
			fmt.Println(err)
			return
		}
	}
}

