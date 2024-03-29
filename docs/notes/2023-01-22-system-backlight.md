# Notes for 22th of January, 2023

Since two days ago, my laptop has not been registering `intel_backlight` in
`/sys/class/backlight` with a very vague error message, only mentioning it is not
being loaded (thanks!)

After some research, I have found [this article](https://www.linuxquestions.org/questions/slackware-14/brightness-keys-not-working-after-updating-to-kernel-version-6-a-4175720728/)
that mentions backlight behaviour has changed sometime after kernel 6.1.4 and that
the ever so informative ArchWiki instructs passing one of the [three kernel command-line options](https://wiki.archlinux.org/title/backlight#Kernel_command-line_options).

As I have upgraded from 6.1.3 to 6.1.6 with a flake update, the `acpi_backlight=none`
parameter has made it so that it would skip loading intel backlight entirely. Simply switching
this parameter to `acpi_backlight=native` as per the article above has fixed the issue.

The commit [5c0d478](https://github.com/NotAShelf/dotfiles/commit/5c0d478bfb2078252ce92b6cf819c3ad9306d628),
along other kernel parameters, changes this parameter and fixes the issue. I do not know at this time
if this is an intel specific issue, or if it applies to AMD CPUs as well.
