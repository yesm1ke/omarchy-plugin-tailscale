# Tailscale for the Omarchy bar, hidden in the tray drawer

The stock Omarchy Tailscale widget, unchanged, except that its bar icon hides
together with the system tray drawer: it stays collapsed until you hover the
tray's `‹` chevron, then slides out next to the tray icons.

Nothing of the stock widget is copied. `Panel.qml` imports the packaged
`omarchy.tailscale` panel from `/usr/share/omarchy` and only overrides the
size of its bar icon, so every Omarchy update to the Tailscale widget applies
here as is.

## Install

```sh
omarchy plugin add https://github.com/yesm1ke/omarchy-plugin-tailscale --enable
omarchy bar move io.github.yesm1ke.tailscale --after omarchy.tray
omarchy plugin disable omarchy.tailscale   # the stock widget it replaces
```

Requires Omarchy 4 with Tailscale set up (`omarchy install service tailscale`).

## Behaviour

- Hover the tray chevron: the drawer opens and the icon slides out with it.
- While the pointer is on the icon, or its panel is open, the drawer stays
  open; move away and everything collapses with the tray's own animation.
- Other widgets that use the same helper (the ZeroTier and Bluetooth plugins
  from the same author) form one group with it; place them all right after
  `omarchy.tray`.
- Opening the panel by keybinding or IPC reveals the icon as well. The IPC
  target keeps the stock name: `omarchy-shell omarchy.tailscale toggle`.

## Settings

| Setting | Default | |
|---|---|---|
| `hideWithTray` | `true` | `false` keeps the icon always visible |
| `refreshIntervalSec` | `30` | passed through to the stock widget |

```sh
omarchy bar set io.github.yesm1ke.tailscale hideWithTray false --json
```

## How it works

`TrayFollower.qml` finds the `omarchy.tray` widget among its sibling bar slots
and mirrors the tray's `expanded` state. That relies on bar internals
(`ModuleSlot.moduleName` / `activeItem` / `hovered`, `Tray.expanded`); if a
future Omarchy changes them, the helper cannot find the tray and the icon
simply stays visible. The wrapper also relies on the stock panel living at
`/usr/share/omarchy/shell/plugins/panels/tailscale/`.

## License

MIT, see [LICENSE](LICENSE).
