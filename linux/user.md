## Create New User

// cat /etc/passwd
`sudo adduser newuser`

## Add user to sudo / wheel group

// cat /etc/group
`usermod -aG sudo newuser`
`usermod -aG wheel newuser`

## make sure whell can sudo

`cat /etc/sudoers`

and edit wheel like this, to allow sudo without password

```
## Same thing without a password
# %wheel	ALL=(ALL)	NOPASSWD: ALL
```

## Add Public Key for user

`su - newuser`

### at /home/newuser
`mkdir ~/.ssh`

### and add the public key

`vim ~/.ssh/authorized_keys`

```
ssh-ed25519 AAAAAAAAAAA++5VRpq a.com
```

### change mod of ssh as root

`sudo chmod 700 /home/newuser/.ssh`

### change mod of authorized_keys

`chmod 644 /home/newuser/.ssh/authorized_keys`

### make sure user owns a dir

`chown newuser:newuser /home/newuser/.ssh/authorized_keys`
`chown newuser:newuser /home/newuser/.ssh`

### login via key

`ssh -i path_to_your_ssh_private_key newuser@server_address`
