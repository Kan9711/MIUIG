# MiAppTools v1.0.4 (Linux Bash)

Скрипт для безопасного удаления и восстановления системных приложений (bloatware) на устройствах Xiaomi/MIUI через ADB без Root-прав. Портированная Bash-версия оригинального CMD-скрипта.

## Требования
1. ОС Linux.
2. Включенная **Отладка по USB** на Android-устройстве (в меню "Для разработчиков").
3. Пакет `adb`.

## Установка и запуск

1. **Установите ADB** (если отсутствует):
   * Ubuntu/Debian: `sudo apt install adb`
   * Fedora: `sudo dnf install android-tools`
   * Arch Linux: `sudo pacman -S android-tools`

2. **Клонируйте репозиторий**:
   ```bash
   git clone [https://github.com/Kan9711/MIUIG.git](https://github.com/Kan9711/MIUIG.git)
   cd MIUIG

3. **Сделайте скрипт исполняемым и запустите**:
   ```bash
   chmod +x MiAppTools_v1_0_4.sh
   ./MiAppTools_v1_0_4.sh
