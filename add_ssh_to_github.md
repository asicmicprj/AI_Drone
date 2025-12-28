# Инструкция по добавлению SSH ключа в GitHub

## ✅ SSH ключ успешно создан!

**Ваш публичный SSH ключ:**
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL1KVAvDyRZFelLoe5FZMwtgzCV2Oag/eLUbLLCVJKzr pi4_user@github
```

## Быстрая команда для просмотра ключа

```bash
~/projects/show_ssh_key.sh
```

или

```bash
cat ~/.ssh/id_ed25519.pub
```

## Шаги для добавления ключа в GitHub:

### Шаг 1: Скопируйте публичный ключ

Выполните команду, чтобы увидеть ключ:
```bash
cat ~/.ssh/id_ed25519.pub
```

Скопируйте всю строку (от `ssh-ed25519` до `pi4_user@github`).

### Шаг 2: Добавьте ключ в GitHub

1. Откройте GitHub: https://github.com
2. Войдите в свой аккаунт (asicmicprj)
3. Перейдите в настройки:
   - Кликните на аватар в правом верхнем углу
   - Выберите **Settings**
4. В левом меню выберите **SSH and GPG keys**
5. Нажмите кнопку **New SSH key**
6. Заполните форму:
   - **Title**: `Raspberry Pi 4` (или любое другое название)
   - **Key type**: `Authentication Key` (по умолчанию)
   - **Key**: Вставьте скопированный публичный ключ
7. Нажмите **Add SSH key**
8. Подтвердите действие вводом пароля GitHub (если потребуется)

### Шаг 3: Проверьте подключение

После добавления ключа, проверьте подключение:
```bash
ssh -T git@github.com
```

Вы должны увидеть:
```
Hi asicmicprj! You've successfully authenticated, but GitHub does not provide shell access.
```

Это означает, что SSH ключ работает правильно! ✅

## Использование SSH для работы с репозиториями

После добавления ключа, используйте SSH URL вместо HTTPS:

**Клонирование репозитория:**
```bash
# Вместо: git clone https://github.com/asicmicprj/F1Drone.git
git clone git@github.com:asicmicprj/F1Drone.git
```

**Добавление remote с SSH:**
```bash
git remote set-url origin git@github.com:asicmicprj/F1Drone.git
```

Теперь вы сможете выполнять `git push` и `git pull` без ввода пароля!

## Файлы SSH ключей

- **Приватный ключ**: `~/.ssh/id_ed25519` 
  - ⚠️ **НИКОГДА не передавайте этот файл никому!**
  - Права доступа: `600` (только владелец может читать/писать)

- **Публичный ключ**: `~/.ssh/id_ed25519.pub`
  - Этот файл можно безопасно передавать (добавлять в GitHub)
  - Права доступа: `644`

## SSH конфигурация

SSH конфигурация уже создана в `~/.ssh/config`:
```
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
```

Это обеспечивает автоматическое использование правильного ключа для GitHub.

## После добавления ключа

Когда ключ будет добавлен в GitHub, вы сможете:

1. Клонировать репозиторий F1Drone:
   ```bash
   cd ~/projects
   git clone git@github.com:asicmicprj/F1Drone.git
   ```

2. Скопировать donkeycar в F1Drone:
   ```bash
   cd ~/projects/F1Drone
   cp -r ../donkeycar .
   git add donkeycar/
   git commit -m "Add DonkeyCar with installation scripts and documentation"
   git push origin main
   ```
