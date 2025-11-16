{
  inputs,
  config,
  pkgs,
  ...
}: {
  programs.chromium = {
    enable = true;
    # extensions = [ ];
  };

  home.file.".mozilla/firefox/personal/chrome" = {
    source = "${inputs.potatofox}/chrome";
    recursive = true;
  };

  # home.file.".mozilla/firefox/personal/chrome/userChrome.css" = {
  #   text = ''
  #     #TabsToolbar{ visibility: collapse !important }
  #     #sidebar-header { display: none !important }
  #   '';
  # };

  programs.firefox = {
    enable = true;

    package = pkgs.firefox-bin;

    profiles.school = {
      name = "school";
      id = 1;
      search.force = true;
      search.default = "google";
    };

    profiles.personal = {
      name = "personal";
      id = 0;

      isDefault = true;

      search.force = true;
      search.default = "ddg";
      search.engines = {
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@np"];
        };

        "NixOS Wiki" = {
          urls = [{template = "https://wiki.nixos.org/index.php?search={searchTerms}";}];
          icon = "https://wiki.nixos.org/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = ["@nw"];
        };

        "bing".metaData.hidden = true;
        "google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
      };

      settings = {
        "browser.startup.homepage" = "about:home";


        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "layout.css.has-selector.enabled" = true;


        "browser.urlbar.suggest.calculator" = true;
        "browser.urlbar.unitConversion.enabled" = true;
        "browser.urlbar.trimHttps" = true;
        "browser.urlbar.trimURLs" = true;
        "browser.profiles.enabled" = true;

        "widget.gtk.rounded-bottom-corners.enabled" = true;
        "browser.compactmode.show" = true;
        # "widget.gtk.ignore-bogus-leave-notify" = 1;
        "browser.tabs.allow_transparent_browser" = true;
        "browser.uidensity" = 1;

        "browser.aboutConfig.showWarning" = false;

        # Disable irritating first-run stuff
        "browser.disableResetPrompt" = true;
        "browser.download.panel.shown" = true;
        "browser.feeds.showFirstRunUI" = false;
        "browser.messaging-system.whatsNewPanel.enabled" = false;
        "browser.rights.3.shown" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.uitour.enabled" = false;
        "startup.homepage_override_url" = "";
        "trailhead.firstrun.didSeeAboutWelcome" = true;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.bookmarks.addedImportButton" = true;

        # Don't ask for download dir
        "browser.download.useDownloadDir" = false;

        # Disable crappy home activity stream page
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;

        "browser.newtabpage.activity-stream.feeds.system.topsites" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;

        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.showWeather" = false;
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
        # "browser.newtabpage.blocked" = lib.genAttrs [
        #   # Youtube
        #   "26UbzFJ7qT9/4DhodHKA1Q=="
        #   # Facebook
        #   "4gPpjkxgZzXPVtuEoAL9Ig=="
        #   # Wikipedia
        #   "eV8/WsSLxHadrTL1gAxhug=="
        #   # Reddit
        #   "gLv0ja2RYVgxKdp0I5qwvA=="
        #   # Amazon
        #   "K00ILysCaEq8+bEqV/3nuw=="
        #   # Twitter
        #   "T9nJot5PurhJSy8n038xGA=="
        # ] (_: 1);

        # Disable some telemetry
        "app.shield.optoutstudies.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.sessions.current.clean" = true;
        "devtools.onboarding.telemetry.logged" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.prompted" = 2;
        "toolkit.telemetry.rejected" = true;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.unifiedIsOptIn" = false;
        "toolkit.telemetry.updatePing.enabled" = false;

        # Disable fx accounts
        "identity.fxaccounts.enabled" = false;
        # Disable "save password" prompt
        "signon.rememberSignons" = false;
        # Harden
        # "privacy.trackingprotection.enabled" = true;
        # "dom.security.https_only_mode" = true;
        # Layout
      };
    };
  };
}
