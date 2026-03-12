{
  lib,
  inputs,
  ...
}:
{
  sops =
    let
      secrets-store_path = "${inputs.secrets-dir}/store.yaml";
    in
    lib.optionalAttrs (builtins.pathExists secrets-store_path) {
      defaultSopsFile = secrets-store_path;
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

      secrets = {
        hello = { };
      };
    };
}
