{ config, dawn, lib, pkgs, ... }:

let
  inherit (lib) getExe mkEnableOption mkIf;
  inherit (config.dawn) fish;
  inherit (dawn) userName;
in {
  options.dawn.fish.enable = mkEnableOption "Enables fish + starship";

  config = mkIf fish.enable {
    users.users.${userName}.shell = pkgs.fish;
    programs = {
      fish = {
        enable = true;
        shellAliases = {
          ls = "${getExe pkgs.eza} -l";
          ga = "git add .";
          gc = "git commit -m";
          gp = "git push";
          gs = "git status";
        };

        interactiveShellInit = ''
          set fish_greeting
          function starship_transient_prompt_func
            ${getExe pkgs.starship} module character
          end

          function .
            nix shell nixpkgs#$argv[1]
          end

          function nix-switch
            nh os switch
          end

          function nix-update
            nh os switch -u
          end

          function fish_command_not_found
            echo Did not find command: $argv[1]
          end

          enable_transience
        '';
      };

      starship = {
        enable = true;
        settings = {
          add_newline = false;
          directory.disabled = false;
          character = {
            disabled = false;
            success_symbol = "[λ](bold purple)";
            error_symbol = "[λ](bold red)";
          };
        };
      };
    };
  };
}
