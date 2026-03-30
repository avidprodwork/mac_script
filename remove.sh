#!/bin/bash

SUDOPASS="1111"

run_sudo() {
    echo "$SUDOPASS" | sudo -S "$@"
}

results=()

step() {
    local name="$1"
    local cmd="$2"
    echo ">>> $name..."
    if eval "$cmd"; then
        echo "✅ Успешно: $name"
        results+=("✅ $name")
    else
        echo "❌ Ошибка: $name"
        results+=("❌ $name")
    fi
}

# Удаление Dozer
step "Удаление Dozer" 'rm -rf "/Applications/user/Dozer.app" "/Applications/Dozer.app"'

# Удаление Keeper
step "Удаление Keeper" 'rm -rf "/Applications/Keeper Password Manager.app"'

# Удаление Cisdem AppCrypt
step "Удаление Cisdem AppCrypt" 'rm -rf "/Applications/user/Cisdem AppCrypt.app" "/Applications/Cisdem AppCrypt.app"'

# Удаление Unity Hub
step "Удаление Unity Hub" 'rm -rf "/Applications/Unity Hub.app"'

# Удаление RealVNC Server
step "Удаление RealVNC Server" 'rm -rf "/Applications/VNC Server.app" && run_sudo pkgutil --forget com.realvnc.vncserver'

# Удаление директорий
step "Удаление директорий" 'rm -rf ~/Desktop/Certifikates /Applications/user'

# Удаление файлов ALLOW/BLOCK
step "Удаление файлов ALLOW/BLOCK" 'rm -f ~/Desktop/AppCryptAllow.txt ~/Desktop/AppCryptBlock.txt ~/Desktop/Certifikates/SharedSecret.txt'

# Удаление Homebrew и пакетов
step "Удаление Homebrew" 'run_sudo rm -rf /opt/homebrew && rm -rf ~/.brew ~/.cask ~/.rbenv'

# Очистка Ruby и гемов
step "Удаление Ruby и rbenv" 'rm -rf ~/.rbenv ~/.gem'

# Очистка истории zsh
step "Очистка истории zsh" 'rm -f ~/.zsh_history && touch ~/.zsh_history'

# Итоговый отчёт
echo -e "\n===== ОТЧЁТ ====="
for r in "${results[@]}"; do
    echo "$r"
done
echo "================="
