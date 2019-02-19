`KeyboardTracker.swift` tracks the keyboard position (supporting the `interactive` keyboard dismissal for UICollectionViews).

- When the keyboard is dismissed during a scroll the console prints:

```
-[UIWindow endDisablingInterfaceAutorotationAnimated:] called on <UITextEffectsWindow: 0x10c025e00; frame = (0 0; 375 667); opaque = NO; autoresize = W+H; layer = <UIWindowLayer: 0x1c4223e80>> without matching -beginDisablingInterfaceAutorotation. Ignoring.
```

- Once the keyboard is dismissed while the UICollectionView continues to scroll, there is a small UI glitch (a slight slowdown in scrolling)