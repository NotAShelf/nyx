import { App, Widget } from "../imports.js";
const { Box, Revealer, Window } = Widget;

export default ({ name, child, transition = "slide_up", ...props }) => {
    const window = Window({
        name,
        visible: false,
        ...props,

        child: Box({
            css: `min-height: 1px;
                  min-width: 1px;
                  padding: 1px;`,
            child: Revealer({
                transition,
                transitionDuration: 300,
                connections: [
                    [
                        App,
                        (self, currentName, visible) => {
                            if (currentName === name)
                                self.reveal_child = visible;
                        },
                    ],
                ],
                child: child,
            }),
        }),
    });
    window.getChild = () => child;
    return window;
};
