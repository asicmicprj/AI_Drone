#!/bin/bash
# Скрипт для копирования папки donkeycar в репозиторий F1Drone

set -e

PROJECTS_DIR="$HOME/projects"
DONKEYCAR_DIR="$PROJECTS_DIR/donkeycar"
F1DRONE_DIR="$PROJECTS_DIR/F1Drone"
F1DRONE_REPO="https://github.com/asicmicprj/F1Drone.git"

echo "========================================="
echo "Копирование donkeycar в репозиторий F1Drone"
echo "========================================="
echo ""

cd "$PROJECTS_DIR"

# Проверка существования donkeycar
if [ ! -d "$DONKEYCAR_DIR" ]; then
    echo "❌ Папка donkeycar не найдена в $DONKEYCAR_DIR"
    exit 1
fi

echo "✅ Папка donkeycar найдена"

# Клонирование или обновление репозитория F1Drone
if [ ! -d "$F1DRONE_DIR" ]; then
    echo ""
    echo "Клонируем репозиторий F1Drone..."
    git clone "$F1DRONE_REPO" || {
        echo "❌ Не удалось клонировать репозиторий. Возможные причины:"
        echo "   - Нужна аутентификация GitHub"
        echo "   - Репозиторий не существует или недоступен"
        echo ""
        echo "Попробуйте клонировать вручную:"
        echo "  git clone $F1DRONE_REPO"
        exit 1
    }
    echo "✅ Репозиторий F1Drone клонирован"
else
    echo "✅ Репозиторий F1Drone уже существует, обновляем..."
    cd "$F1DRONE_DIR"
    git pull || echo "⚠️  Не удалось обновить (возможно, есть локальные изменения)"
fi

cd "$F1DRONE_DIR"

# Копирование папки donkeycar
echo ""
echo "Копируем папку donkeycar..."

if [ -d "donkeycar" ]; then
    echo "⚠️  Папка donkeycar уже существует в репозитории"
    read -p "Удалить существующую папку и скопировать заново? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf donkeycar
        echo "✅ Старая папка удалена"
    else
        echo "❌ Отменено. Существующая папка сохранена."
        exit 0
    fi
fi

# Копируем всю папку donkeycar
cp -r "$DONKEYCAR_DIR" .

echo "✅ Папка donkeycar скопирована"

# Показываем созданные файлы
echo ""
echo "Созданные файлы (добавлены нами):"
echo "  - INSTALLATION.md"
echo "  - setup_donkeycar_full.sh"
echo "  - REQUIREMENTS.txt"
echo "  - QUICK_START.md"
echo "  - README_INSTALL.md"

# Показываем статус git
echo ""
echo "Статус git:"
git status --short | head -20

echo ""
echo "========================================="
echo "Готово к коммиту!"
echo "========================================="
echo ""
echo "Для коммита и push выполните:"
echo ""
echo "  cd $F1DRONE_DIR"
echo "  git add donkeycar/"
echo "  git commit -m \"Add DonkeyCar with installation scripts and documentation\""
echo "  git push origin main"
echo ""

read -p "Выполнить git add и commit сейчас? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git add donkeycar/
    echo ""
    read -p "Введите сообщение коммита (или Enter для стандартного): " COMMIT_MSG
    if [ -z "$COMMIT_MSG" ]; then
        COMMIT_MSG="Add DonkeyCar with installation scripts and documentation"
    fi
    git commit -m "$COMMIT_MSG"
    echo ""
    echo "✅ Коммит создан"
    echo ""
    read -p "Выполнить git push? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git push origin main || {
            echo "❌ Не удалось выполнить push. Возможные причины:"
            echo "   - Нужна аутентификация"
            echo "   - Нет прав на запись"
            echo "   - Конфликты с удаленным репозиторием"
            echo ""
            echo "Выполните вручную:"
            echo "  cd $F1DRONE_DIR"
            echo "  git push origin main"
        }
    fi
fi

echo ""
echo "Готово!"

