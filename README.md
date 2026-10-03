# Neovim config

Самостоятельная копия Neovim-конфига из dotfiles: без остальных настроек и без истории исходного репозитория.

Telescope, Oil, LSP и автодополнение, форматирование при сохранении, Git-интеграция, темы и горячие клавиши для русской раскладки. Leader — **пробел**. [Шпаргалка клавиш](KEYMAPS.md).

## Требования

- Современный Neovim (исходный конфиг используется с **0.12.5**; старые версии не проверены).
- Git, Node.js/npm (для LSP), `ripgrep`, `tree-sitter` CLI, C-компилятор и `make` (сборка парсеров и нативных плагинов), curl/unzip.
- Интернет для первой установки плагинов, парсеров и языковых серверов.
- Nerd Font, выбранный в настройках терминала. Без него можно выставить `vim.g.have_nerd_font = false` в `init.lua`.

### macOS

При установленном Homebrew:

```sh
brew install neovim git node ripgrep tree-sitter make
brew install --cask font-jetbrains-mono-nerd-font
```

Выбери JetBrainsMono Nerd Font в терминале. Для C-компилятора нужны Command Line Tools (`xcode-select --install`, если ещё не установлены).

### Linux / Windows

На Linux установи зависимости из списка выше; системный пакет Neovim может оказаться слишком старым. Для локального буфера обмена установи `wl-clipboard` (Wayland) либо `xclip` (X11). Без них конфиг использует OSC 52 терминала.

На Windows предпочтителен **WSL** с установкой как на Linux. Нативная Windows этим конфигом не проверялась.

## Установка (macOS / Linux / WSL)

Сначала сделай резервные копии существующих настроек и данных Neovim. Закрой Neovim и выполни:

```sh
stamp=$(date +%Y%m%d-%H%M%S)
for path in "${XDG_CONFIG_HOME:-$HOME/.config}/nvim" \
            "${XDG_DATA_HOME:-$HOME/.local/share}/nvim" \
            "${XDG_STATE_HOME:-$HOME/.local/state}/nvim" \
            "${XDG_CACHE_HOME:-$HOME/.cache}/nvim"; do
  if [ -e "$path" ] || [ -L "$path" ]; then
    mv "$path" "$path.backup-$stamp" || exit 1
  fi
done
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}"
git clone https://github.com/rthw/nvim-standalone.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
nvim
```

При первом запуске lazy.nvim скачает плагины, Mason — инструменты, Treesitter — парсеры. Дождись завершения; в `:Lazy` выполни Restore (`R`), чтобы применить версии из `lazy-lock.json`, и перезапусти Neovim. Состояние инструментов: `:Mason`, диагностика зависимостей: `:checkhealth`.

## Необязательные инструменты

- `macism` — автоматическое переключение раскладки при вводе `:` на macOS. Без него блок пропускается.
- `lazygit`, `lazydocker`, `fzf`, `ytop` — для соответствующих терминальных горячих клавиш.
- `beancount-language-server` и `bean-format` — только для Beancount.
- Форматтеры для используемых языков: `black`, `isort`, `prettier`/`prettierd`, `beautysh`, `yamlfix`. Stylua ставится через Mason. Остальные нужно установить отдельно; отсутствие может вызывать уведомления при сохранении соответствующих файлов. Состояние: `:ConformInfo`.
- Oil настроен на удаление в корзину: проверь доступность подходящей утилиты через `:checkhealth oil` перед удалением файлов.

## Обновление

```sh
git -C "${XDG_CONFIG_HOME:-$HOME/.config}/nvim" pull --ff-only
```

Затем `:Lazy restore` и перезапуск. Свои правки предварительно коммить или сохраняй отдельно; не используй `reset --hard` для обновления.

Это отдельная копия: изменения исходных dotfiles автоматически сюда не поступают.

## Проверка

Перед публикацией проверяется синтаксис Lua-файлов. Полная установка всех зависимостей на чистом компьютере и нативной Windows не проверялась.
