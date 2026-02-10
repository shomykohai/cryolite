{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  # The Zen Browser flake I use since ditching HM doesn't provide a custom program like
  # the previous one, but instead only provides a minimal wrapped package, and un unwrapped one.
  #
  # So, let's just wrap it ourselves. Cool, innit?
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox inputs.zen-browser.packages.${pkgs.system}.zen-browser-unwrapped {
      pname = "zen-browser";
      # https://mozilla.github.io/policy-templates/
      extraPolicies = {
        DisableAppUpdate = true;
        DisableTelemetry = true;
        ShowHomeButton = true;
        HardwareAcceleration = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        DisableFirefoxScreenshots = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        BlockAboutSupport = true;
        DisableProfileRefresh = true;
        DisableSecurityBypass = {
          InvalidCertificate = true;
          SafeBrowsing = true;
        };
        DisableSetDesktopBackground = true;
        DisablePasswordReveal = true;
        DisableMasterPasswordCreation = true;
        DisableFormHistory = true;
        DisableFeedbackCommands = true;
        DisableSafeMode = true;
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        Homepage = {
          URL = "https://www.startpage.com/";
          Locked = true;
        };

        DisableEncryptedClientHello = true;
        SSLVersionMax = "tls1.3";
        HttpsOnlyMode = "force_enabled";
        DNSOverHTTPS = {
          Enabled = true;
        };
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        Cookies = {
          Behavior = "reject-tracker-and-partition-foreign";
          Locked = true;
          AllowSession = [
            "https://www.startpage.com"
            "https://youtube.com"
            "https://github.com"
            "https://protonmail.com"
            "https://google.com"
            "https://gitlab.com"
            "https://proton.me"
            "https://godotengine.org/"
            "https://nixos.org"
          ];
        };

        # To get GUID -> https://addons.mozilla.org/api/v5/addons/addon/<addon-slug>/
        ExtensionSettings = {
          "*".installation_mode = "blocked";
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "firefox@tampermonkey.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/tampermonkey/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "{74145f27-f039-47ce-a470-a662b129930a}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "sponsorBlocker@ajay.app" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "{20fc2e06-e3e4-4b2b-812b-ab431220cada}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/startpage-private-search/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
        };

        Preferences = {
          "widget.use-xdg-desktop-portal.file-picker" = lib.mkIf (config.system.desktopEnvironment == "KDE") 1;

          "network.http.referer.XOriginPolicy" = 1;
          "network.dns.disablePrefetch" = true;
          "privacy.resistFingerprinting" = true;
          "privacy.firstparty.isolate" = true;
          "privacy.trackingprotection.cryptomining" = true;
          "privacy.trackingprotection.socialtracking" = true;
          "security.cert_pinning.enforcement_level" = 2;
        };

        NoDefaultBookmarks = false;
      };
    };
  };
}
