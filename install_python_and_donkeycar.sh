#!/bin/bash
# Полный скрипт установки Python 3.11.9 и DonkeyCar для Raspberry Pi
# Запускается из папки projects/
# Автоматически устанавливает все зависимости и проверяет работоспособность

set -e  # Остановка при ошибках

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Константы
PYTHON_VERSION="3.11.9"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_NAME="env"
VENV_PATH="$PROJECT_DIR/$VENV_NAME"

# Функции для вывода сообщений
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

step() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

# Заголовок
clear
echo -e "${GREEN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║   Установка Python 3.11.9 и DonkeyCar для Raspberry Pi   ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# Проверка, что скрипт запущен из правильной директории
if [ ! -d "$PROJECT_DIR/donkeycar" ]; then
    error "Директория donkeycar не найдена в $PROJECT_DIR. Запустите скрипт из папки projects/"
fi

# ============================================================================
# Шаг 1: Установка системных зависимостей
# ============================================================================
step "Шаг 1: Установка системных зависимостей"

info "Обновление списка пакетов..."
sudo apt-get update -qq

info "Проверка и установка критичных зависимостей для Python..."

# Критичные зависимости для компиляции Python с поддержкой всех модулей
CRITICAL_DEPS="build-essential libffi-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev libncurses-dev liblzma-dev tk-dev xz-utils zlib1g-dev"

# Дополнительные зависимости для DonkeyCar (picamera2 и др.)
DONKEYCAR_DEPS="libcap-dev python3-dev python3-pil python3-smbus"

MISSING_DEPS=""
for dep in $CRITICAL_DEPS $DONKEYCAR_DEPS; do
    if ! dpkg-query -W -f='${Status}' "$dep" 2>/dev/null | grep -q "install ok installed"; then
        MISSING_DEPS="$MISSING_DEPS $dep"
    fi
done

if [ -n "$MISSING_DEPS" ]; then
    info "Устанавливаю недостающие зависимости:$MISSING_DEPS"
    sudo apt-get install -y $MISSING_DEPS || error "Не удалось установить системные зависимости"
    info "✅ Все системные зависимости установлены"
else
    info "✅ Все системные зависимости уже установлены"
fi

# Проверка критичных зависимостей
info "Проверка критичных библиотек..."
for lib in libffi-dev libssl-dev; do
    if dpkg-query -W -f='${Status}' "$lib" 2>/dev/null | grep -q "install ok installed"; then
        info "  ✅ $lib"
    else
        error "  ❌ $lib не установлена! Это критично для работы Python!"
    fi
done

# ============================================================================
# Шаг 2: Установка pyenv
# ============================================================================
step "Шаг 2: Проверка и установка pyenv"

export PYENV_ROOT="$HOME/.pyenv"
if [ ! -d "$PYENV_ROOT" ]; then
    info "Устанавливаю pyenv..."
    curl -fsSL https://pyenv.run | bash || error "Не удалось установить pyenv"
    
    # Добавляем pyenv в PATH для текущей сессии
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - bash)" 2>/dev/null || true
    
    # Добавляем в .bashrc для будущих сессий
    if ! grep -q "PYENV_ROOT" ~/.bashrc; then
        info "Добавляю pyenv в ~/.bashrc..."
        echo '' >> ~/.bashrc
        echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
        echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
        echo 'eval "$(pyenv init - bash)"' >> ~/.bashrc
    fi
    info "✅ pyenv установлен"
else
    info "✅ pyenv уже установлен"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - bash)" 2>/dev/null || true
fi

# ============================================================================
# Шаг 3: Установка Python 3.11.9
# ============================================================================
step "Шаг 3: Установка Python $PYTHON_VERSION"

# Проверка, установлен ли Python
if [ -d "$PYENV_ROOT/versions/$PYTHON_VERSION" ] && [ -f "$PYENV_ROOT/versions/$PYTHON_VERSION/bin/python" ]; then
    info "Python $PYTHON_VERSION уже установлен"
    
    # Проверка работоспособности модулей
    info "Проверка критичных модулей Python..."
    PYTHON_BIN="$PYENV_ROOT/versions/$PYTHON_VERSION/bin/python"
    
    MODULES_OK=true
    for mod in ssl sqlite3 ctypes; do
        if "$PYTHON_BIN" -c "import $mod" 2>/dev/null; then
            info "  ✅ Модуль $mod работает"
        else
            warn "  ❌ Модуль $mod не работает - требуется переустановка"
            MODULES_OK=false
        fi
    done
    
    if [ "$MODULES_OK" = false ]; then
        warn "Некоторые модули не работают. Переустанавливаю Python $PYTHON_VERSION..."
        pyenv uninstall -f $PYTHON_VERSION 2>/dev/null || rm -rf "$PYENV_ROOT/versions/$PYTHON_VERSION"
    else
        info "✅ Python $PYTHON_VERSION работает корректно"
        SKIP_PYTHON_INSTALL=true
    fi
fi

if [ "$SKIP_PYTHON_INSTALL" != "true" ]; then
    info "Устанавливаю Python $PYTHON_VERSION через pyenv..."
    warn "Это займет 20-40 минут на Raspberry Pi (компиляция из исходников)"
    echo ""
    
    # Устанавливаем Python с выводом прогресса
    pyenv install $PYTHON_VERSION || error "Не удалось установить Python $PYTHON_VERSION"
    
    info "✅ Python $PYTHON_VERSION успешно установлен"
fi

# Проверка версии и модулей
PYTHON_BIN="$PYENV_ROOT/versions/$PYTHON_VERSION/bin/python"
INSTALLED_VERSION=$("$PYTHON_BIN" --version 2>&1)
info "Установлена версия: $INSTALLED_VERSION"

info "Проверка критичных модулей Python для DonkeyCar..."
CRITICAL_MODULES="ctypes ssl sqlite3 zlib bz2"
ALL_MODULES_OK=true

for mod in $CRITICAL_MODULES; do
    if "$PYTHON_BIN" -c "import $mod" 2>/dev/null; then
        info "  ✅ $mod"
    else
        error "  ❌ $mod - НЕ РАБОТАЕТ! Python скомпилирован неправильно!"
        ALL_MODULES_OK=false
    fi
done

if [ "$ALL_MODULES_OK" = true ]; then
    info "✅ Все критичные модули Python работают корректно"
else
    error "Критичные модули Python не работают. Проверьте установку системных зависимостей и переустановите Python."
fi

# ============================================================================
# Шаг 4: Создание виртуального окружения
# ============================================================================
step "Шаг 4: Создание виртуального окружения"

cd "$PROJECT_DIR"

if [ -d "$VENV_PATH" ]; then
    warn "Виртуальное окружение $VENV_NAME уже существует"
    read -p "Удалить и пересоздать? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        info "Удаляю старое окружение..."
        rm -rf "$VENV_PATH"
    else
        info "Использую существующее окружение"
        SKIP_VENV_CREATE=true
    fi
fi

if [ "$SKIP_VENV_CREATE" != "true" ]; then
    info "Создаю виртуальное окружение $VENV_NAME с Python $PYTHON_VERSION..."
    "$PYTHON_BIN" -m venv "$VENV_PATH" || error "Не удалось создать виртуальное окружение"
    info "✅ Виртуальное окружение создано"
fi

# Активация окружения
info "Активирую виртуальное окружение..."
source "$VENV_PATH/bin/activate"

# Проверка версии Python в окружении
VENV_PYTHON_VER=$(python --version 2>&1 | awk '{print $2}')
if [ "$VENV_PYTHON_VER" != "$PYTHON_VERSION" ]; then
    error "Версия Python в виртуальном окружении ($VENV_PYTHON_VER) не соответствует требуемой ($PYTHON_VERSION)!"
fi

info "✅ Виртуальное окружение активировано: Python $VENV_PYTHON_VER"

# ============================================================================
# Шаг 5: Установка DonkeyCar и зависимостей
# ============================================================================
step "Шаг 5: Установка DonkeyCar и зависимостей"

cd "$PROJECT_DIR/donkeycar"

# Обновление pip, setuptools, wheel
info "Обновляю pip, setuptools, wheel..."
pip install --quiet --upgrade pip setuptools wheel

# Установка DonkeyCar с зависимостями для Raspberry Pi
info "Устанавливаю DonkeyCar с зависимостями для Raspberry Pi..."
warn "Это может занять 10-30 минут (установка TensorFlow и других больших пакетов)"
echo ""

pip install -e .[pi] || error "Не удалось установить DonkeyCar"

info "✅ DonkeyCar и зависимости установлены"

# ============================================================================
# Шаг 6: Проверка установки и работоспособности
# ============================================================================
step "Шаг 6: Проверка установки и работоспособности"

info "Проверка критичных модулей..."

# Проверка базовых модулей Python
info "1. Базовые модули Python:"
for mod in ctypes ssl sqlite3; do
    if python -c "import $mod" 2>/dev/null; then
        info "   ✅ $mod"
    else
        error "   ❌ $mod - НЕ РАБОТАЕТ!"
    fi
done

# Проверка DonkeyCar
info "2. DonkeyCar:"
if python -c "import donkeycar" 2>/dev/null; then
    DC_VERSION=$(python -c "import donkeycar; print(donkeycar.__version__)" 2>/dev/null || echo "unknown")
    info "   ✅ DonkeyCar импортируется (версия: $DC_VERSION)"
else
    error "   ❌ DonkeyCar не импортируется!"
fi

# Проверка TensorFlow
info "3. TensorFlow:"
if python -c "import tensorflow as tf" 2>/dev/null; then
    TF_VERSION=$(python -c "import tensorflow as tf; print(tf.__version__)" 2>/dev/null)
    info "   ✅ TensorFlow $TF_VERSION импортируется"
else
    warn "   ⚠️  TensorFlow не импортируется (может быть нормально, если не установлен)"
fi

# Проверка Keras модуля
info "4. Keras модуль DonkeyCar:"
if python -c "from donkeycar.parts import keras" 2>/dev/null; then
    info "   ✅ Keras модуль работает"
else
    warn "   ⚠️  Keras модуль не работает (может потребоваться TensorFlow)"
fi

# Проверка команды donkey
info "5. Команда donkey:"
if command -v donkey >/dev/null 2>&1; then
    info "   ✅ Команда donkey доступна"
    donkey --version 2>/dev/null || true
else
    warn "   ⚠️  Команда donkey не найдена в PATH"
fi

# Проверка NumPy (критично для многих модулей)
info "6. NumPy:"
if python -c "import numpy as np" 2>/dev/null; then
    NP_VERSION=$(python -c "import numpy as np; print(np.__version__)" 2>/dev/null)
    info "   ✅ NumPy $NP_VERSION работает"
else
    warn "   ⚠️  NumPy не работает"
fi

# Проверка OpenCV (для обработки изображений)
info "7. OpenCV:"
if python -c "import cv2" 2>/dev/null; then
    CV_VERSION=$(python -c "import cv2; print(cv2.__version__)" 2>/dev/null)
    info "   ✅ OpenCV $CV_VERSION работает"
else
    warn "   ⚠️  OpenCV не работает (может потребоваться для некоторых функций)"
fi

# Финальная проверка
info ""
info "Финальная проверка всех критичных компонентов..."
FINAL_CHECK=true

python -c "
import sys
errors = []

try:
    import ctypes
except Exception as e:
    errors.append(f'ctypes: {e}')

try:
    import ssl
except Exception as e:
    errors.append(f'ssl: {e}')

try:
    import donkeycar
except Exception as e:
    errors.append(f'donkeycar: {e}')
    FINAL_CHECK = False

if errors:
    print('Ошибки:', file=sys.stderr)
    for err in errors:
        print(f'  - {err}', file=sys.stderr)
    sys.exit(1)
else:
    print('✅ Все критичные модули работают!')
" 2>&1 || FINAL_CHECK=false

if [ "$FINAL_CHECK" = false ]; then
    warn "⚠️  Некоторые модули имеют проблемы, но установка завершена"
else
    info "✅ Все критичные модули работают корректно!"
fi

# ============================================================================
# Итоговое сообщение
# ============================================================================
step "Установка завершена!"

echo -e "${GREEN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║              ✅ УСТАНОВКА УСПЕШНО ЗАВЕРШЕНА!             ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

info "Виртуальное окружение находится в: $VENV_PATH"
info "Python версия: $PYTHON_VERSION"
echo ""

echo "Для активации виртуального окружения в будущем выполните:"
echo -e "${BLUE}  cd $PROJECT_DIR${NC}"
echo -e "${BLUE}  source $VENV_NAME/bin/activate${NC}"
echo ""

echo "Для деактивации окружения:"
echo -e "${BLUE}  deactivate${NC}"
echo ""

if [ -d "$PROJECT_DIR/pi-display" ]; then
    info "Обнаружена директория pi-display"
    echo "Для установки pi-display выполните:"
    echo -e "${BLUE}  cd $PROJECT_DIR/pi-display${NC}"
    echo -e "${BLUE}  sudo ./install.sh${NC}"
    echo ""
fi

info "Для проверки установки:"
echo -e "${BLUE}  python -c 'import donkeycar; print(\"DonkeyCar работает!\")'${NC}"
echo ""

