# conn — SSH Connection Manager

**A lightweight, zero-dependency Bash tool to manage SSH connections with aliases.**

Stop memorizing hosts, usernames and ports.  
Store every server under a short alias and connect with a single command.

---

## Overview

`conn` is a single-file Bash script that wraps `ssh` with a human-friendly interface. It stores your server definitions in `~/.ssh_connections.conf` and exposes a clean CLI to add, list, edit, connect to, and remove them — plus SSH key management, ProxyJump/IdentityFile, shell completion, and auto-update.

```bash
conn to production                              # SSH into "production" in one shot
conn list                                       # Pretty-printed table of all servers
conn add                                        # Interactive wizard
conn add prod deploy@host:22 --folder /var/www  # One-shot add
conn update                                     # Pull the latest version from GitHub
```

---

## Installation

### Quick install (one-liner)

```bash
curl -fsSL https://conn.web.ap.it/setup.sh | bash
```

Downloads and installs `conn` to `/usr/local/bin`

### Shell completion (optional)

```bash
# bash
conn completion bash

# zsh
conn completion zsh
```

The command adds an idempotent loader to the shell configuration file. Open a new terminal or run the `source` command it prints. Use `conn completion zsh --print` (or `bash --print`) only when you need the raw completion script.

---

## Commands

| Command                        | Description                                              |
| ------------------------------ | -------------------------------------------------------- |
| `conn add`                     | Interactive wizard to save a new connection              |
| `conn add <alias> <user@host[:port]> [options]` | One-shot add (`--folder`, `--identity`, `--jump`, `--password`) |
| `conn list`                    | Print all connections in a formatted table               |
| `conn info <alias>`            | Show details for a connection (password never printed)   |
| `conn to <alias>`              | Open an SSH session by alias                             |
| `conn edit <alias>`            | Modify an existing connection                            |
| `conn remove <alias>`          | Delete a connection (with confirmation)                  |
| `conn reset <alias>`           | Remove stale host keys (`ssh-keygen -R`)                 |
| `conn key <action>`            | Manage SSH keys — `public`, `private`, `create [--rsa]`  |
| `conn update`                  | Self-update from GitHub                                  |
| `conn completion [bash\|zsh]`  | Install idempotent shell completion                      |
| `conn help`                    | Print usage reference                                    |

---

## Usage

### Adding a connection

Interactive:

```bash
conn add
```

```
Type alias: production
Type user (default: root): deploy
Type host: prod.example.com
Type port (default: 22): 22
Password (optional — stored in secret store, copied to clipboard on connect):
Type remote folder (optional): /var/www/myapp
Identity file (optional, e.g. ~/.ssh/id_ed25519):
ProxyJump host (optional): bastion
```

One-shot:

```bash
conn add production deploy@prod.example.com:22 \
  --folder /var/www/myapp \
  --identity ~/.ssh/id_ed25519 \
  --jump bastion
```

### Listing servers

```bash
conn list
```

Notes column:

- 🔑 saved password (in OS secret store)
- 📂 remote folder
- 🔐 custom identity file
- ↪ ProxyJump

### Connecting

```bash
conn to production
```

Before opening the SSH session, `conn` will:

1. Verify that an SSH key pair exists (`id_ed25519`, `id_ecdsa`, or `id_rsa`)
2. Check for available script updates at most once every 24 hours
3. Copy the saved password to the clipboard (if one is stored)
4. Hand off to `ssh` with optional `-i` / `-J`, and auto-`cd` into the remote folder

### Managing SSH keys

```bash
conn key public         # Print your public key
conn key create         # Generate a new ed25519 key pair (passphrase prompted)
conn key create --rsa   # Generate a 4096-bit RSA key pair instead
conn key private        # Print your private key (requires typing YES)
```

### Resetting a host key

Useful when you get a _"WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED"_ error:

```bash
conn reset myserver
```

---

## Configuration

Connections are persisted in:

```
~/.ssh_connections.conf
```

Format (7 fields):

```
alias|user|host|port|folder|identity|proxyjump
```

Passwords are **not** stored in this file. They go to, in order of preference:

1. **macOS Keychain** (`security`)
2. **libsecret** (`secret-tool`)
3. **pass** (password-store)
4. Fallback file `~/.ssh_connections.secrets` (`chmod 600`)

### Platform support

- **macOS:** native support for Keychain and `pbcopy`.
- **Linux:** native support for `secret-tool` / `pass` and `xclip`, `xsel`, or `wl-copy`.
- **Windows:** not supported natively. `conn` may run in WSL or Git Bash, but it does not currently integrate with Windows Credential Manager or `clip.exe`; the fallback secret file should therefore be treated with extra care.

Existing configs in the old `alias|user|host|port|password|folder` format are migrated automatically on first run — passwords are moved into the secret store and removed from the connections file.

Fields must not contain `|`.

---

## Requirements

- macOS or any Unix-like system
- Bash 3.2+ (macOS system Bash is fine)
- OpenSSH client
- Clipboard support — `pbcopy` on macOS; `xclip`, `xsel`, or `wl-copy` on Linux
- Windows is supported only through WSL or Git Bash, with the limitations above

---

## Uninstallation

Remove the binary:

```bash
sudo rm /usr/local/bin/conn
```

Remove saved connections and secrets:

```bash
rm -f ~/.ssh_connections.conf ~/.ssh_connections.secrets
# macOS Keychain entries use service "conn.web.ap.it" — delete from Keychain Access if needed
```

---

## Take it to production

Once you've connected to your servers with **conn**, deploy your Laravel apps with [cipi.sh](https://cipi.sh) — an open-source CLI built exclusively for Laravel. One command installs a complete production stack on any Ubuntu VPS: PHP-FPM, MariaDB, Nginx, Let's Encrypt SSL, zero-downtime deploys.

---

## Links

- **Website:** [conn.web.ap.it](https://conn.web.ap.it)
- **Repository:** [github.com/andreapollastri/conn](https://github.com/andreapollastri/conn)

---

## Contributing

Pull requests are welcome. For significant changes, please open an issue first to discuss what you'd like to change.

---

## License

[MIT](LICENSE) — free to use, modify and distribute.

---

Made with care by [Andrea Pollastri](https://web.ap.it)
