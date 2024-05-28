import { App, Widget, Utils } from "../imports";
const { Box, Revealer, Window } = Widget;

export default ({
    onOpen = () => {},
    onClose = () => {},

    name,
    child,
    transition = "slide_up",
    transitionDuration = 250,
    ...props
}) => {
    const window = Window({
        name,
        visible: false,
        ...props,

        child: Box({
            css: `
            min-height: 2px;
            min-width: 2px;
            `,
            child: Revealer({
                transition,
                transitionDuration,
                child: child || Box(),
                setup: (self) => {
                    self.hook(App, (rev, currentName, isOpen) => {
                        if (currentName === name) {
                            rev.revealChild = isOpen;

                            if (isOpen) {
                                onOpen(window);
                            } else {
                                Utils.timeout(transitionDuration, () => {
                                    onClose(window);
                                });
                            }
                        }
                    });
                },
            }),
        }),
    });
    window.getChild = () => window.child.children[0].child;
    window.setChild = (newChild) => {
        window.child.children[0].child = newChild;
        window.child.children[0].show_all();
    };

    return window;
};
