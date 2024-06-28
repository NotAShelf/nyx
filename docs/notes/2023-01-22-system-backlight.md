# System Backlight

## The Problem

Following a large system upgrade two days ago, my HP Pavilion laptop has stopped
registering the `intel_backlight` device interface in `/sys/class/backlight` -
which is most often used by tools such as `brightnessctl` or `light` to control
active backlight level. Instinctively looking at the result of `dmesg`, I came
across an insanely vague error message that the kernel was unable to load some
modules. Thanks, I guess?

## The solution

After some _extensive_ research, obviously on Google as every other confused
Linux user would do, I came across
[this article](https://www.linuxquestions.org/questions/slackware-14/brightness-keys-not-working-after-updating-to-kernel-version-6-a-4175720728/)
that mentioned a change in backlight behaviour sometime after kernel version
6.1.4. Fortunately for me, the article was also referring to the ever so
informative Archwiki that instructed passing one of the
[three kernel command-line options](https://wiki.archlinux.org/title/backlight#Kernel_command-line_options)
depending on our needs.

What I did not know at the time was that when I upgraded my kernel from `6.1.3`
to `6.1.6` with a `nix flake update`, the `acpi_backlight=none` parameter had
made it so that it would skip loading intel backlight _entirely_. Simply
switching this parameter to `acpi_backlight=native` as per the article above has
fixed the issue.

## Lessons learned

Linux devs are nerds.
