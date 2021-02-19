# How to handle SSH certificates ?

This document requires three different machines:

- a trusted server, which gives certificates,
- a server, which accepts certificates from the trusted server,
- a client, which has a certificate from the trusted server.

It's possible to have multiple trusted servers, multiple servers, and multiple clients.

## Setup the Certificate Authority

```bash
@trusted-server
$ su
$ mkdir -p /etc/ssh
$ cd /etc/ssh
$ ssh-keygen -t ecdsa -f CA
```

## Setup a new server

### ① Create a certificate for a server

Before you can do this step, you will need to send the server's public
key (`/etc/ssh/ssh_host_*.pub`) to the CA.

```bash
@trusted-server
$ su
$ cd /etc/ssh
$ ssh-keygen -h -s CA -n <domains> -I <name> -V +52w <file.pub>
```

- `CA` is the certificate authority generated in ①.
- `<domains>` is a comma-separated list of domains the server answers to.
- `<name>` is the name of the server (to find it easily)
- `<file.pub>` is the server's public key
- `+52w` means "this certificate will be valid for 52 weeks"

Then, move the generated file (it ends in '…-cert.pub') in the server's `/etc/ssh`, as well as the
public certificate (`/etc/ssh/CA.pub`).

### ② Tell the server it needs to use the certificate

```bash
@server
$ su
$ nano /etc/ssh/sshd_config
```

Add the certificates and the trusted server's key.

```
# For each certificate
HostCertificate /etc/ssh/<file-cert.pub>
# For each trusted server
TrustedUserCAKeys /etc/ssh/CA.pub
```

Then, restart the SSH server:

```bash
@server
$ sudo systemctl restart ssh  # debian-based
$ sudo systemctl restart sshd # arch-based
```

If SSHD doesn't start, run this command to get info on why:

```bash
@server
$ sshd -t
```

## Setup a new client

### ① Tell clients to trust the Trusted Server

```bash
@client

# All accounts trust the CA
$ sudo nano /etc/ssh/ssh_known_hosts

# Only the current account trusts the CA
$ nano ~/.ssh/known_hosts
```

Replace all host keys by:

```config
@cert-authority <domains> <certificate>
```

- `<domains>` is the list of all domains that the certificate authenticates; you can use *
  .yourdomain.com for example.
- `<certificate>` is the trusted server's certificate (complete output of `cat /etc/ssh/CA.pub` on
  the trusted server).

Now, if you try to connect to the server, it should fail but should NOT tell you that 'the
authencity cannot be established' (for example, it could fail with "Permission denied (publickey)").

### ② Signing the client's key

```bash
@trusted-server
$ su
$ cd /etc/ssh
$ ssh-keygen -s CA -I <name> -n <username> -V +52w <key.pub>
```

- `<name>` is the name of the signature, useful to find them in the future
- `<username>` is the username that this key allows logging in with
- `+52w` means "this certificate will be valid for 52 weeks"
- `<key.pub>` is the client's public key

Now, move the generated file (named `<key>-cert.pub`) to the client's folder (`/etc/ssh`
or `~/.ssh`). The file should be named exactly the same as the original key (so it's
usually `id_rsa-cert.pub`).

## Cleaning up

If you used SSH without certificates previously;

- clients: you can now remove all entries from that domain from `~/.ssh/known_hosts`
- servers: you can now remove all keys from that domain from `~/.ssh/authorized_keys`
