# Инструкция по установке DonkeyCar для Raspberry Pi

## Требования

- **ОС**: Debian/Ubuntu (протестировано на Debian 13)
- **Python**: 3.11.9 (обязательно, так как tensorflow-aarch64==2.15.* поддерживает только Python 3.11)
- **Системные зависимости**: см. ниже

## Критически важные системные библиотеки

Перед установкой Python 3.11.9 через pyenv **обязательно** установите:

```bash
sudo apt-get update
sudo apt-get install -y libffi-dev
```

**Без libffi-dev модуль ctypes не будет работать, что критично для TensorFlow!**

Рекомендуемые зависимости для компиляции Python:
```bash
sudo apt-get install -y \
    build-essential \
    libssl-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev
```

## Автоматическая установка

Используйте скрипт `setup_donkeycar_full.sh` для автоматической установки:

```bash
chmod +x setup_donkeycar_full.sh
./setup_donkeycar_full.sh
```

## Ручная установка

### Шаг 1: Установка системных зависимостей

```bash
sudo apt-get update
sudo apt-get install -y libffi-dev build-essential libssl-dev libbz2-dev \
    libreadline-dev libsqlite3-dev libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev liblzma-dev
```

### Шаг 2: Установка pyenv

```bash
curl https://pyenv.run | bash
```

Добавьте в `~/.bashrc` или `~/.profile`:
```bash
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
```

Перезагрузите терминал или выполните:
```bash
source ~/.bashrc
```

### Шаг 3: Установка Python 3.11.9

```bash
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

pyenv install 3.11.9
```

**Важно**: Убедитесь, что libffi-dev установлен ДО компиляции Python!

### Шаг 4: Создание виртуального окружения

```bash
cd ~/projects/donkeycar
~/.pyenv/versions/3.11.9/bin/python -m venv env
source env/bin/activate
```

### Шаг 5: Установка DonkeyCar

```bash
cd ~/projects/donkeycar
source env/bin/activate
pip install --upgrade pip setuptools wheel
pip install -e .[pi]
```

### Шаг 6: Проверка установки

```bash
source env/bin/activate
python -c "import ctypes; import tensorflow as tf; from donkeycar.parts import keras; print('✅ Все работает!')"
donkey --help
```

## Проверка совместимости версий

- Python: **3.11.9** (строго требуется для tensorflow-aarch64==2.15.*)
- TensorFlow: **2.15.1** (tensorflow-aarch64)
- DonkeyCar: **5.2.dev5**

## Возможные проблемы

### Ошибка "No module named '_ctypes'"

**Причина**: Python был скомпилирован без libffi-dev

**Решение**: 
1. Установите libffi-dev: `sudo apt-get install -y libffi-dev`
2. Переустановите Python 3.11.9: `pyenv uninstall -f 3.11.9 && pyenv install 3.11.9`

### Ошибка "Package requires a different Python"

**Причина**: Проект требует Python 3.11, но установлен другой

**Решение**: Используйте Python 3.11.9 через pyenv (см. шаг 3)

## Использование

После установки активируйте окружение:
```bash
cd ~/projects/donkeycar
source env/bin/activate
donkey --help
```

Создание нового проекта:
```bash
donkey createcar --path ~/mycar --template complete
```

