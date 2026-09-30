import QtQuick
import qs.Commons
import "file:///usr/share/omarchy/shell/plugins/panels/tailscale" as Stock

// The stock Tailscale widget, unmodified, plus hiding with the system tray
// drawer. Nothing is copied: Stock.Panel is the packaged omarchy.tailscale
// panel, so Omarchy updates to it apply here automatically. This file only
// overrides the bar extent of the root item.
Stock.Panel {
  id: wrapper

  property alias trayFollower: follower
  readonly property bool barVertical: bar ? bar.vertical === true : false

  // The stock root sizes itself from its bar button; find that button among
  // the children rather than hardcoding the slot size.
  readonly property var barButton: {
    var kids = wrapper.children
    for (var i = 0; i < kids.length; i++)
      if (kids[i] && kids[i].slotSize !== undefined) return kids[i]
    return null
  }
  readonly property real naturalWidth: barButton ? barButton.implicitWidth : Style.bar.iconSlot
  readonly property real naturalHeight: barButton ? barButton.implicitHeight : Style.bar.iconSlot

  clip: true
  implicitWidth: barVertical ? naturalWidth : Math.round(naturalWidth * follower.reveal)
  implicitHeight: barVertical ? Math.round(naturalHeight * follower.reveal) : naturalHeight

  TrayFollower {
    id: follower
    active: wrapper.setting("hideWithTray", true) !== false
    extraHold: wrapper.opened
  }
}
