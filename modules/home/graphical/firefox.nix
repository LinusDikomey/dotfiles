{config, ...}: {
  programs.firefox = {
    enable = config.dotfiles.graphical.enable;
    profiles.default = {
      id = 0;
      isDefault = true;
      settings = {
        "browser.ai.control.default" = "blocked";
        "browser.ai.control.linkPreviewKeyPoints" = "blocked";
        "browser.ai.control.pdfjsAltText" = "blocked";
        "browser.ai.control.sidebarChatbot" = "blocked";
        "browser.ai.control.smartTabGroups" = "blocked";
        "browser.ai.control.translations" = "blocked";
        "browser.ml.chat.enabled" = false;
        "browser.ml.chat.page" = false;
        "browser.ml.linkPreview.enabled" = false;
        "browser.tabs.groups.smart.enabled" = false;
        "browser.tabs.groups.smart.userEnabled" = false;
        "browser.translations.enable" = false;
        "extensions.ml.enabled" = false;
        "pdfjs.enableAltText" = false;
      };
    };
  };
}
