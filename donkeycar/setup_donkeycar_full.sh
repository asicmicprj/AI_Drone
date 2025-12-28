#!/bin/bash
# Полный скрипт установки DonkeyCar для Raspberry Pi с Python 3.11.9
# Этот скрипт автоматически установит все необходимое

set -e  # Остановка при ошибках

echo "========================================="
echo "Установка DonkeyCar для Raspberry Pi"
echo "========================================="
echo ""

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Константы
PYTHON_VERSION="3.11.9"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_NAME="env"

# Функция для вывода сообщений
info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Проверка, что скрипт запущен из директории проекта
if [ ! -f "setup.cfg" ]; then
    error "Скрипт должен быть запущен из директории donkeycar!"
fi

info "Начинаем установку DonkeyCar..."
echo ""

# Шаг 1: Установка системных зависимостей
info "Шаг 1: Установка системных зависимостей..."
if ! dpkg -l | grep -q libffi-dev; then
    info "Устанавливаем libffi-dev (критически важно для ctypes!)..."
    sudo apt-get update
    sudo apt-get install -y libffi-dev || error "Не удалось установить libffi-dev"
    info "libffi-dev установлен"
else
    info "libffi-dev уже установлен"
fi

# Проверка других рекомендуемых зависимостей
RECOMMENDED_DEPS="build-essential libssl-dev libbz2-dev libreadline-dev libsqlite3-dev libncurses5-dev libncursesw5-dev xz-utils tk-dev liblzma-dev"
MISSING_DEPS=""

for dep in $RECOMMENDED_DEPS; do
    if ! dpkg -l | grep -q "^ii  $dep"; then
        MISSING_DEPS="$MISSING_DEPS $dep"
    fi
done

if [ -n "$MISSING_DEPS" ]; then
    warn "Рекомендуемые зависимости не установлены:$MISSING_DEPS"
    read -p "Установить их сейчас? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo apt-get install -y $MISSING_DEPS || warn "Не удалось установить некоторые зависимости"
    fi
fi

# Шаг 2: Проверка и установка pyenv
info ""
info "Шаг 2: Проверка pyenv..."

export PYENV_ROOT="$HOME/.pyenv"
if [ ! -d "$PYENV_ROOT" ]; then
    info "Устанавливаем pyenv..."
    curl https://pyenv.run | bash || error "Не удалось установить pyenv"
    
    # Добавляем pyenv в PATH для текущей сессии
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - bash)" 2>/dev/null || true
    
    warn "pyenv установлен. Добавьте в ~/.bashrc:"
    echo "export PYENV_ROOT=\"\$HOME/.pyenv\""
    echo "export PATH=\"\$PYENV_ROOT/bin:\$PATH\""
    echo "eval \"\$(pyenv init - bash)\""
else
    info "pyenv уже установлен"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - bash)" 2>/dev/null || true
fi

# Шаг 3: Установка Python 3.11.9
info ""
info "Шаг 3: Проверка Python $PYTHON_VERSION..."

if [ -d "$PYENV_ROOT/versions/$PYTHON_VERSION" ]; then
    info "Python $PYTHON_VERSION уже установлен"
    
    # Проверяем ctypes
    if "$PYENV_ROOT/versions/$PYTHON_VERSION/bin/python" -c "import ctypes" 2>/dev/null; then
        info "ctypes работает корректно"
    else
        warn "ctypes не работает в установленном Python. Переустанавливаем..."
        pyenv uninstall -f $PYTHON_VERSION
        pyenv install $PYTHON_VERSION || error "Не удалось установить Python $PYTHON_VERSION"
    fi
else
    info "Устанавливаем Python $PYTHON_VERSION (это может занять 20-40 минут на Raspberry Pi)..."
    pyenv install $PYTHON_VERSION || error "Не удалось установить Python $PYTHON_VERSION"
fi

# Шаг 4: Создание виртуального окружения
info ""
info "Шаг 4: Создание виртуального окружения..."

cd "$PROJECT_DIR"

if [ -d "$VENV_NAME" ]; then
    warn "Виртуальное окружение $VENV_NAME уже существует"
    read -p "Удалить и создать заново? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$VENV_NAME"
        info "Старое окружение удалено"
    else
        info "Используем существующее окружение"
    fi
fi

if [ ! -d "$VENV_NAME" ]; then
    info "Создаем виртуальное окружение $VENV_NAME..."
    "$PYENV_ROOT/versions/$PYTHON_VERSION/bin/python" -m venv "$VENV_NAME" || error "Не удалось создать виртуальное окружение"
    info "Виртуальное окружение создано"
fi

# Шаг 5: Активация окружения и установка DonkeyCar
info ""
info "Шаг 5: Установка DonkeyCar..."

source "$VENV_NAME/bin/activate"

# Проверка версии Python
PYTHON_VER=$(python --version 2>&1 | awk '{print $2}')
if [ "$PYTHON_VER" != "$PYTHON_VERSION" ]; then
    error "Версия Python в виртуальном окружении ($PYTHON_VER) не соответствует требуемой ($PYTHON_VERSION)!"
fi

info "Версия Python: $PYTHON_VER ✓"

# Проверка ctypes
if python -c "import ctypes" 2>/dev/null; then
    info "ctypes работает ✓"
else
    error "ctypes не работает! Python был скомпилирован неправильно. Переустановите Python 3.11.9 с libffi-dev."
fi

# Обновление pip
info "Обновляем pip, setuptools, wheel..."
pip install --upgrade pip setuptools wheel > /dev/null 2>&1

# Установка DonkeyCar
info "Устанавливаем DonkeyCar с зависимостями для Raspberry Pi..."
info "(Это может занять несколько минут)"
pip install -e .[pi] || error "Не удалось установить DonkeyCar"

# Шаг 6: Проверка установки
info ""
info "Шаг 6: Проверка установки..."

if python -c "import donkeycar" 2>/dev/null; then
    info "DonkeyCar импортируется ✓"
else
    error "DonkeyCar не импортируется!"
fi

if python -c "import tensorflow as tf" 2>/dev/null; then
    TF_VER=$(python -c "import tensorflow as tf; print(tf.__version__)" 2>&1)
    info "TensorFlow $TF_VER импортируется ✓"
else
    error "TensorFlow не импортируется!"
fi

if python -c "from donkeycar.parts import keras" 2>/dev/null; then
    info "Keras модуль работает ✓"
else
    error "Keras модуль не работает!"
fi

if command -v donkey >/dev/null 2>&1; then
    info "Команда donkey доступна ✓"
else
    error "Команда donkey не найдена!"
fi

# Финальное сообщение
echo ""
echo "========================================="
info "Установка завершена успешно!"
echo "========================================="
echo ""
echo "Для использования DonkeyCar:"
echo "  1. Активируйте виртуальное окружение:"
echo "     cd $PROJECT_DIR"
echo "     source $VENV_NAME/bin/activate"
echo ""
echo "  2. Проверьте установку:"
echo "     donkey --help"
echo ""
echo "  3. Создайте новый проект:"
echo "     donkey createcar --path ~/mycar --template complete"
echo ""

