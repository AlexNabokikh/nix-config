{ ... }:
{
  # Manage swaync service via Home-manager
  services.swaync = {
    enable = true;
    settings = {
      control-center-height = 800;
      control-center-width = 400;
      fit-to-screen = false;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      notification-grouping = false;
      notification-icon-size = 32;
      notification-window-width = 350;
    };
    style = ''
      * {
        all: unset;
        font-size: 14px;
        font-family: "Roboto Nerd Font";
        transition: 200ms;
      }

      trough highlight {
        background: #cad3f5;
      }

      scale {
        margin: 0 7px;
      }

      scale trough {
        margin: 0rem 1rem;
        min-height: 8px;
        min-width: 70px;
        background-color: #363a4f;
        border-radius: 8px;
      }

      trough slider {
        margin: -10px;
        border-radius: 8px;
        box-shadow: 0 0 2px rgba(0, 0, 0, 0.8);
        transition: all 0.2s ease;
        background-color: #8aadf4;
      }

      trough slider:hover {
        box-shadow:
          0 0 2px rgba(0, 0, 0, 0.8),
          0 0 8px #8aadf4;
      }

      trough {
        background-color: #363a4f;
      }

      /* notifications */
      .notification-background {
        box-shadow:
          0 0 8px 0 rgba(0, 0, 0, 0.8),
          inset 0 0 0 1px #363a4f;
        border-radius: 8px;
        margin: 18px;
        background-color: #24273a;
        color: #cad3f5;
        padding: 0;
      }

      .notification-background .notification {
        padding: 7px;
        border-radius: 8px;
      }

      .notification-background .notification.critical {
        box-shadow: inset 0 0 7px 0 #ed8796;
      }

      .notification .notification-content {
        margin: 7px;
      }

      .notification .notification-content overlay {
        /* icons */
        margin: 4px;
      }

      .notification-content .summary {
        color: #cad3f5;
      }

      .notification-content .time {
        color: #a5adcb;
      }

      .notification-content .body {
        color: #cad3f5;
      }

      .notification > *:last-child > * {
        min-height: 3.4em;
      }

      .notification .notification-action {
        border-radius: 8px;
        color: #cad3f5;
        box-shadow: inset 0 0 0 1px #494d64;
        margin: 4px;
        padding: 8px;
        font-size: 0.2rem;
      }

      .notification .notification-action:hover {
        box-shadow: inset 0 0 0 1px #494d64;
        background-color: #363a4f;
        color: #cad3f5;
      }

      .notification .notification-action:active {
        box-shadow: inset 0 0 0 1px #494d64;
        background-color: #7dc4e4;
        color: #cad3f5;
      }

      .notification-background .close-button {
        margin: 7px;
        padding: 2px;
        border-radius: 8px;
        color: #24273a;
        background-color: #ed8796;
      }

      .notification-background .close-button:hover {
        background-color: #ee99a0;
        color: #24273a;
      }

      .notification-background .close-button:active {
        background-color: #ed8796;
        color: #24273a;
      }

      /* progress colors */
      .notification.critical progress {
        background-color: #ed8796;
      }

      .notification.low progress,
      .notification.normal progress {
        background-color: #8aadf4;
      }

      .notification progress,
      .notification trough,
      .notification progressbar {
        border-radius: 8px;
        padding: 3px 0;
      }

      /* control center */
      .control-center {
        box-shadow:
          0 0 8px 0 rgba(0, 0, 0, 0.8),
          inset 0 0 0 1px #363a4f;
        border-radius: 8px;
        margin: 18px;
        background-color: #24273a;
        color: #cad3f5;
        padding: 14px;
      }

      .control-center .notification-background {
        border-radius: 8px;
        color: #cad3f5;
        background-color: #363a4f;
        box-shadow: inset 0 0 0 1px #494d64;
        margin: 14px 0 0 0;
      }

      .control-center .notification-background .notification {
        padding: 7px;
        border-radius: 8px;
      }

      .control-center .notification-background:hover {
        box-shadow: inset 0 0 0 1px #494d64;
        background-color: #8087a2;
        color: #cad3f5;
      }

      .control-center .notification-background:active {
        box-shadow: inset 0 0 0 1px #494d64;
        background-color: #7dc4e4;
        color: #cad3f5;
      }

      .control-center .notification .notification-action {
        border-radius: 8px;
        color: #cad3f5;
        background-color: #181926;
        box-shadow: inset 0 0 0 1px #494d64;
        margin: 4px;
        padding: 8px;
        font-size: 0.2rem;
      }

      .control-center .notification .notification-action:hover {
        box-shadow: inset 0 0 0 1px #494d64;
        background-color: #363a4f;
        color: #cad3f5;
      }

      .control-center .notification .notification-action:active {
        box-shadow: inset 0 0 0 1px #494d64;
        background-color: #7dc4e4;
        color: #cad3f5;
      }

      .control-center .notification-background .close-button {
        margin: 7px;
        padding: 2px;
        border-radius: 8px;
        color: #24273a;
        background-color: #ee99a0;
      }

      .control-center .notification-background .close-button:hover {
        background-color: #ed8796;
        color: #24273a;
      }

      .control-center .notification-background .close-button:active {
        background-color: #ed8796;
        color: #24273a;
      }

      .control-center .notification-background .notification.low {
        opacity: 1;
      }

      .control-center .widget-title > label {
        color: #cad3f5;
        font-size: 1.3em;
      }

      .control-center .widget-title button {
        border-radius: 8px;
        color: #cad3f5;
        background-color: #363a4f;
        box-shadow: inset 0 0 0 1px #494d64;
        padding: 8px;
      }

      .control-center .widget-title button:hover {
        box-shadow: inset 0 0 0 1px #494d64;
        background-color: #5b6078;
        color: #cad3f5;
      }

      .control-center .widget-title button:active {
        box-shadow: inset 0 0 0 1px #494d64;
        background-color: #7dc4e4;
        color: #24273a;
      }

      .control-center .notification-group {
        margin-top: 10px;
      }

      scrollbar slider {
        margin: -3px;
        opacity: 0.8;
      }

      scrollbar trough {
        margin: 2px 0;
      }

      /* dnd */
      .widget-dnd {
        margin-top: 5px;
        border-radius: 8px;
        font-size: 1.1rem;
      }

      .widget-dnd > switch {
        font-size: initial;
        border-radius: 8px;
        background: #363a4f;
        box-shadow: none;
      }

      .widget-dnd > switch:checked {
        background: #8aadf4;
      }

      .widget-dnd > switch slider {
        background: #494d64;
        border-radius: 8px;
        border: 1px solid #6e738d;
      }

      /* mpris */
      .widget-mpris-player {
        background: #363a4f;
        border-radius: 8px;
        color: #cdd6f4;
        padding: 7px;
      }

      .mpris-overlay {
        background-color: #363a4f;
        opacity: 0.9;
        padding: 15px 10px;
      }

      .widget-mpris-album-art {
        -gtk-icon-size: 100px;
        border-radius: 8px;
        margin: 0 10px;
      }

      .widget-mpris-title {
        font-size: 1.2rem;
        color: #cad3f5;
      }

      .widget-mpris-subtitle {
        font-size: 0.8rem;
        color: #b8c0e0;
      }

      .widget-mpris button {
        border-radius: 8px;
        color: #cad3f5;
        margin: 0 5px;
        padding: 2px;
      }

      .widget-mpris button image {
        -gtk-icon-size: 1.8rem;
      }

      .widget-mpris button:hover {
        background-color: #363a4f;
      }

      .widget-mpris button:active {
        background-color: #494d64;
      }

      .widget-mpris button:disabled {
        opacity: 0.5;
      }

      .widget-menubar > box > .menu-button-bar > button > label {
        font-size: 3rem;
        padding: 0.5rem 2rem;
      }

      .widget-menubar > box > .menu-button-bar > :last-child {
        color: #ed8796;
      }

      .power-buttons button:hover,
      .powermode-buttons button:hover,
      .screenshot-buttons button:hover {
        background: #363a4f;
      }

      .control-center .widget-label > label {
        color: #cad3f5;
        font-size: 2rem;
      }

      .widget-buttons-grid {
        padding-top: 1rem;
      }

      .widget-buttons-grid > flowbox > flowboxchild > button label {
        font-size: 2.5rem;
      }

      .widget-volume {
        padding-top: 1rem;
      }

      .widget-volume label {
        font-size: 1.5rem;
        color: #7dc4e4;
      }

      .widget-volume trough highlight {
        background: #7dc4e4;
      }

      .widget-backlight trough highlight {
        background: #eed49f;
      }

      .widget-backlight scale {
        margin-right: 1rem;
      }

      .widget-backlight label {
        font-size: 1.5rem;
        color: #eed49f;
      }

      .widget-backlight .KB {
        padding-bottom: 1rem;
      }

      .image {
        padding-right: 0.5rem;
      }
    '';
  };
}
