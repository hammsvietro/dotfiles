{ config, pkgs, lib, ... }:

let
  home = config.home.homeDirectory;
  dotfiles = "${home}/dotfiles";
  vault = "${config.xdg.dataHome}/blackwall";
  skillsDir = "${vault}/skills";
  blob = "${dotfiles}/secrets/blackwall.enc";
  keyDefault = "${home}/.config/sops/age/keys.txt";

  blackwall-lock = pkgs.writeShellApplication {
    name = "blackwall-lock";
    runtimeInputs = [ pkgs.age pkgs.gnutar pkgs.gzip pkgs.coreutils pkgs.diffutils ];
    text = ''
      umask 077
      KEY="''${SOPS_AGE_KEY_FILE:-${keyDefault}}"
      if [ ! -d "${vault}" ]; then
        echo "blackwall-lock: no plaintext vault at ${vault}" >&2
        exit 1
      fi
      if [ ! -f "$KEY" ]; then
        echo "blackwall-lock: age key not found at $KEY" >&2
        exit 1
      fi
      recipient="$(age-keygen -y "$KEY")"

      # age re-encrypts nondeterministically, so skip the write when nothing changed
      if [ -f "${blob}" ]; then
        tmp="$(mktemp -d)"
        trap 'rm -rf "$tmp"' EXIT
        if age -d -i "$KEY" "${blob}" 2>/dev/null | tar -xzf - -C "$tmp" 2>/dev/null \
           && diff -rq "$tmp" "${vault}" >/dev/null 2>&1; then
          echo "blackwall-lock: no changes; ${blob} left as-is"
          exit 0
        fi
      fi

      mkdir -p "$(dirname "${blob}")"
      tar -czf - -C "${vault}" . | age -r "$recipient" -o "${blob}"
      echo "blackwall-lock: encrypted ${vault} -> ${blob}"
    '';
  };

  blackwall-unlock = pkgs.writeShellApplication {
    name = "blackwall-unlock";
    runtimeInputs = [ pkgs.age pkgs.gnutar pkgs.gzip pkgs.coreutils ];
    text = ''
      umask 077
      KEY="''${SOPS_AGE_KEY_FILE:-${keyDefault}}"
      force=0
      if [ "''${1:-}" = "--force" ]; then force=1; fi
      if [ ! -f "${blob}" ]; then
        echo "blackwall-unlock: no blob at ${blob}" >&2
        exit 1
      fi
      if [ ! -f "$KEY" ]; then
        echo "blackwall-unlock: age key not found at $KEY — place your key there first" >&2
        exit 1
      fi
      if [ -d "${vault}" ] && [ -n "$(ls -A "${vault}" 2>/dev/null)" ] && [ "$force" -ne 1 ]; then
        echo "blackwall-unlock: ${vault} already populated; pass --force to overwrite" >&2
        exit 0
      fi
      mkdir -p "${vault}"
      chmod 700 "${vault}"
      age -d -i "$KEY" "${blob}" | tar -xzf - -C "${vault}"
      echo "blackwall-unlock: decrypted ${blob} -> ${vault}"
    '';
  };
in
{
  home.packages = [ blackwall-lock blackwall-unlock ];

  home.file = {
    "blackwall".source = config.lib.file.mkOutOfStoreSymlink vault;
    ".claude/skills".source = config.lib.file.mkOutOfStoreSymlink skillsDir;
    ".config/claude-work/skills".source = config.lib.file.mkOutOfStoreSymlink skillsDir;
  };

  home.activation.blackwallUnlock = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    _bw_key="''${SOPS_AGE_KEY_FILE:-${keyDefault}}"
    _bw_marker="${home}/.local/state/blackwall-unlocked"
    if [ -f "${blob}" ] && [ -f "$_bw_key" ] \
       && { [ ! -f "$_bw_marker" ] || [ "${blob}" -nt "$_bw_marker" ]; }; then
      ${pkgs.coreutils}/bin/mkdir -p "${home}/.local/state"
      ${blackwall-unlock}/bin/blackwall-unlock --force
      ${pkgs.coreutils}/bin/touch "$_bw_marker"
    fi
  '';
}
