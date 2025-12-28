# Быстрый старт - Установка DonkeyCar

## Автоматическая установка (рекомендуется)

```bash
cd ~/projects/donkeycar
chmod +x setup_donkeycar_full.sh
./setup_donkeycar_full.sh
```

Скрипт автоматически:
- Установит все системные зависимости (включая критически важный libffi-dev)
- Установит pyenv (если его нет)
- Установит Python 3.11.9
- Создаст виртуальное окружение
- Установит DonkeyCar со всеми зависимостями для Raspberry Pi
- Проверит работоспособность

## Что нужно передать чат-боту для установки

Если вы хотите установить DonkeyCar с нуля, сообщите чат-боту:

```
Мне нужно установить DonkeyCar для Raspberry Pi.
Используй скрипт setup_donkeycar_full.sh в директории ~/projects/donkeycar
Или следуй инструкциям из файла INSTALLATION.md

Ключевые требования:
- Python 3.11.9 (обязательно, через pyenv)
- Перед установкой Python ОБЯЗАТЕЛЬНО установить libffi-dev (для ctypes)
- Виртуальное окружение env с Python 3.11.9
- Установка: pip install -e .[pi]
```

## Важные моменты для чат-бота

1. **ПОРЯДОК УСТАНОВКИ КРИТИЧЕСКИ ВАЖЕН:**
   - Сначала: `sudo apt-get install -y libffi-dev`
   - Затем: установка Python 3.11.9 через pyenv
   - Только потом: создание виртуального окружения

2. **Версия Python:**
   - Требуется строго Python 3.11.9
   - tensorflow-aarch64==2.15.* работает ТОЛЬКО с Python 3.11
   - Не используйте Python 3.12 или 3.13!

3. **Проверка после установки:**
   ```bash
   source env/bin/activate
   python -c "import ctypes; import tensorflow as tf; from donkeycar.parts import keras; print('OK')"
   ```

4. **Если ctypes не работает:**
   - Python был скомпилирован без libffi-dev
   - Решение: переустановить Python 3.11.9 после установки libffi-dev

