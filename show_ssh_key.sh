#!/bin/bash
# Скрипт для отображения SSH ключа для GitHub

echo "========================================="
echo "SSH ключ для GitHub"
echo "========================================="
echo ""
echo "Ваш публичный SSH ключ:"
echo ""
cat ~/.ssh/id_ed25519.pub
echo ""
echo "========================================="
echo ""
echo "Инструкция:"
echo "1. Скопируйте ключ выше (от 'ssh-ed25519' до конца)"
echo "2. Перейдите на https://github.com/settings/keys"
echo "3. Нажмите 'New SSH key'"
echo "4. Вставьте ключ и сохраните"
echo ""
echo "Проверка подключения (после добавления ключа):"
echo "  ssh -T git@github.com"
echo ""

