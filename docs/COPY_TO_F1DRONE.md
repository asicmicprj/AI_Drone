# Инструкция по копированию donkeycar в репозиторий F1Drone

## Вариант 1: Через клонирование и копирование (рекомендуется)

```bash
# 1. Клонируем репозиторий F1Drone
cd ~/projects
git clone https://github.com/asicmicprj/F1Drone.git
cd F1Drone

# 2. Копируем всю папку donkeycar
cp -r ../donkeycar .

# 3. Добавляем в git и коммитим
git add donkeycar/
git commit -m "Add DonkeyCar with installation scripts and documentation"
git push origin main
```

## Вариант 2: Через добавление как submodule (если нужно сохранить историю)

```bash
cd ~/projects/F1Drone
git submodule add https://github.com/waveshareteam/donkeycar.git donkeycar
cd donkeycar
# Добавить наши изменения в submodule
git add INSTALLATION.md setup_donkeycar_full.sh REQUIREMENTS.txt QUICK_START.md README_INSTALL.md
git commit -m "Add installation documentation and scripts"
git push origin main
cd ..
git add .gitmodules donkeycar
git commit -m "Add DonkeyCar as submodule"
git push origin main
```

## Вариант 3: Создать архив и загрузить через веб-интерфейс

```bash
cd ~/projects
tar -czf donkeycar.tar.gz donkeycar/
# Затем загрузить через веб-интерфейс GitHub
```

## Список созданных файлов для добавления

Следующие файлы были созданы и должны быть добавлены в репозиторий:

1. `INSTALLATION.md` - Подробная инструкция по установке
2. `setup_donkeycar_full.sh` - Автоматический скрипт установки
3. `REQUIREMENTS.txt` - Системные зависимости
4. `QUICK_START.md` - Быстрый старт
5. `README_INSTALL.md` - Обзор документации

Все остальные файлы из donkeycar/ уже существуют в оригинальном репозитории.

