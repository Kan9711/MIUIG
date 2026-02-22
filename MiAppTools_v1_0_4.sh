#!/bin/bash
# =====================================================
# MiAppTools v1.0.4 - Управление системными приложениями MIUI
# Bash-версия для Linux (оригинальный скрипт для Windows CMD)
# Автор оригинала: СЯО, СЭР! | youtube.com/XiaomiSir | t.me/XiaomiSir
# =====================================================

# --- Проверка ADB ---
check_adb() {
    if ! command -v adb &>/dev/null; then
        clear
        echo "Служба ADB отсутствует."
        echo "Установите ADB командой:"
        echo ""
        echo "  sudo dnf install android-tools"
        echo ""
        read -p "Нажмите Enter для повтора проверки..."
        check_adb
    fi
}

# --- Проверка подключённых устройств ---
check_device() {
    clear
    echo "Запуск службы ADB..."
    adb kill-server 2>/dev/null
    adb start-server 2>/dev/null

    local modelid
    modelid=$(adb devices | awk 'NR==2{print $1}')

    if [ -z "$modelid" ]; then
        clear
        echo "НЕТ ПОДКЛЮЧЁННЫХ УСТРОЙСТВ!"
        adb kill-server 2>/dev/null
        echo ""
        echo "Совет:"
        echo "- Включите Отладку по USB в настройках Для разработчиков."
        echo "- Подключите устройство к компьютеру."
        echo "- Разрешите отладку по USB для вашего компьютера во всплывающем окне устройства."
        echo ""
        read -p "Нажмите Enter для повтора..."
        check_device
    else
        clear
        echo "Устройство успешно найдено"
        echo "ID: $modelid"
    fi
}

# --- Функция паузы ---
pause() {
    echo ""
    read -p "Нажмите Enter для продолжения..."
}

# =====================================================
# ГЛАВНОЕ МЕНЮ
# =====================================================
menu() {
    while true; do
        clear
        echo "[ДЕЙСТВИЯ С СИСТЕМНЫМИ ПРИЛОЖЕНИЯМИ]"
        echo ""
        echo "1. Автоматическое удаление"
        echo "2. Автоматическое восстановление"
        echo "3. Выборочное расширенное удаление"
        echo "4. Выборочное расширенное восстановление"
        echo ""
        echo ""
        echo "9. Информация"
        echo "0. Выход"
        echo ""
        echo "__________________"
        read -p "Выберите действие: " var

        case "$var" in
            1) auto_del ;;
            2) auto_res ;;
            3) select_del ;;
            4) select_res ;;
            9) info ;;
            0) kill_exit ;;
        esac
    done
}

# =====================================================
# ИНФОРМАЦИЯ
# =====================================================
info() {
    clear
    echo "УПРАВЛЕНИЕ СИСТЕМНЫМИ ПРИЛОЖЕНИЯМИ MIUI"
    echo "Скрипт предназначен для быстрого и безопасного удаления и восстановления системных приложений"
    echo "на прошивках MIUI, которые нельзя удалить стандартными средствами."
    echo "Все действия вы совершаете на свой страх и риск."
    echo ""
    echo "Версия: 1.0.4"
    echo "______________________________________"
    echo "Автор: СЯО, СЭР!"
    echo "YouTube-канал: youtube.com/XiaomiSir"
    echo "Telegram-канал: t.me/XiaomiSir"
    echo "______________________________________"
    echo "ЗНАЧЕНИЯ СТРОК ПРИ УДАЛЕНИИ И ВОССТАНОВЛЕНИИ:"
    echo "Failure [not installed for 0] - Приложение уже отсутствует на устройстве."
    echo "Success - Приложение успешно удалено."
    echo "Package XXX installed for user: 0 - Приложение успешно восстановлено."
    echo "Package XXX doesn't exist - Приложения не было на вашем устройстве. Восстановить невозможно."
    echo "error: no devices/emulators found - Устройство не подключено."
    echo "______________________________________"
    echo "Информация по подключённому устройству:"
    adb devices
    echo "Если вы видите надпись:"
    echo "[XXXXX device] - устройство готово к работе."
    echo "[XXXXX unauthorized] - необходимо разрешить Отладку по USB для вашего компьютера."
    pause
    clear
}

# =====================================================
# ВЫХОД
# =====================================================
kill_exit() {
    adb kill-server 2>/dev/null
    exit 0
}

# =====================================================
# АВТОМАТИЧЕСКОЕ УДАЛЕНИЕ
# =====================================================
auto_del() {
    clear
    echo "УДАЛИТЬ ВСЕ СЛЕДУЮЩИЕ СЕРВИСЫ И ПРИЛОЖЕНИЯ С ДАННЫМИ?"
    echo "(Будут удалены только те, которые присутствуют на вашем устройстве."
    echo " Больше приложений можно удалить через режим выборочного удаления в главном меню."
    echo " Все действия вы совершаете на свой страх и риск.)"
    echo ""
    echo " - Сервисы аналитики и рекламы MIUI"
    echo " - Сервисы Facebook"
    echo " - Сервисы Netflix"
    echo " - Сервисы Amazon"
    echo " - Сервисы Mi Pay India"
    echo " - Google Duo"
    echo " - Google One"
    echo " - Google Фото"
    echo " - Google Музыка"
    echo " - Google Фильмы"
    echo " - Google Device Health Services (аналитика батареи от Google)"
    echo " - Google Gmail (почтовый клиент)"
    echo " - Магазин приложений GetApps (Mi Picks)"
    echo " - Игры Xiaomi"
    echo " - Карусель обоев"
    echo " - ShareMe (обмен файлами)"
    echo "__________________"
    echo ""
    echo "1. ДА, удалить все"
    echo "2. НЕТ, вернуться в меню"
    echo "__________________"
    read -p "Выберите действие: " var

    case "$var" in
        1) auto_del_run ;;
        2) return ;;
    esac
}

auto_del_run() {
    clear
    echo "Удаление: Сервисы аналитики и рекламы MIUI"
    adb shell pm uninstall --user 0 com.miui.analytics
    adb shell pm uninstall --user 0 com.miui.msa.global

    echo "Удаление: Сервисы Facebook"
    adb shell pm uninstall --user 0 com.facebook.services
    adb shell pm uninstall --user 0 com.facebook.system
    adb shell pm uninstall --user 0 com.facebook.appmanager

    echo "Удаление: Сервисы Netflix"
    adb shell pm uninstall --user 0 com.netflix.partner.activation

    echo "Удаление: Сервисы Amazon"
    adb shell pm uninstall --user 0 com.amazon.mShop.android.shopping
    adb shell pm uninstall --user 0 com.amazon.appmanager

    echo "Удаление: Mi Pay India"
    adb shell pm uninstall --user 0 com.mipay.wallet.in

    echo "Удаление: Google Duo"
    adb shell pm uninstall --user 0 com.google.android.apps.tachyon

    echo "Удаление: Google One"
    adb shell pm uninstall --user 0 com.google.android.apps.subscriptions.red

    echo "Удаление: Google Музыка"
    adb shell pm uninstall --user 0 com.google.android.music

    echo "Удаление: Google Фильмы"
    adb shell pm uninstall --user 0 com.google.android.videos

    echo "Удаление: Google Device Health Services"
    adb shell pm uninstall --user 0 com.google.android.apps.turbo

    echo "Удаление: Gmail"
    adb shell pm uninstall --user 0 com.google.android.gm

    echo "Удаление: Google Фото"
    adb shell pm uninstall --user 0 com.google.android.apps.photos

    echo "Удаление: Магазин приложений GetApps (Mi Picks)"
    adb shell pm uninstall --user 0 com.xiaomi.mipicks

    echo "Удаление: Игры Xiaomi"
    adb shell pm uninstall --user 0 com.xiaomi.glgm

    echo "Удаление: Карусель обоев"
    adb shell pm uninstall --user 0 com.miui.android.fashiongallery

    echo "Удаление: ShareMe"
    adb shell pm uninstall --user 0 com.xiaomi.midrop

    echo ""
    echo "ГОТОВО!"
    pause
    clear
}

# =====================================================
# АВТОМАТИЧЕСКОЕ ВОССТАНОВЛЕНИЕ
# =====================================================
auto_res() {
    clear
    echo "ВОССТАНОВИТЬ ВСЕ СЛЕДУЮЩИЕ СЕРВИСЫ И ПРИЛОЖЕНИЯ?"
    echo "(Будут восстановлены только те, которые присутствуют в системной памяти вашего устройства."
    echo " Все действия вы совершаете на свой страх и риск.)"
    echo ""
    echo " - Сервисы аналитики и рекламы MIUI"
    echo " - Сервисы Facebook"
    echo " - Сервисы Netflix"
    echo " - Сервисы Amazon"
    echo " - Сервисы Mi Pay India"
    echo " - Google Duo"
    echo " - Google One"
    echo " - Google Фото"
    echo " - Google Музыка"
    echo " - Google Фильмы"
    echo " - Google Device Health Services"
    echo " - Google Gmail"
    echo " - Магазин приложений GetApps (Mi Picks)"
    echo " - Игры Xiaomi"
    echo " - Карусель обоев"
    echo " - ShareMe"
    echo "__________________"
    echo ""
    echo "1. ДА, восстановить все"
    echo "2. НЕТ, вернуться в меню"
    echo "__________________"
    read -p "Выберите действие: " var

    case "$var" in
        1) auto_res_run ;;
        2) return ;;
    esac
}

auto_res_run() {
    clear
    echo "Восстановление: Сервисы аналитики и рекламы MIUI"
    adb shell pm install-existing --user 0 com.miui.analytics
    adb shell pm install-existing --user 0 com.miui.msa.global

    echo "Восстановление: Сервисы Facebook"
    adb shell pm install-existing --user 0 com.facebook.services
    adb shell pm install-existing --user 0 com.facebook.system
    adb shell pm install-existing --user 0 com.facebook.appmanager

    echo "Восстановление: Сервисы Netflix"
    adb shell pm install-existing --user 0 com.netflix.partner.activation

    echo "Восстановление: Сервисы Amazon"
    adb shell pm install-existing --user 0 com.amazon.mShop.android.shopping
    adb shell pm install-existing --user 0 com.amazon.appmanager

    echo "Восстановление: Mi Pay India"
    adb shell pm install-existing --user 0 com.mipay.wallet.in

    echo "Восстановление: Google Duo"
    adb shell pm install-existing --user 0 com.google.android.apps.tachyon

    echo "Восстановление: Google One"
    adb shell pm install-existing --user 0 com.google.android.apps.subscriptions.red

    echo "Восстановление: Google Музыка"
    adb shell pm install-existing --user 0 com.google.android.music

    echo "Восстановление: Google Фильмы"
    adb shell pm install-existing --user 0 com.google.android.videos

    echo "Восстановление: Google Device Health Services"
    adb shell pm install-existing --user 0 com.google.android.apps.turbo

    echo "Восстановление: Gmail"
    adb shell pm install-existing --user 0 com.google.android.gm

    echo "Восстановление: Google Фото"
    adb shell pm install-existing --user 0 com.google.android.apps.photos

    echo "Восстановление: Магазин приложений GetApps (Mi Picks)"
    adb shell pm install-existing --user 0 com.xiaomi.mipicks

    echo "Восстановление: Игры Xiaomi"
    adb shell pm install-existing --user 0 com.xiaomi.glgm

    echo "Восстановление: Карусель обоев"
    adb shell pm install-existing --user 0 com.miui.android.fashiongallery

    echo "Восстановление: ShareMe"
    adb shell pm install-existing --user 0 com.xiaomi.midrop

    echo ""
    echo "ГОТОВО!"
    pause
    clear
}

# =====================================================
# ВЫБОРОЧНОЕ УДАЛЕНИЕ
# =====================================================
select_del() {
    while true; do
        clear
        echo "ВЫБЕРИТЕ КАТЕГОРИЮ:"
        echo ""
        echo "1. Приложения и сервисы MIUI"
        echo "2. Приложения и сервисы Google"
        echo ""
        echo "0. Вернуться в меню"
        echo "__________________"
        read -p "Введите номер приложения: " var

        case "$var" in
            1) select_del_miui ;;
            2) select_del_google ;;
            0) return ;;
        esac
    done
}

select_del_miui() {
    while true; do
        clear
        echo "ВЫБЕРИТЕ ПРИЛОЖЕНИЕ ДЛЯ УДАЛЕНИЯ:"
        echo ""
        echo " 1. Сервисы аналитики и рекламы MIUI"
        echo " 2. Сервисы Facebook"
        echo " 3. Сервисы Netflix"
        echo " 4. Сервисы Amazon"
        echo " 5. Сервисы Mi Pay India"
        echo " 6. Магазин приложений GetApps (Mi Picks)"
        echo " 7. Игры Xiaomi"
        echo " 8. Карусель обоев"
        echo " 9. Mi Браузер"
        echo "10. ShareMe"
        echo "11. Галерея"
        echo "12. Заметки"
        echo "13. Mi видео"
        echo "14. Календарь MIUI"
        echo "15. Меню SIM-карты"
        echo "16. Отчеты"
        echo "17. Погода"
        echo "18. Проводник"
        echo ""
        echo "0. Вернуться назад"
        echo "__________________"
        read -p "Введите номер приложения: " var

        case "$var" in
            1)  confirm_del "Сервисы аналитики и рекламы MIUI" "Приложения для аналитики и отображения рекламы в стандартных приложениях MIUI."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.miui.analytics && adb shell pm uninstall --user 0 com.miui.msa.global ;;
            2)  confirm_del "Сервисы Facebook" "Сервисы для Facebook."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.facebook.services && adb shell pm uninstall --user 0 com.facebook.system && adb shell pm uninstall --user 0 com.facebook.appmanager ;;
            3)  confirm_del "Сервисы Netflix" "Партнёрское приложение сервиса Netflix для управления подпиской."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.netflix.partner.activation ;;
            4)  confirm_del "Сервисы Amazon" "Сервисы для онлайн-магазина Amazon."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.amazon.mShop.android.shopping && adb shell pm uninstall --user 0 com.amazon.appmanager ;;
            5)  confirm_del "Сервисы Mi Pay India" "Сервис платежей для Индии."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.mipay.wallet.in ;;
            6)  confirm_del "Магазин приложений GetApps (Mi Picks)" "Фирменный магазин приложений MIUI."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.xiaomi.mipicks ;;
            7)  confirm_del "Игры Xiaomi" "Фирменный магазин игр MIUI."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.xiaomi.glgm ;;
            8)  confirm_del "Карусель обоев" "Приложение для автоматической смены онлайн-обоев."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.miui.android.fashiongallery ;;
            9)  confirm_del "Mi Браузер" "Фирменный браузер MIUI."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.mi.globalbrowser ;;
            10) confirm_del "ShareMe" "Приложение для обмена файлами по сети Wi-Fi."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.xiaomi.midrop ;;
            11) confirm_del "Галерея" "Стандартное приложение галереи MIUI. Удалять не рекомендуется."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.miui.gallery ;;
            12) confirm_del "Заметки" "Стандартное приложение заметок MIUI. Удалять не рекомендуется."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.miui.notes ;;
            13) confirm_del "Mi видео" "Стандартное приложение Mi видео. Удалять не рекомендуется. Без него видео могут не воспроизводиться."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.miui.video && adb shell pm uninstall --user 0 com.miui.videoplayer ;;
            14) confirm_del "Календарь MIUI" "Стандартный календарь MIUI. Рекомендуется только если вы пользуетесь другим календарём."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.xiaomi.calendar ;;
            15) confirm_del "Меню SIM-карты" "Встроенное меню SIM-карты. Удаление не влияет на работоспособность системы и связи."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.android.stk ;;
            16) confirm_del "Отчеты" "Приложение для отправки системных отчётов о сбоях MIUI."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.miui.bugreport ;;
            17) confirm_del "Погода" "Системное приложение Погоды. Удаление может повлиять на отображение прогноза на иконках и виджетах MIUI."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.miui.weather2 ;;
            18) confirm_del "Проводник" "Стандартный проводник MIUI."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.mi.android.globalFileexplorer && adb shell pm uninstall --user 0 com.android.fileexplorer ;;
            0) return ;;
        esac

        echo ""
        echo "ГОТОВО!"
        pause
    done
}

select_del_google() {
    while true; do
        clear
        echo "ВЫБЕРИТЕ ПРИЛОЖЕНИЕ ДЛЯ УДАЛЕНИЯ:"
        echo ""
        echo " 1. Google Duo"
        echo " 2. Google One"
        echo " 3. Google Ассистент"
        echo " 4. Google Календарь"
        echo " 5. Google Карты"
        echo " 6. Google Музыка"
        echo " 7. Google Объектив"
        echo " 8. Google Поиск"
        echo " 9. Google Фильмы"
        echo "10. Google Фото"
        echo "11. Google Device Health Services"
        echo "12. Android Auto"
        echo "13. Chrome"
        echo "14. Gmail"
        echo "15. YouTube"
        echo ""
        echo "0. Вернуться назад"
        echo "__________________"
        read -p "Введите номер приложения: " var

        case "$var" in
            1)  confirm_del "Google Duo" "Видеочат от Google."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.google.android.apps.tachyon ;;
            2)  confirm_del "Google One" "Служба подписки от Google, которая предлагает расширенное облачное хранилище."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.google.android.apps.subscriptions.red ;;
            3)  confirm_del "Google Ассистент" "Облачный сервис персонального ассистента от Google с голосовым управлением."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.google.android.apps.googleassistant ;;
            4)  confirm_del "Google Календарь" "Стандартный календарь от Google. Удалять рекомендуется только если вы пользуетесь другим календарём."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.google.android.calendar ;;
            5)  confirm_del "Google Карты" "Стандартное приложение с онлайн-картами от Google."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.google.android.apps.maps ;;
            6)  confirm_del "Google Музыка" "Сервис потокового вещания музыки и подкастов от Google."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.google.android.music ;;
            7)  confirm_del "Google Объектив" "Сервис распознавания изображений через камеру смартфона от Google."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.google.ar.lens ;;
            8)  confirm_del "Google Поиск" "Базовое приложение Google."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.google.android.googlequicksearchbox ;;
            9)  confirm_del "Google Фильмы" "Онлайн-кинотеатр от Google."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.google.android.videos ;;
            10) confirm_del "Google Фото" "Галерея от Google с возможностью синхронизации."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.google.android.apps.photos ;;
            11) confirm_del "Google Device Health Services" "Аналитика заряда батареи от Google. Работает пока только в США."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.google.android.apps.turbo ;;
            12) confirm_del "Android Auto" "Приложение для автомобилей от Google."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.google.android.projection.gearhead ;;
            13) confirm_del "Chrome" "Браузер от Google."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.android.chrome ;;
            14) confirm_del "Gmail" "Почтовый клиент от Google."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.google.android.gm ;;
            15) confirm_del "YouTube" "Клиент для просмотра видео на YouTube."
                [ $? -eq 0 ] && adb shell pm uninstall --user 0 com.google.android.youtube ;;
            0) return ;;
        esac

        echo ""
        echo "ГОТОВО!"
        pause
    done
}

# =====================================================
# ВЫБОРОЧНОЕ ВОССТАНОВЛЕНИЕ
# =====================================================
select_res() {
    while true; do
        clear
        echo "ВЫБЕРИТЕ КАТЕГОРИЮ:"
        echo ""
        echo "1. Приложения и сервисы MIUI"
        echo "2. Приложения и сервисы Google"
        echo ""
        echo "0. Вернуться в меню"
        echo "__________________"
        read -p "Введите номер приложения: " var

        case "$var" in
            1) select_res_miui ;;
            2) select_res_google ;;
            0) return ;;
        esac
    done
}

select_res_miui() {
    while true; do
        clear
        echo "ВЫБЕРИТЕ ПРИЛОЖЕНИЕ ДЛЯ ВОССТАНОВЛЕНИЯ:"
        echo ""
        echo " 1. Сервисы аналитики и рекламы MIUI"
        echo " 2. Сервисы Facebook"
        echo " 3. Сервисы Netflix"
        echo " 4. Сервисы Amazon"
        echo " 5. Сервисы Mi Pay India"
        echo " 6. Магазин приложений GetApps (Mi Picks)"
        echo " 7. Игры Xiaomi"
        echo " 8. Карусель обоев"
        echo " 9. Mi Браузер"
        echo "10. ShareMe"
        echo "11. Галерея"
        echo "12. Заметки"
        echo "13. Mi видео"
        echo "14. Календарь MIUI"
        echo "15. Меню SIM-карты"
        echo "16. Отчеты"
        echo "17. Погода"
        echo "18. Проводник"
        echo ""
        echo "0. Вернуться назад"
        echo "__________________"
        read -p "Введите номер приложения: " var

        case "$var" in
            1)  confirm_res "Сервисы аналитики и рекламы MIUI"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.miui.analytics && adb shell pm install-existing --user 0 com.miui.msa.global ;;
            2)  confirm_res "Сервисы Facebook"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.facebook.services && adb shell pm install-existing --user 0 com.facebook.system && adb shell pm install-existing --user 0 com.facebook.appmanager ;;
            3)  confirm_res "Сервисы Netflix"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.netflix.partner.activation ;;
            4)  confirm_res "Сервисы Amazon"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.amazon.mShop.android.shopping && adb shell pm install-existing --user 0 com.amazon.appmanager ;;
            5)  confirm_res "Сервисы Mi Pay India"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.mipay.wallet.in ;;
            6)  confirm_res "Магазин приложений GetApps (Mi Picks)"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.xiaomi.mipicks ;;
            7)  confirm_res "Игры Xiaomi"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.xiaomi.glgm ;;
            8)  confirm_res "Карусель обоев"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.miui.android.fashiongallery ;;
            9)  confirm_res "Mi Браузер"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.mi.globalbrowser ;;
            10) confirm_res "ShareMe"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.xiaomi.midrop ;;
            11) confirm_res "Галерея"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.miui.gallery ;;
            12) confirm_res "Заметки"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.miui.notes ;;
            13) confirm_res "Mi видео"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.miui.video && adb shell pm install-existing --user 0 com.miui.videoplayer ;;
            14) confirm_res "Календарь MIUI"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.xiaomi.calendar ;;
            15) confirm_res "Меню SIM-карты"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.android.stk ;;
            16) confirm_res "Отчеты"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.miui.bugreport ;;
            17) confirm_res "Погода"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.miui.weather2 ;;
            18) confirm_res "Проводник"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.mi.android.globalFileexplorer && adb shell pm install-existing --user 0 com.android.fileexplorer ;;
            0) return ;;
        esac

        echo ""
        echo "ГОТОВО!"
        pause
    done
}

select_res_google() {
    while true; do
        clear
        echo "ВЫБЕРИТЕ ПРИЛОЖЕНИЕ ДЛЯ ВОССТАНОВЛЕНИЯ:"
        echo ""
        echo " 1. Google Duo"
        echo " 2. Google One"
        echo " 3. Google Ассистент"
        echo " 4. Google Календарь"
        echo " 5. Google Карты"
        echo " 6. Google Музыка"
        echo " 7. Google Объектив"
        echo " 8. Google Поиск"
        echo " 9. Google Фильмы"
        echo "10. Google Фото"
        echo "11. Google Device Health Services"
        echo "12. Android Auto"
        echo "13. Chrome"
        echo "14. Gmail"
        echo "15. YouTube"
        echo ""
        echo "0. Вернуться назад"
        echo "__________________"
        read -p "Введите номер приложения: " var

        case "$var" in
            1)  confirm_res "Google Duo"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.google.android.apps.tachyon ;;
            2)  confirm_res "Google One"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.google.android.apps.subscriptions.red ;;
            3)  confirm_res "Google Ассистент"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.google.android.apps.googleassistant ;;
            4)  confirm_res "Google Календарь"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.google.android.calendar ;;
            5)  confirm_res "Google Карты"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.google.android.apps.maps ;;
            6)  confirm_res "Google Музыка"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.google.android.music ;;
            7)  confirm_res "Google Объектив"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.google.ar.lens ;;
            8)  confirm_res "Google Поиск"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.google.android.googlequicksearchbox ;;
            9)  confirm_res "Google Фильмы"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.google.android.videos ;;
            10) confirm_res "Google Фото"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.google.android.apps.photos ;;
            11) confirm_res "Google Device Health Services"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.google.android.apps.turbo ;;
            12) confirm_res "Android Auto"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.google.android.projection.gearhead ;;
            13) confirm_res "Chrome"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.android.chrome ;;
            14) confirm_res "Gmail"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.google.android.gm ;;
            15) confirm_res "YouTube"
                [ $? -eq 0 ] && adb shell pm install-existing --user 0 com.google.android.youtube ;;
            0) return ;;
        esac

        echo ""
        echo "ГОТОВО!"
        pause
    done
}

# =====================================================
# ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ПОДТВЕРЖДЕНИЯ
# =====================================================
confirm_del() {
    local name="$1"
    local desc="$2"
    clear
    echo "Удалить $name?"
    [ -n "$desc" ] && echo "$desc"
    echo ""
    echo "1. ДА, удалить"
    echo "2. НЕТ, вернуться назад"
    echo "__________________"
    read -p "Выберите действие: " confirm
    if [ "$confirm" == "1" ]; then
        echo ""
        return 0
    else
        return 1
    fi
}

confirm_res() {
    local name="$1"
    clear
    echo "Восстановить $name?"
    echo ""
    echo "1. ДА, восстановить"
    echo "2. НЕТ, вернуться назад"
    echo "__________________"
    read -p "Выберите действие: " confirm
    if [ "$confirm" == "1" ]; then
        echo ""
        return 0
    else
        return 1
    fi
}

# =====================================================
# ТОЧКА ВХОДА
# =====================================================
check_adb
check_device
menu
