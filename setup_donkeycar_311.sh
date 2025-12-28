#!/bin/bash
# Скрипт для настройки виртуального окружения с Python 3.11 и установки DonkeyCar

set -e  # Остановка при ошибках

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

PYTHON_VERSION="3.11.9"
VENV_NAME="donkeycar-311"
PROJECT_DIR="$HOME/projects/donkeycar"

echo "=== Настройка DonkeyCar с Python 3.11 ==="
echo ""

# Проверка наличия Python 3.11.9
if [ ! -d "$PYENV_ROOT/versions/$PYTHON_VERSION" ]; then
    echo "❌ Python $PYTHON_VERSION не найден!"
    echo "Выполните: pyenv install $PYTHON_VERSION"
    exit 1
fi

echo "✅ Python $PYTHON_VERSION найден"

# Создание виртуального окружения
echo ""
echo "Создание виртуального окружения '$VENV_NAME'..."
if [ -d "$PYENV_ROOT/versions/$VENV_NAME" ]; then
    echo "⚠️  Виртуальное окружение '$VENV_NAME' уже существует. Удаляем старое..."
    pyenv virtualenv-delete -f $VENV_NAME
fi

pyenv virtualenv $PYTHON_VERSION $VENV_NAME
echo "✅ Виртуальное окружение создано"

# Активация окружения
echo ""
echo "Активация виртуального окружения..."
pyenv activate $VENV_NAME

# Проверка версии Python
echo ""
echo "Текущая версия Python:"
python --version

# Переход в директорию проекта
cd "$PROJECT_DIR"

# Установка DonkeyCar
echo ""
echo "Установка DonkeyCar с зависимостями для Raspberry Pi..."
pip install --upgrade pip setuptools wheel
pip install -e .[pi]

echo ""
echo "=== Установка завершена! ==="
echo ""
echo "Для активации окружения в будущем выполните:"
echo "  export PYENV_ROOT=\"\$HOME/.pyenv\""
echo "  export PATH=\"\$PYENV_ROOT/bin:\$PATH\""
echo "  eval \"\$(pyenv init - bash)\""
echo "  pyenv activate $VENV_NAME"
echo ""
echo "Проверка установки:"
python -c "import donkeycar; print('✅ DonkeyCar успешно установлен!')"
donkey --help | head -5

