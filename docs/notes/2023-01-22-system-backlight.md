# Notes for 22th of January, 2023

Following a system upgrade two days ago, my HP Pavillion laptop has stopped
registering the `intel_backlight` interface in `/sys/class/backlight`, which
is most often used to control backlight by tools such as `brightnessctl.`
Inspecting `dmesg` has given me nothing but aninsanely vague error message.
Only mentioning it is not being loaded (_very helpful, thanks!_)

After some research, on Google as every other confused Linux user, I have
come across [this article](https://www.linuxquestions.org/questions/slackware-14/brightness-keys-not-working-after-updating-to-kernel-version-6-a-4175720728/)
which mentions backlight behaviour has changed sometime after kernel 6.1.4.
Fortunately for me, the article also refers to the the ever so informative
ArchWiki, which instructs passing one of the [three kernel command-line options](https://wiki.archlinux.org/title/backlight#Kernel_command-line_options).
depending on our needs.

As I have upgraded from 6.1.3 to 6.1.6 with a flake update, the `acpi_backlight=none`
parameter has made it so that it would skip loading intel backlight entirely. Simply switching
this parameter to `acpi_backlight=native` as per the article above has fixed the issue.
