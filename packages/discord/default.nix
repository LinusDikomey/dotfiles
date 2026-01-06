{
  branch ? "stable",
  callPackage,
  fetchurl,
  lib,
  stdenv,
}: let
  versions.stable = "0.0.119";
  version = versions.${branch};
  srcs = {
    x86_64-linux = {
      stable = fetchurl {
        url = "https://stable.dl2.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
        hash = "sha256-/NfgHBXsUWYoDEVGz13GBU1ISpSdB5OmrjhSN25SBMg=";
      };
    };
  };
  src =
    srcs.${stdenv.hostPlatform.system}.${branch}
      or (throw "${stdenv.hostPlatform.system} not supported on ${branch}");

  meta = {
    description = "All-in-one cross-platform voice and text chat for gamers";
    downloadPage = "https://discordapp.com/download";
    homepage = "https://discordapp.com/";
    license = lib.licenses.unfree;
    mainProgram = "discord";
    maintainers = with lib.maintainers; [
      artturin
      donteatoreo
      infinidoge
      jopejoe1
      Scrumplex
    ];
    platforms = [
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
  };
  package = ./linux.nix;

  packages = (
    builtins.mapAttrs
    (
      _: value:
        callPackage package (
          value
          // {
            inherit src version branch;
            meta =
              meta
              // {
                mainProgram = value.binaryName;
              };
          }
        )
    )
    {
      stable = {
        pname = "discord";
        binaryName = "Discord";
        desktopName = "Discord";
      };
      ptb = rec {
        pname = "discord-ptb";
        binaryName =
          if stdenv.hostPlatform.isLinux
          then "DiscordPTB"
          else desktopName;
        desktopName = "Discord PTB";
      };
      canary = rec {
        pname = "discord-canary";
        binaryName =
          if stdenv.hostPlatform.isLinux
          then "DiscordCanary"
          else desktopName;
        desktopName = "Discord Canary";
      };
      development = rec {
        pname = "discord-development";
        binaryName =
          if stdenv.hostPlatform.isLinux
          then "DiscordDevelopment"
          else desktopName;
        desktopName = "Discord Development";
      };
    }
  );
in
  packages.${branch}
