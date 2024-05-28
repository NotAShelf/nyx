import { Widget } from "../../../imports";
const { Label, Button } = Widget;

import { toggleSwallowStatus, status } from "../../../utils/swallow";

export const Swallow = () =>
	Button({
		className: "swallow",
		cursor: "pointer",
		tooltipText: `Swallow: ${status.value}`,
		onPrimaryClick: toggleSwallowStatus,
		child: Label({
			label: "󰊰",
		}),
	}).hook(status, (self) => (self.tooltipText = `${status.value}`));
