{ inputs, user, ... }: {
  home-manager.users.${user} = {
    imports = [ inputs.zen-browser.homeModules.default ];

    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
      profiles.default = {
        isDefault = true;
        userChrome = builtins.readFile ./userChrome.css;
        search = {
          default = "google";
          force = true;
        };
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.toolbars.bookmarks.visibility" = "always";
          "zen.tabs.vertical.right-side" = true;
          "zen.view.grey-out-inactive-windows" = false;
        };
      };
    };
  };
}
