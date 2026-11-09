{ user, ... }: {
  homebrew = {
    casks = [ "marta" ];
  };

  home-manager.users.${user} = {
    home.file."Library/Application Support/org.yanex.marta/conf.marco".text = ''
      behavior {
          theme "Dark"

          table {
              verticalPadding 10
              useAlternateColor false
              iconSize 20
          }
      }

      fonts {
          actionBar [ "Default" 17 ]
          breadcrumbs [ "Default" 17 ]
          virtualTabs [ "Default Bold" 17 ]
          files [ "Default" 17 ]
          statusBar [ "Default Light" 15 ]
          tableHeader [ "Default" 15 ]
          tabs [ "Default" 17 ]
          preferences [ "Monaco" 15 ]
      }
    '';
  };
}
