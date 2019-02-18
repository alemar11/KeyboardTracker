iOS Keyboard position tracker.

`KeyboardTracker.swift` tracks the position of the keyboard to position a view on top of it, supporting also the `interactive` keyboard dismissal for UICollectionViews.


When the keyboard is dismissed during a scroll the console prints:

```
-[UIWindow endDisablingInterfaceAutorotationAnimated:] called on <UITextEffectsWindow: 0x10c025e00; frame = (0 0; 375 667); opaque = NO; autoresize = W+H; layer = <UIWindowLayer: 0x1c4223e80>> without matching -beginDisablingInterfaceAutorotation. Ignoring.
```