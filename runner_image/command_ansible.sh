#!/bin/bash
export POWERSHELL_VERSION="" # For Windows targets, no harm if not Windows
ANSIBLE_DIR=~/.ansible
ANSIBLE_CFG=${ANSIBLE_DIR}/ansible.cfg
mkdir -p $ANSIBLE_DIR
chmod 2775 $ANSIBLE_DIR

cat << EOF > $ANSIBLE_CFG
[defaults]
roles_path = ~/.ansible/roles
deprecation_warnings = False
nocows = 1
EOF

SSH_DIR=~/.ssh
SSH_CFG=${SSH_DIR}/config
mkdir -p $SSH_DIR
chmod 700 $SSH_DIR

cat << EOF > $SSH_CFG
PubkeyAcceptedAlgorithms ssh-rsa
HostkeyAlgorithms ssh-rsa
EOF

ansible-playbook "$@"