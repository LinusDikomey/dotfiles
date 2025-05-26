let
  linus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOUBLt7DvAGEwZptMihw1RWYM3jEHV9U5h7ugQpb8m3s";
in {
  "dyndns-password.age".publicKeys = [linus];
  "waldbot-env.age".publicKeys = [linus];
}
