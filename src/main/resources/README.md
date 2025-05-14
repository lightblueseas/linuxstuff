# 💻 Linux System Profile & Maintenance Scripts

This repository contains a collection of Bash configuration files, aliases, and maintenance scripts to standardize and
manage your Linux environments (e.g., Ubuntu, Debian, Raspbian, Manjaro, Arch, WSL, Cygwin).

---

## 📦 Contents

| File / Script            | Description                                     |
|--------------------------|-------------------------------------------------|
| `.aliasesrc`             | Collection of useful shell aliases              |
| `.shell-aliases`         | Erweiterte Aliase für gängige CLI-Kommandos     |
| `.profile`               | General profile loaded by your shell            |
| `.aptrc`                 | Aliases and functions for Debian/Ubuntu (apt)   |
| `.mvnrc`, `.npmrc`, etc. | Tool-specific configurations                    |
| `gen-profile.sh`         | Builds the main profile from modular components |
| `gen-cygwin-profile.sh`  | Profile generation script tailored for Cygwin   |
| `.tweak.sh`              | Optional shell tweaks for cleaning the system   |
| `.zipping`               | Script for packaging the environment            |
| `LICENSE.txt`            | License information                             |
| `README.md`              | This documentation                              |

---

## ⚙️ Usage

### 🛠️ 1. Generate the Profile

Use the script to automatically generate a `.profile` (for Bash) or `.zshrc` (for Zsh):

```bash
bash gen-profile.sh
```

For Cygwin users:

```bash
bash gen-cygwin-profile.sh
```

### 🧹 2. Use the System Cleanup Functions

The following maintenance functions are available in your profile:

```bash
cleanup             # Runs an OS-specific cleanup (apt, pacman, etc.)
cleanupThumbnails   # Clears the thumbnail cache (~/.cache/thumbnails/*)
```

> ✅ These functions automatically detect your operating system (Ubuntu, Debian, Manjaro, Arch, etc.)

### 🔄 3. Reload Your Shell Config

After generating the new `.bashrc` or `.zshrc`, activate the changes:

```bash
source ~/.bashrc
# or
source ~/.zshrc
```

---

## 📌 Recommendations

- Automate the setup with an `install.sh` script
- Use `cron` or a `systemd` timer to run cleanup tasks regularly
- Version control your dotfiles with Git

---

## 📄 License

See [`LICENSE.txt`](./LICENSE.txt)

---

## 🔐 .zipping

To zip a folder or file, you can use the alias functions provided in the `.zipping` script. If not already sourced, make
sure to import these aliases into your `.profile`.

### 🔒 Example: Zip and Encrypt

Suppose you have a folder `/home/johndoe/docs` that you want to zip and encrypt. First, change to the user's home
directory:

```bash
cd /home/johndoe
zipAndEncrypt docs/ docs.enc
```

You will be prompted twice to enter a password for encryption. If successful, the output will be the encrypted zip file
`docs.enc`.

### 🔓 Example: Unzip and Decrypt

To decrypt and unzip the file later, go to the folder where `docs.enc` is located and run:

```bash
unzipAndDencrypt docs.enc
```

You will be asked for the decryption password. If correct, the archive will be extracted in the current directory.
