# dotfiles

Used to backup, restore, and sync the preferences and settings for my machines.

## Usage

```bash
~/Projects/dotfiles/setup.sh
```

The script auto-detects your OS and runs the appropriate setup.

## Structure

```
dotfiles/
├── setup.sh          # Main entry point (detects OS)
├── .gitconfig        # Shared git config
├── macos/
│   ├── setup.sh
│   ├── Brewfile
│   └── scripts/
└── linux/
    ├── setup.sh
    ├── .bashrc
    └── .profile
```
