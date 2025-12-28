# Быстрый старт для Raspberry Pi 4 с Debian

## Автоматическая установка (рекомендуется)

Просто запустите скрипт установки:

```bash
cd ~/projects
./install_python_and_donkeycar.sh
```

Скрипт установит:
- Все системные зависимости
- Python 3.11.9 через pyenv
- Виртуальное окружение
- DonkeyCar со всеми зависимостями для Raspberry Pi

**Время установки:** ~30-70 минут

## Использование после установки

### 1. Активация окружения

```bash
cd ~/projects
source env/bin/activate
```

### 2. Создание нового проекта

```bash
donkey createcar --path ~/mycar
```

### 3. Проверка установки

```bash
donkey --help
python -c "import donkeycar; print('✅ DonkeyCar работает!')"
python -c "import tensorflow as tf; print(f'✅ TensorFlow {tf.__version__} работает!')"
```

### 4. Запуск автомобиля

```bash
cd ~/mycar
python manage.py drive
```

## Дополнительная информация

- Подробная инструкция: [INSTALLATION.md](INSTALLATION.md)
- Системные зависимости: [REQUIREMENTS.txt](REQUIREMENTS.txt)
- Официальная документация: https://docs.donkeycar.com

