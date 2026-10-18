# Tailscale for the Omarchy bar, hidden in the tray drawer

[![Ko-fi](https://img.shields.io/badge/Ko--fi-support-FF5E5B?logo=ko-fi&logoColor=white)](https://ko-fi.com/mike_g)

The stock Omarchy Tailscale widget, unchanged, except that its bar icon hides
together with the system tray drawer: it stays collapsed until you hover the
tray's `‹` chevron, then slides out next to the tray icons.

## Install

```sh
omarchy plugin add https://github.com/yesm1ke/omarchy-plugin-tailscale --enable
omarchy bar move io.github.yesm1ke.tailscale --after omarchy.tray   # or io.github.yesm1ke.tray
omarchy plugin disable omarchy.tailscale   # the stock widget it replaces
```

Requires Omarchy 4 with Tailscale set up (`omarchy install service tailscale`).

## Behaviour

- Hover the tray chevron: the drawer opens and the icon slides out with it.
- While the pointer is on the icon, or its panel is open, the drawer stays
  open; move away and everything collapses with the tray's own animation.
- Other widgets that use the same helper (the ZeroTier and Bluetooth plugins
  from the same author) form one group with it; place them all right after
  the tray.
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

## Staying current with Omarchy

This is a copy of the stock widget with the change above on top. Until Omarchy
4.0.5 it was a wrapper that imported the packaged `omarchy.tailscale` panel from `/usr/share/omarchy`
and copied nothing, but with Qt 6.12 such an import no longer works when the
stock file declares inline components (`component Foo: …`; the widget fails to
load with "Foo is not a type"), so it became a copy. The repository keeps
Omarchy's files and ours apart:

- branch `upstream` holds the stock files exactly as Omarchy ships them, one
  commit per Omarchy version that changed them;
- branch `main` is `upstream` plus the change described above (`Panel.qml`, marked `io.github.yesm1ke`, around the root's size).

To stay current, update the plugin as usual:

```sh
omarchy plugin update
```

Omarchy's changes to the stock widget reach you that way: they are merged
here and published after each Omarchy release that changes it. The copy
follows the latest Omarchy release; on an older Omarchy, update Omarchy
first if the widget fails to load. Don't run
`./sync-upstream` in an installed copy: it commits locally, and after that
`omarchy plugin update` can no longer fast-forward. It is the maintainer's
tool (or yours, in a fork): it records the installed stock files on
`upstream` and merges them into `main`; on a conflict it aborts the merge and
leaves everything as it was, to be resolved with `git merge upstream`;
`./sync-upstream --check` only reports whether anything changed.

## How it works

`TrayFollower.qml` finds the tray (`io.github.yesm1ke.tray` or the stock
`omarchy.tray`) among its sibling bar slots
and mirrors the tray's `expanded` state. That relies on bar internals
(`ModuleSlot.moduleName` / `activeItem` / `hovered`, `Tray.expanded`); if a
future Omarchy changes them, the helper cannot find the tray and the icon
simply stays visible.

The stock `omarchy.tray` hides itself, chevron included, while no app has a
tray icon; the icon then has nothing to reveal it and stays visible. Use
[omarchy-plugin-tray](https://github.com/yesm1ke/omarchy-plugin-tray) in
place of `omarchy.tray` to keep the chevron in that case.

## License

MIT, see [LICENSE](LICENSE). Based on the Omarchy Tailscale panel, © David
Heinemeier Hansson, MIT.
