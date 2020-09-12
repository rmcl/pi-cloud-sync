ROOT_DIR=/filesync
FILE_SHARE_DIR=$(ROOT_DIR)/data

define SMB_CONF_CONTENTS
[global]
log file = /var/log/samba/log.%m
max log size = 1000
logging = file syslog@1
panic action = /usr/share/samba/panic-action %d

server role = standalone server
obey pam restrictions = yes
unix password sync = yes

passwd program = /usr/bin/passwd %u
passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .

pam password change = yes

map to guest = bad user

[homes]
comment = Home Directories
browseable = no
read only = yes
create mask = 0700
directory mask = 0700


[SharePi]
comment = PiFileSync
public = yes
writeable = yes
browsable = yes
path = $(FILE_SHARE_DIR)
create mask = 0777
directory mask = 0777
endef

export SMB_CONF_CONTENTS


deps:
	sudo apt-get install -yq samba

install-samba: deps
	sudo mkdir -p $(FILE_SHARE_DIR)
	sudo chmod 777 $(FILE_SHARE_DIR)

	sudo mkdir -p $(FILE_SHARE_DIR)/upload
	sudo chmod 777 $(FILE_SHARE_DIR)/upload

	sudo mkdir -p $(FILE_SHARE_DIR)/complete
	sudo mkdir -p $(FILE_SHARE_DIR)/failed

	echo "$$SMB_CONF_CONTENTS" | sudo tee /etc/samba/smb.conf

	sudo service smbd restart

install: install-samba
	pip install watchdog


remove-deps:
	sudo apt-get remove samba
