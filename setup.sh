#!/bin/bash

# Пароль sudo по умолчанию
SUDOPASS="1111"

# Функция для выполнения команд с sudo без повторного запроса пароля
run_sudo() {
    echo "$SUDOPASS" | sudo -S "$@"
}

# Массив строк для отчёта
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

# Установка Homebrew (автоматический Enter)
step "Установка Homebrew" 'printf "\n" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

# Настройка окружения brew
step "Настройка окружения brew" 'echo "eval \"$(/opt/homebrew/bin/brew shellenv)\"" >> /Users/$USER/.zprofile && eval "$(/opt/homebrew/bin/brew shellenv)"'

# Установка Dozer вручную
step "Установка Dozer" 'curl -L -o ~/Downloads/Dozer.dmg https://github.com/Mortennn/Dozer/releases/download/v4.0.0/Dozer.4.0.0.dmg && hdiutil attach ~/Downloads/Dozer.dmg && cp -r /Volumes/Dozer/Dozer.app /Applications && hdiutil detach /Volumes/Dozer && rm ~/Downloads/Dozer.dmg'

# Создание директорий
step "Создание директорий" 'mkdir -p /Applications/user ~/Desktop/Certifikates && chflags hidden /Applications/user'

# Перемещение приложений
step "Перемещение приложений" 'mv /Applications/Dozer.app /Applications/user 2>/dev/null; mv /Applications/Cisdem\ AppCrypt.app /Applications/user 2>/dev/null'

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

# Установка гемов (без sudo, чтобы ставились в ~/.rbenv)
step "Установка Zeitwerk" 'gem install zeitwerk -v 2.7.5'
step "Установка ActiveSupport" 'gem install activesupport -v 8.1.3'
step "Установка DRb" 'gem install drb -v 2.2.3'
step "Установка CocoaPods" 'gem install cocoapods'

# Очистка истории zsh
step "Очистка истории zsh" 'rm ~/.zsh_history && touch ~/.zsh_history'

# Итоговый отчёт
echo -e "\n===== ОТЧЁТ ====="
for r in "${results[@]}"; do
    echo "$r"
done
echo "================="
