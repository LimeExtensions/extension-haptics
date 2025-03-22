## extension-haptics

![](https://img.shields.io/github/repo-size/MAJigsaw77/extension-haptics) ![](https://badgen.net/github/open-issues/MAJigsaw77/extension-haptics) ![](https://badgen.net/badge/license/MIT/green)

A Haxe/[Lime](https://lime.openfl.org) extension that implements Haptic Feedback effects on Android and iOS Devices.

### Installation

You can install it through `Haxelib`
```bash
haxelib install extension-haptics
```
Or through `Git`, if you want the latest updates
```bash
haxelib git extension-haptics https://github.com/MAJigsaw77/extension-haptics.git
```

## Usage

```haxe
import extension.haptics.Haptic;

// Initialize the haptic system
Haptic.initialize();

// Trigger a oneshot vibration
Haptic.vibrateOneShot(0.5, 0.75); // 0.5 seconds duration, 75% intensity

// Trigger a pattern vibration
Haptic.vibratePattern([0.2, 0.4, 0.2], [1.0, 0.5, 0.8]); // Durations and amplitudes

// Dispose of the haptic system
Haptic.dispose();
```

## Licensing

**extension-haptics** is made available under the **MIT License**. Check [LICENSE](./LICENSE) for more information.
