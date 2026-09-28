# nvim-config

Мой Neovim на базе [LazyVim](https://lazyvim.github.io), настроенный под C#/.NET + TypeScript/React
и горячие клавиши как в Visual Studio.

## Установка на любой машине (macOS / Linux)

Одна команда в терминале:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/mrviduus/nvim-config/main/install.sh)
```

Потом открой **новый** терминал и запусти `nvim`. Языковые серверы доустановятся при первом
запуске (1–2 минуты), проверка: `:Mason`.

Что делает [`install.sh`](install.sh), по шагам:
1. Ставит [Homebrew](https://brew.sh), если его нет (на macOS может спросить пароль).
2. Ставит `neovim git ripgrep fd lazygit fzf node tree-sitter-cli`, на Mac ещё шрифт JetBrainsMono Nerd Font.
3. Ставит .NET 10 SDK в `~/.dotnet` (без sudo), если `dotnet` ещё нет, и прописывает PATH в `~/.zshrc`/`~/.bashrc`.
4. Если в `~/.config/nvim` лежит чужой конфиг, переименовывает его в `*.bak.<дата>` (ничего не удаляет)
   и клонирует этот репо.
5. Скачивает плагины ровно тех версий, что в `lazy-lock.json`.

Скрипт можно запускать повторно: уже установленное пропускается, конфиг обновляется через `git pull`.

**Шрифт в терминале.** Скрипт ставит шрифт, но выбрать его нужно самому, иначе вместо иконок будут
квадратики: Warp → Settings → Appearance → Font → `JetBrainsMono Nerd Font`.

**Обновить конфиг на другой машине:** `git -C ~/.config/nvim pull`, затем в nvim `:Lazy restore`.

### Клавиши F1–F12 на Mac

По умолчанию F-клавиши управляют яркостью и громкостью. Либо жми **Fn+F5**, либо включи:
System Settings → Keyboard → Keyboard Shortcuts → Function Keys →
«Use F1, F2, etc. keys as standard function keys».

## Горячие клавиши

**Главное:** нажми `Space` и подожди, появится меню со всеми командами.

### Как в Visual Studio (`lua/config/keymaps.lua`)

| Клавиша | Действие |
|---|---|
| F12 / Shift+F12 | перейти к определению / все ссылки |
| F2 | переименовать |
| Ctrl+. | быстрые действия (quick fix) |
| F5 / Shift+F5 | запустить отладку / остановить |
| F9 | точка останова |
| F10 / F11 / Shift+F11 | step over / into / out |
| Ctrl+P | открыть файл |
| Ctrl+Shift+F | поиск по всем файлам |
| Ctrl+S | сохранить |

### Вкладки (буферы)

| Клавиша | Действие |
|---|---|
| Shift+H / Shift+L | предыдущая / следующая вкладка |
| `Space b d` | закрыть текущую |
| `Space b o` | закрыть все остальные |

### Полезное

| Клавиша | Действие |
|---|---|
| `Space e` | дерево файлов |
| `Space Space` | найти файл |
| `Space /` | поиск текста по проекту |
| `Space g g` | lazygit |
| `Space ca` | code action (если Ctrl+. не работает в терминале) |
| `Space w d` | закрыть сплит |
| `Space q q` | выйти |

## Настройки под проект (`.lazy.lua`)

LazyVim подхватывает файл `.lazy.lua` из корня открытого проекта. В `projects/` лежат такие файлы
для моих проектов.

### textstack

```bash
cp ~/.config/nvim/projects/textstack.lazy.lua ~/projects/textstack/textstack/.lazy.lua
echo ".lazy.lua" >> ~/projects/textstack/textstack/.git/info/exclude
```

При первом открытии nvim спросит, доверять ли файлу: нажми `a` (allow).

Что он делает:
- C# форматирует OmniSharp (как `dotnet format` в CI), а не csharpier
- на фронте форматирование при сохранении выключено: код не прогнан через prettier,
  и файлы переписывались бы целиком

## Extras

Включены в `lazyvim.json` (менять через `:LazyExtras`):
dotnet, typescript, json, yaml, docker, eslint, prettier, dap.

## Если что-то не работает

- **F12 не работает в C#.** OmniSharp грузит решение 30–60 сек после открытия файла. Статус: `:LspInfo`.
- **Ctrl+. или Ctrl+Shift+F не срабатывают.** Их перехватывает терминал, используй `Space ca` / `Space /`.
- **Отладка C# (F5) не стартует на Apple Silicon.** `netcoredbg` может не встать через Mason, смотри `:Mason`.
- **Обновить плагины:** `:Lazy sync`.
