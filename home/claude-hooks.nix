{ pkgs, lib }:

let
  deps = [
    pkgs.gitleaks
    pkgs.git
    pkgs.jq
    pkgs.coreutils
    pkgs.nixfmt
  ];

  mkHook =
    name:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = deps;
      text = builtins.readFile (./claude-hooks + "/${name}.sh");
    };
in
{
  secret-guard = mkHook "secret-guard";
  repro-guard = mkHook "repro-guard";
  secret-write-guard = mkHook "secret-write-guard";
  nix-fmt = mkHook "nix-fmt";

  preCommit = pkgs.writeShellScript "dotfiles-pre-commit" ''
    repo=$(${pkgs.git}/bin/git rev-parse --show-toplevel)
    if ! ${lib.getExe pkgs.gitleaks} git --staged --no-banner --no-color --redact -c "$repo/.gitleaks.toml" "$repo"; then
      echo "gitleaks blocked this commit: staged changes look like they contain a secret." >&2
      echo "Fix it, or allowlist a genuine false positive in .gitleaks.toml." >&2
      exit 1
    fi
  '';
}
