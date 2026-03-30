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

# Установка Homebrew (ты сам нажмёшь Enter)
step "Установка Homebrew" '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

# Настройка окружения brew
step "Настройка окружения brew" 'echo "eval \"$(/opt/homebrew/bin/brew shellenv)\"" >> /Users/$USER/.zprofile && eval "$(/opt/homebrew/bin/brew shellenv)"'

# Установка Dozer
step "Установка Dozer" 'curl -L -o ~/Downloads/Dozer.dmg https://github.com/Mortennn/Dozer/releases/download/v4.0.0/Dozer.4.0.0.dmg && hdiutil attach ~/Downloads/Dozer.dmg && cp -r /Volumes/Dozer/Dozer.app /Applications && hdiutil detach /Volumes/Dozer && rm ~/Downloads/Dozer.dmg'

# Установка Keeper
step "Установка Keeper" 'curl -L -o ~/Downloads/Keeper.dmg https://www.keepersecurity.com/desktop_electron/Darwin/KeeperSetup.dmg && hdiutil attach ~/Downloads/Keeper.dmg && cp -r "/Volumes/Keeper Password Manager/Keeper Password Manager.app" /Applications && hdiutil detach "/Volumes/Keeper Password Manager" && rm ~/Downloads/Keeper.dmg'

# Установка Cisdem AppCrypt
step "Установка Cisdem AppCrypt" 'curl -L -o ~/Downloads/Cisdem.dmg https://download.cisdem.com/cisdem-appcrypt.dmg && hdiutil attach ~/Downloads/Cisdem.dmg && cp -r "/Volumes/Cisdem AppCrypt/Cisdem AppCrypt.app" /Applications && hdiutil detach "/Volumes/Cisdem AppCrypt" && rm ~/Downloads/Cisdem.dmg'

# Установка Unity Hub
step "Установка Unity Hub" 'curl -L -o ~/Downloads/UnityHub.dmg https://public-cdn.cloud.unity3d.com/hub/prod/UnityHubSetup.dmg && hdiutil attach ~/Downloads/UnityHub.dmg && cp -r "/Volumes/Unity Hub 3.11.1/Unity Hub.app" /Applications && hdiutil detach "/Volumes/Unity Hub 3.11.1" && rm ~/Downloads/UnityHub.dmg'

# Создание директорий
step "Создание директорий" 'mkdir -p /Applications/user ~/Desktop/Certifikates && chflags hidden /Applications/user'

# Перемещение приложений (с проверкой)
step "Перемещение приложений" '[ -d "/Applications/Dozer.app" ] && mv -f /Applications/Dozer.app /Applications/user; [ -d "/Applications/Cisdem AppCrypt.app" ] && mv -f "/Applications/Cisdem AppCrypt.app" /Applications/user; [ -d "/Applications/Keeper.app" ] && mv -f "/Applications/Keeper.app" /Applications/user; [ -d "/Applications/Unity Hub.app" ] && mv -f "/Applications/Unity Hub.app" /Applications/user'

# Создание файлов
step "Создание файлов" 'touch ~/Desktop/Certifikates/SharedSecret.txt ~/Desktop/AppCryptSitesList.txt'

# Отключение сна
step "Отключение сна" 'run_sudo pmset -a disablesleep 1'

# Установка пакетов
step "Установка пакетов" 'brew install blueutil cocoapods rbenv && blueutil --power 0'

# Настройка rbenv
step "Настройка rbenv" 'echo "export PATH=\"$HOME/.rbenv/bin:$PATH\"" >> ~/.bash_profile && echo "eval \"$(rbenv init -)\"" >> ~/.bash_profile && source ~/.bash_profile'

# Установка Ruby 4.0.2
step "Установка Ruby 4.0.2" 'rbenv install 4.0.2 && rbenv global 4.0.2 && ruby -v'

# Установка гемов (без sudo)
step "Установка Zeitwerk" 'gem install zeitwerk -v 2.7.5'
step "Установка ActiveSupport" 'gem install activesupport -v 8.1.3'
step "Установка DRb" 'gem install drb -v 2.2.3'
step "Установка CocoaPods" 'gem install cocoapods -v 1.16.2'

# Очистка истории zsh
step "Очистка истории zsh" 'rm ~/.zsh_history && touch ~/.zsh_history'

# Итоговый отчёт
echo -e "\n===== ОТЧЁТ ====="
for r in "${results[@]}"; do
    echo "$r"
done
echo "================="
