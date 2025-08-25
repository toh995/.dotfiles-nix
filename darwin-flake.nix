{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Homebrew
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    vimari = {
      url = "github:vladdoster/homebrew-formulae";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    vimari,
  }: let
    configuration = {pkgs, ...}: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [
        pkgs.vim
      ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
    customSystemConfig = {
      system = {
        primaryUser = "toh995";
        startup.chime = true;
        keyboard = {
          enableKeyMapping = true;
          swapLeftCommandAndLeftAlt = true;
        };
        defaults = {
          universalaccess.reduceMotion = true;
          ".GlobalPreferences"."com.apple.mouse.scaling" = 15.0; # Sets the mouse tracking speed
          controlcenter.Bluetooth = true; # Show a bluetooth control in menu bar
          NSGlobalDomain = {
            AppleInterfaceStyle = "Dark";
            KeyRepeat = 2;
            InitialKeyRepeat = 15;
            "com.apple.swipescrolldirection" = false; # Sets the mouse scroll direction
            # Disable animations
            NSAutomaticWindowAnimationsEnabled = false; # Whether to animate opening and closing of windows and popovers
            NSScrollAnimationEnabled = false; # Whether to enable smooth scrolling
            NSWindowResizeTime = 0.001; # Sets the speed speed of window resizing
            # Disable a bunch of auto-correct behavior
            NSAutomaticSpellingCorrectionEnabled = false; # Disable auto-correct
            NSAutomaticCapitalizationEnabled = false; # Disable automatic capitalization
            NSAutomaticDashSubstitutionEnabled = false;
            NSAutomaticPeriodSubstitutionEnabled = false;
            NSAutomaticQuoteSubstitutionEnabled = false;
          };
          dock = {
            autohide = true;
            autohide-delay = 0.0; # Sets the speed of the autohide delay
            autohide-time-modifier = 0.0; # Sets the speed of animation when hiding/showing the Dock
            expose-animation-duration = 0.0; # Sets the speed of the Mission Control animations
            mineffect = "scale"; # Set the animation for minimize/maximize windows
            show-recents = false;
            persistent-apps = [
              {app = "/Applications/Safari.app";}
              {app = "/Applications/Alacritty.app";}
            ];
          };
          CustomUserPreferences = {
            "com.apple.Spotlight".MenuItemHidden = 1;
            "com.apple.dock" = {
              # launchpad animations
              springboard-show-duration = 0.0;
              springboard-hide-duration = 0.0;
              springboard-page-duration = 0.0;
            };
            "com.apple.safari" = {
              AutoFillCreditCardData = 0;
              AutoFillFromAddressBook = 0;
              AutoFillMiscellaneousForms = 0;
              AutoFillPasswords = 0;
              UseHTTPSOnly = 1;
              HideStartPageRecentlyClosedTabsEmptyItemView = 0;
              AlwaysRestoreSessionAtLaunch = 1;
              ExcludePrivateWindowWhenRestoringSessionAtLaunch = 0;
              OpenPrivateWindowWhenNotRestoringSessionAtLaunch = 0;
            };
          };
        };
      };
      security.sudo.extraConfig = ''
        Defaults passwd_timeout=0
        Defaults timestamp_timeout=30
      '';
    };
    packageConfig = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        # nix
        alejandra # formatter
        nil # language server
      ];
      homebrew = {
        enable = true;
        onActivation.cleanup = "uninstall";
        casks = [
          "alacritty"
          # "displaylink"
          "elecom-mouse-util"
          "font-dejavu-sans-mono-nerd-font"
          "keepassxc"
          "rectangle"
          "vladdoster/formulae/vimari"
        ];
        brews = [
          "btop"
          "eza"
          "fzf"
          "git-delta"
          "lazygit"
          "mpv"
          "neofetch"
          "neovim"
          "ripgrep"
          "spotify_player"
          "tealdeer"
          "tmux"
          "trash"
          "zoxide"
          # Neovim dependencies
          "tree-sitter-cli"
          "volta"
          #
        ];
      };
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#toh995s-Mac-mini
    darwinConfigurations."toh995s-Mac-mini" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        customSystemConfig
        packageConfig
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "toh995";
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "vladdoster/homebrew-formulae" = vimari;
            };
            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            mutableTaps = false;
          };
        }
        # Optional: Align homebrew taps config with nix-homebrew
        ({config, ...}: {
          homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
        })
      ];
    };
  };
}
