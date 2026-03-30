🍏 mac_script
Автоматизация настройки и очистки окружения на macOS.
Скрипты позволяют быстро установить необходимый набор приложений и пакетов, а затем полностью снести их при необходимости.

🚀 Установка окружения
Запусти скрипт настройки:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/avidprodwork/mac_script/main/setup.sh)
```
Что делает setup.sh:
- 📦 Устанавливает Homebrew и базовые пакеты (blueutil, cocoapods, rbenv).
- 🖥️ Ставит приложения:
- Dozer (менеджер менюбар)
- Keeper Password Manager
- Cisdem AppCrypt (блокировка сайтов и приложений)
- Unity Hub
- RealVNC Server
- 📂 Создаёт скрытую папку /Applications/user для отдельных приложений.
- 📝 Создаёт файлы:
- ~/Desktop/AppCryptAllow.txt - список разрешённых сайтов
- ~/Desktop/AppCryptBlock.txt - список заблокированных сайтов
- ~/Desktop/Certifikates/SharedSecret.txt - служебный файл
- ⚙️ Настраивает rbenv и Ruby 4.0.2, устанавливает необходимые гемы.
- 🔒 Отключает сон системы (pmset disablesleep).
- 🧹 Очищает историю zsh.



🧹 Очистка окружения
Запусти скрипт удаления:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/avidprodwork/mac_script/main/remove.sh)
```
Что делает remove.sh:
- ❌ Удаляет все установленные приложения (Dozer, Keeper, Cisdem AppCrypt, Unity Hub, RealVNC Server).
- 🗑️ Сносит скрытую папку /Applications/user.
- 📝 Удаляет созданные файлы (AppCryptAllow.txt, AppCryptBlock.txt, SharedSecret.txt).
- 🧹 Полностью удаляет Homebrew и пакеты.
- 🧹 Чистит rbenv, Ruby и установленные гемы.
- 🔄 Обнуляет историю zsh.

⚠️ Важно
- Для установки RealVNC Server потребуется пароль администратора macOS.
- Перед запуском убедись, что переменная SUDOPASS в скрипте совпадает с твоим системным паролем.
- Скрипты предназначены для чистой автоматизации - они не проверяют наличие других версий приложений, установленных вручную.
