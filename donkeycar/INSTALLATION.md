# Установка DonkeyCar на Raspberry Pi 4 с Debian

Этот документ описывает установку DonkeyCar на Raspberry Pi 4 с последней версией Debian.

## Требования

- Raspberry Pi 4 (рекомендуется минимум 4GB RAM)
- Debian (последняя версия)
- Подключение к интернету
- Достаточно места на диске (~5GB для Python, ~2GB для DonkeyCar и зависимостей)

## Быстрая установка (рекомендуется)

Мы предоставляем автоматический скрипт установки, который установит все необходимое за один запуск:

```bash
cd ~/projects
./install_python_and_donkeycar.sh
```

Скрипт автоматически выполнит:
1. ✅ Установку всех системных зависимостей
2. ✅ Установку/проверку pyenv
3. ✅ Установку Python 3.11.9 с поддержкой всех модулей (ctypes, ssl, sqlite3 и др.)
4. ✅ Создание виртуального окружения `env` в папке `projects/`
5. ✅ Установку DonkeyCar со всеми зависимостями для Raspberry Pi
6. ✅ Проверку работоспособности всех компонентов

**Время установки:** ~30-70 минут (в зависимости от скорости интернета и производительности Raspberry Pi)

## Ручная установка (для опытных пользователей)

Если вы предпочитаете установку вручную, выполните следующие шаги:

### Шаг 1: Установка системных зависимостей

```bash
sudo apt-get update
sudo apt-get install -y \
  build-essential \
  libffi-dev \
  libssl-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  libncurses-dev \
  liblzma-dev \
  tk-dev \
  xz-utils \
  zlib1g-dev \
  libcap-dev \
  python3-dev \
  python3-pil \
  python3-smbus
```

**Важно:** `libffi-dev` критически необходим для работы модуля `ctypes` в Python.

### Шаг 2: Установка pyenv

```bash
curl https://pyenv.run | bash
```

Добавьте в `~/.bashrc`:

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
pyenv install 3.11.9
```

**Примечание:** Компиляция Python займет 20-40 минут на Raspberry Pi.

Проверьте установку:

```bash
pyenv versions
~/.pyenv/versions/3.11.9/bin/python --version
```

### Шаг 4: Создание виртуального окружения

```bash
cd ~/projects
~/.pyenv/versions/3.11.9/bin/python -m venv env
source env/bin/activate
```

Проверьте версию Python в окружении:

```bash
python --version  # Должно показать Python 3.11.9
```

### Шаг 5: Установка DonkeyCar

```bash
cd ~/projects/donkeycar
pip install --upgrade pip setuptools wheel
pip install -e .[pi]
```

**Примечание:** Установка зависимостей займет 10-30 минут.

### Шаг 6: Проверка установки

```bash
python -c "import donkeycar; print('DonkeyCar установлен!')"
python -c "import tensorflow as tf; print(f'TensorFlow {tf.__version__} установлен!')"
python -c "from donkeycar.parts import keras; print('Keras модуль работает!')"
donkey --help
```

## Использование после установки

### Активация виртуального окружения

```bash
cd ~/projects
source env/bin/activate
```

### Создание нового проекта DonkeyCar

```bash
cd ~/projects
source env/bin/activate
donkey createcar --path ~/mycar
```

### Деактивация окружения

```bash
deactivate
```

## Решение проблем

### Python не компилируется с поддержкой модулей

Убедитесь, что все системные зависимости установлены ДО компиляции Python. Если Python уже установлен без нужных модулей, переустановите его:

```bash
pyenv uninstall -f 3.11.9
pyenv install 3.11.9
```

### Ошибка при установке python-prctl

Установите `libcap-dev`:

```bash
sudo apt-get install -y libcap-dev
```

### TensorFlow не работает

Убедитесь, что используется Python 3.11 (TensorFlow 2.15 поддерживает только Python 3.11):

```bash
python --version  # Должно показать Python 3.11.x
```

### Команда donkey не найдена

Убедитесь, что виртуальное окружение активировано:

```bash
source ~/projects/env/bin/activate
which donkey  # Должно показать путь к команде
```

## Дополнительная информация

- Скрипт автоматической установки: `~/projects/install_python_and_donkeycar.sh`
- Системные зависимости: см. `REQUIREMENTS.txt`
- Официальная документация DonkeyCar: https://docs.donkeycar.com

