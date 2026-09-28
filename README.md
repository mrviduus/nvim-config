# nvim-config

Мой Neovim на базе [LazyVim](https://lazyvim.github.io), настроенный под C#/.NET + TypeScript/React
и горячие клавиши как в Visual Studio.

## Установка с нуля (macOS)

### 1. Инструменты

```bash
brew install neovim git ripgrep fd lazygit fzf node tree-sitter-cli
brew install --cask font-jetbrains-mono-nerd-font   # иконки в интерфейсе
```

- `ripgrep`, `fd`: поиск файлов и текста
- `lazygit`: git-интерфейс (`Space g g`)
- `node`: нужен языковым серверам TypeScript/ESLint
- Nerd Font: без него вместо иконок будут квадратики. Выбери шрифт в терминале:
  Warp → Settings → Appearance → Font → `JetBrainsMono Nerd Font`.

### 2. .NET SDK

Скачай `.pkg` для **Arm64** с https://dotnet.microsoft.com/download и установи двойным кликом.
Проверь:

```bash
dotnet --list-sdks
```

### 3. Сохрани старый конфиг (если есть)

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

### 4. Склонируй этот репо

```bash
git clone git@github.com:mrviduus/nvim-config.git ~/.config/nvim
```

### 5. Первый запуск

```bash
nvim
```

Подожди 1–2 минуты, пока всё установится (плагины, затем языковые серверы через Mason).
Проверка: `:checkhealth` и `:Mason` (у `omnisharp`, `vtsls`, `csharpier`, `netcoredbg` должны стоять ✓).

### 6. Клавиши F1–F12 на Mac

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
