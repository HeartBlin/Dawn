{ config, dawn, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.generators) toJSON;
  inherit (config.dawn) vscode;
  inherit (dawn) userName hostName;
  inherit (builtins) fetchTarball;

  vscode-insiders = (pkgs.vscode.override { isInsiders = true; }).overrideAttrs(x: {
    version = "latest";
    buildInputs = x.buildInputs ++ [ pkgs.krb5 ];
    src = (fetchTarball {
      url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
      sha256 = "15m54f4vswv57ywfspwa0lgd81n35kkrqwq2rvp0mp3s6br7nnm6";
    });
  });

  vscodeExtended = pkgs.vscode-with-extensions.override {
    vscode = vscode-insiders;
    vscodeExtensions = with pkgs.vscode-extensions; [
      pkief.material-icon-theme
      jnoortheen.nix-ide
    ];
  };

  settings = toJSON { } {
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

    # Explorer
    "explorer.compactFolders" = false;
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;

    # Nix
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nixd";
    "nix.serverSettings"."nixd" = {
      "formatting"."command" = [ "nixfmt" ];
      "options"."nixos"."expr" = "(builtins.getFlake \"/home/${userName}/Documents/Dawan\").nixosConfigurations.${hostName}.options";
    };

    # Workbench
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.layoutControl.enabled" = false;
    "workbench.colorTheme" = "Default Dark+";
    "workbench.sideBar.location" = "left";
    "workbench.startupEditor" = "none";

    # Telemetry
    "telemetry.telemetryLevel" = "off";

    # Windw
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

    # Fix homix'es inability to handle space in filenames
    system.userActivationScripts.linkVSCodeInsiders.text = ''
      TARGET="/home/${userName}/.config/Code - Insiders/User/settings.json"
      SOURCE="/home/${userName}/.config/Code/User/settings.json"

      mkdir -p "$(dirname "$TARGET")"
      rm -f "$TARGET" || true
      ln -sf "$SOURCE" "$TARGET"
    '';
  };
}
