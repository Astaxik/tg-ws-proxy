# TG WS Proxy для Linux

## Установка зависимостей

### Debian/Ubuntu/Mint:
```bash
sudo apt-get update
sudo apt-get install -y python3-tk zenity xdg-utils libayatana-appindicator3-1 gir1.2-ayatanaappindicator3-0.1
pip3 install customtkinter pystray pyperclip psutil pillow
```

### Fedora:
```bash
sudo dnf install python3-tkinter zenity xdg-utils libappindicator-gtk3
pip3 install customtkinter pystray pyperclip psutil pillow
```

### Arch Linux:
```bash
sudo pacman -S tk zenity xdg-utils libappindicator-gtk3
pip3 install customtkinter pystray pyperclip psutil pillow
```

## Запуск

### Графический режим (с интерфейсом):
```bash
python3 linux.py
```

### Фоновый режим (без GUI, для серверов):
```bash
python3 linux.py --background
# или
python3 linux.py --daemon
```

### Использование скрипта управления:
```bash
# Запуск в фоне
./tg-ws-proxy.sh start

# Остановка
./tg-ws-proxy.sh stop

# Перезапуск
./tg-ws-proxy.sh restart

# Проверка статуса
./tg-ws-proxy.sh status

# Просмотр логов в реальном времени
./tg-ws-proxy.sh logs
```

### Автозагрузка при старте системы (systemd):

Создайте файл `~/.config/systemd/user/tg-ws-proxy.service`:
```ini
[Unit]
Description=TG WS Proxy
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 /путь/к/linux.py --background
Restart=always
WorkingDirectory=/путь/к/папке

[Install]
WantedBy=default.target
```

Активируйте:
```bash
systemctl --user daemon-reload
systemctl --user enable tg-ws-proxy.service
systemctl --user start tg-ws-proxy.service
```

## Режимы работы

Приложение автоматически определяет доступный режим:

1. **Системный трей (pystray)** - если доступны библиотеки AppIndicator и есть X11/Wayland сессия
   - Иконка появляется в системном трее
   - Все функции доступны через контекстное меню

2. **Оконный интерфейс (tkinter)** - если pystray недоступен, но есть графическая сессия
   - Открывается окно с кнопками управления
   - Все функции доступны через кнопки

3. **Консольный режим** - если нет графической сессии (SSH, daemon)
   - Прокси работает в фоне
   - Остановка по Ctrl+C

## Функции

- Автоматический запуск прокси при старте
- Настройка параметров (порт, хост, DC-IP маппинги)
- Быстрое подключение к Telegram
- Просмотр логов
- Перезапуск прокси

## Файлы

- Конфигурация: `~/.config/TgWsProxy/config.json`
- Логи: `~/.config/TgWsProxy/proxy.log`
- Иконка: `icon.png` (в папке с программой)

## Решение проблем

### Ошибка "Namespace AppIndicator3 not available"
Установите пакеты:
```bash
sudo apt-get install libayatana-appindicator3-1 gir1.2-ayatanaappindicator3-0.1
```

### Ошибка "no display name and no $DISPLAY"
Запустите в графической сессии или используйте консольный режим.

### Иконка не отображается в трее
Убедитесь, что ваш DE поддерживает AppIndicator (GNOME требует расширение).
