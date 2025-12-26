#!/bin/bash
# Скрипт для проверки статуса установки Python 3.11 через pyenv

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)" 2>/dev/null

echo "=== Статус установки Python 3.11 ==="
echo ""

# Проверка процессов установки
PROCESSES=$(ps aux | grep -E "python-build|pyenv install" | grep -v grep | wc -l)
if [ "$PROCESSES" -gt 0 ]; then
    echo "⏳ Установка Python 3.11 все еще идет... ($PROCESSES процессов)"
else
    echo "✅ Процессы установки не найдены"
fi

echo ""

# Проверка установленных версий
echo "Установленные версии Python через pyenv:"
pyenv versions 2>&1

echo ""

# Проверка директории versions
if [ -d "$PYENV_ROOT/versions/3.11.9" ]; then
    echo "✅ Python 3.11.9 найден в ~/.pyenv/versions/3.11.9"
    echo ""
    echo "Для создания виртуального окружения выполните:"
    echo "  export PYENV_ROOT=\"\$HOME/.pyenv\""
    echo "  export PATH=\"\$PYENV_ROOT/bin:\$PATH\""
    echo "  eval \"\$(pyenv init - bash)\""
    echo "  pyenv virtualenv 3.11.9 donkeycar-311"
    echo "  pyenv activate donkeycar-311"
else
    echo "⏳ Python 3.11.9 еще не установлен"
fi

