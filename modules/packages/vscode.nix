{ config, dawn, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (builtins) toJSON;
  inherit (config.dawn) vscode;
  inherit (dawn) flakePath hostName userName;

  vscodeExtended = pkgs.vscode-with-extensions.override {
    vscodeExtensions = with pkgs.vscode-extensions; [
      aaron-bond.better-comments
      jnoortheen.nix-ide
      pkief.material-icon-theme
      github.copilot
      github.copilot-chat
    ];
  };

  settings = toJSON {
    # Editor
    "editor.guides.bracketPairs" = "active";
    "editor.bracketPairColorization.enabled" = true;
    "editor.minimap.enabled" = false;
    "editor.cursorBlinking" = "smooth";
    "editor.cursorSmoothCaretAnimation" = "on";
    "editor.smoothScrolling" = true;
    "editor.lineHeight" = 22;
    "editor.letterSpacing" = 0.5;
    "editor.renderWhitespace" = "all";
    "editor.trimAutoWhitespace" = true;
    "editor.fontFamily" = "Cascadia Code";

    # Explorer
    "explorer.compactFolders" = false;
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;

    # Nix
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nixd";
    "nix.serverSettings"."nixd" = {
      "formatting"."command" = [ "nixfmt" ];
      "options"."nixos"."expr" = "(builtins.getFlake \"${flakePath}\").nixosConfigurations.${hostName}.options";
    };

    # Workbench
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.layoutControl.enabled" = false;
    "workbench.colorTheme" = "Default Dark+";
    "workbench.sideBar.location" = "left";
    "workbench.startupEditor" = "none";

    # Telemetry
    "telemetry.telemetryLevel" = "off";

    # Terminal
    "terminal.integrated.fontFamily" = "monospace";

    # Window
    "window.experimentalControlOverlay" = false;
    "window.dialogStyle" = "custom";
    "window.menuBarVisibility" = "toggle";
    "window.titleBarStyle" = "custom";
  };
in {
  options.dawn.vscode.enable = mkEnableOption "Enables VSCode";
  
  config = mkIf vscode.enable {
    users.users.${userName}.packages = with pkgs; [ nixd nixfmt-classic statix vscodeExtended ];
    homix.".config/Code/User/settings.json".text = settings;
  };
}
