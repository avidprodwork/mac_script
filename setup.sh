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

# Установка Homebrew
step "Установка Homebrew" '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

# Настройка окружения brew
step "Настройка окружения brew" 'echo "eval \"$(/opt/homebrew/bin/brew shellenv)\"" >> /Users/$USER/.zprofile && eval "$(/opt/homebrew/bin/brew shellenv)"'

# Создание директорий
step "Создание директорий" 'mkdir -p /Applications/user ~/Desktop/Certifikates && chflags hidden /Applications/user'

# Установка Dozer
if [ ! -d "/Applications/user/Dozer.app" ]; then
    step "Установка Dozer" 'curl -L -o ~/Downloads/Dozer.dmg https://github.com/Mortennn/Dozer/releases/download/v4.0.0/Dozer.4.0.0.dmg && hdiutil attach ~/Downloads/Dozer.dmg && ditto "/Volumes/Dozer/Dozer.app" /Applications/Dozer.app && hdiutil detach "/Volumes/Dozer" && rm ~/Downloads/Dozer.dmg && mv -f "/Applications/Dozer.app" /Applications/user/'
else
    echo "✅ Dozer уже установлен, пропускаем"
fi

# Установка Keeper
if [ ! -d "/Applications/Keeper Password Manager.app" ]; then
    step "Установка Keeper" 'curl -L -o ~/Downloads/Keeper.dmg https://www.keepersecurity.com/desktop_electron/Darwin/KeeperSetup.dmg && hdiutil attach ~/Downloads/Keeper.dmg && ditto "/Volumes/Keeper Password Manager/Keeper Password Manager.app" "/Applications/Keeper Password Manager.app" && hdiutil detach "/Volumes/Keeper Password Manager" && rm ~/Downloads/Keeper.dmg'
else
    echo "✅ Keeper уже установлен, пропускаем"
fi

# Установка Cisdem AppCrypt
if [ ! -d "/Applications/user/Cisdem AppCrypt.app" ]; then
    step "Установка Cisdem AppCrypt" 'curl -L -o ~/Downloads/Cisdem.dmg https://download.cisdem.com/cisdem-appcrypt.dmg && hdiutil attach ~/Downloads/Cisdem.dmg && ditto "/Volumes/Cisdem AppCrypt/Cisdem AppCrypt.app" "/Applications/Cisdem AppCrypt.app" && hdiutil detach "/Volumes/Cisdem AppCrypt" && rm ~/Downloads/Cisdem.dmg && mv -f "/Applications/Cisdem AppCrypt.app" /Applications/user/'
else
    echo "✅ Cisdem AppCrypt уже установлен, пропускаем"
fi

# Установка Unity Hub
if [ ! -d "/Applications/Unity Hub.app" ]; then
    step "Установка Unity Hub" 'curl -L -o ~/Downloads/UnityHub.dmg https://public-cdn.cloud.unity3d.com/hub/prod/UnityHubSetup.dmg && hdiutil attach ~/Downloads/UnityHub.dmg && ditto "$(find /Volumes -maxdepth 1 -type d -name "Unity Hub*")/Unity Hub.app" "/Applications/Unity Hub.app" && hdiutil detach "$(find /Volumes -maxdepth 1 -type d -name "Unity Hub*")" && rm ~/Downloads/UnityHub.dmg'
else
    echo "✅ Unity Hub уже установлен, пропускаем"
fi

# Установка RealVNC Server (только в /Applications)
if [ ! -d "/Applications/VNC Server.app" ]; then
    step "Установка RealVNC Server" 'curl -L -o ~/Downloads/VNCServer.pkg https://downloads.realvnc.com/download/file/vnc.files/VNC-Server-7.16.0-MacOSX-universal.pkg && \
    run_sudo installer -pkg ~/Downloads/VNCServer.pkg -target / && \
    rm ~/Downloads/VNCServer.pkg'
else
    echo "✅ RealVNC Server уже установлен, пропускаем"
fi

# Создание файлов
step "Создание файлов" 'touch ~/Desktop/Certifikates/SharedSecret.txt'

# Создание файла разрешённых сайтов (ALLOW)
step "Создание списка разрешённых сайтов" 'cat > ~/Desktop/AppCryptAllow.txt << "EOF"
google.com
dropbox.com
apple.com
app-privacy-policy-generator.firebaseapp.com
aws.amazon.com
fex.net
online-video-cutter.com
appicon.co
youtube.com
digitalocean.com
dropmefiles.com
apps.admob.com
googleapis.com
Applovin.com
Chrome://downloads
flycricket.com
flycricket.io
fex.net
EOF'

# Создание файла заблокированных сайтов (BLOCK)
step "Создание списка заблокированных сайтов" 'cat > ~/Desktop/AppCryptBlock.txt << "EOF"
https://appleid.apple.com
https://accounts.google.com/ServiceLogin/identifier
https://myaccount.google.com
https://accounts.google.com/SignOutOptions
https://accounts.google.com/v3/signin
https://ads.google.com
pricing
https://appstoreconnect.apple.com/access/users
https://appstoreconnect.apple.com/business
https://appstoreconnect.apple.com/itc/payments_and_financial_reports#/
https://appstoreconnect.apple.com/trends
https://appstoreconnect.apple.com/analytics/apps/d30
EOF'

# Отключение сна
step "Отключение сна" 'run_sudo pmset -a disablesleep 1'

# Установка пакетов
step "Установка пакетов" 'brew install blueutil cocoapods rbenv && blueutil --power 0'

# Настройка rbenv
step "Настройка rbenv" 'echo "export PATH=\"$HOME/.rbenv/bin:$PATH\"" >> ~/.bash_profile && echo "eval \"$(rbenv init -)\"" >> ~/.bash_profile && source ~/.bash_profile'

# Установка Ruby 4.0.2
step "Установка Ruby 4.0.2" 'rbenv install 4.0.2 && rbenv global 4.0.2 && ruby -v'

# Установка гемов
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
