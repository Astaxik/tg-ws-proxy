#!/bin/bash
# TgWsProxy - запускает прокси в фоновом режиме

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_NAME="TgWsProxy"
PID_FILE="$HOME/.config/$APP_NAME/proxy.pid"
LOG_FILE="$HOME/.config/$APP_PROXY/proxy.log"

# Ensure config directory exists
mkdir -p "$HOME/.config/$APP_NAME"

case "$1" in
    start)
        if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
            echo "$APP_NAME уже запущен (PID: $(cat $PID_FILE))"
            exit 1
        fi
        
        echo "Запуск $APP_NAME..."
        cd "$SCRIPT_DIR"
        nohup python3 linux.py --background > /dev/null 2>&1 &
        echo $! > "$PID_FILE"
        echo "$APP_NAME запущен (PID: $!)"
        ;;
    
    stop)
        if [ -f "$PID_FILE" ]; then
            PID=$(cat "$PID_FILE")
            if kill -0 "$PID" 2>/dev/null; then
                echo "Остановка $APP_NAME (PID: $PID)..."
                kill "$PID"
                sleep 2
                if kill -0 "$PID" 2>/dev/null; then
                    kill -9 "$PID"
                fi
                rm -f "$PID_FILE"
                echo "$APP_NAME остановлен"
            else
                echo "$APP_NAME не запущен"
                rm -f "$PID_FILE"
            fi
        else
            echo "Файл PID не найден. $APP_NAME не запущен?"
        fi
        ;;
    
    restart)
        $0 stop
        sleep 1
        $0 start
        ;;
    
    status)
        if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
            echo "$APP_NAME запущен (PID: $(cat $PID_FILE))"
        else
            echo "$APP_NAME не запущен"
        fi
        ;;
    
    logs)
        if [ -f "$LOG_FILE" ]; then
            tail -f "$LOG_FILE"
        else
            echo "Лог файл не найден"
        fi
        ;;
    
    *)
        echo "Использование: $0 {start|stop|restart|status|logs}"
        exit 1
        ;;
esac

exit 0
