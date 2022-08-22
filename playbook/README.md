# Manual Playbook

## SSH Keys

### Generate Client Keys
```bash
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "user@hostname"
```

### Rotate Host Keys
```bash
mkdir /etc/ssh/default_keys
mv /etc/ssh/ssh_host_* /etc/ssh/default_keys/
dpkg-reconfigure openssh-server
```

### Configure sshd on Host
In `/etc/ssh/sshd_config`:

```
PubkeyAuthentication yes
PasswordAuthentication no
```

### Add User Keys to Host
```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@hostname
```
