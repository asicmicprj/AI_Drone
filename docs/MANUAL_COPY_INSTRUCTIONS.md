# Ручное копирование donkeycar в репозиторий F1Drone

Если автоматический скрипт не работает, выполните следующие шаги вручную:

## Шаг 1: Клонировать репозиторий F1Drone

```bash
cd ~/projects
git clone https://github.com/asicmicprj/F1Drone.git
cd F1Drone
```

## Шаг 2: Скопировать папку donkeycar

```bash
cp -r ../donkeycar .
```

## Шаг 3: Добавить в git и закоммитить

```bash
git add donkeycar/
git status  # Проверить что добавлено
git commit -m "Add DonkeyCar with installation scripts and documentation"
```

## Шаг 4: Отправить в репозиторий

```bash
git push origin main
```

## Альтернатива: Только новые файлы

Если хотите добавить только созданные файлы документации (без всего проекта donkeycar):

```bash
cd ~/projects/F1Drone
mkdir -p donkeycar
cp ../donkeycar/INSTALLATION.md donkeycar/
cp ../donkeycar/setup_donkeycar_full.sh donkeycar/
cp ../donkeycar/REQUIREMENTS.txt donkeycar/
cp ../donkeycar/QUICK_START.md donkeycar/
cp ../donkeycar/README_INSTALL.md donkeycar/
chmod +x donkeycar/setup_donkeycar_full.sh

git add donkeycar/
git commit -m "Add DonkeyCar installation documentation and scripts"
git push origin main
```

## Список созданных файлов

Следующие файлы были созданы и добавлены в donkeycar/:

1. `donkeycar/INSTALLATION.md` - Подробная инструкция по установке (146 строк)
2. `donkeycar/setup_donkeycar_full.sh` - Автоматический скрипт установки (218 строк)
3. `donkeycar/REQUIREMENTS.txt` - Системные зависимости (24 строки)
4. `donkeycar/QUICK_START.md` - Быстрый старт (56 строк)
5. `donkeycar/README_INSTALL.md` - Обзор документации

Все файлы находятся в: `~/projects/donkeycar/`

