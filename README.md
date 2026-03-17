# conn — SSH Connection Manager

**A lightweight, zero-dependency Bash tool to manage SSH connections with aliases.**

Stop memorizing hosts, usernames and ports.  
Store every server under a short alias and connect with a single command.

---

## Overview

`conn` is a single-file Bash script that wraps `ssh` with a human-friendly interface. It stores your server definitions in `~/.ssh_connections.conf` and exposes a clean CLI to add, list, edit, connect to, and remove them — plus SSH key management and auto-update built in.

```bash
conn to production        # SSH into "production" in one shot
conn list                 # Pretty-printed table of all servers
conn add                  # Interactive wizard to add a new server
conn update               # Pull the latest version from GitHub
```

---

## Installation

### Quick install (one-liner)

```bash
curl -fsSL https://conn.web.ap.it/setup.sh | bash
```

Downloads and installs `conn` to `/usr/local/bin`

---

## Commands

| Command               | Description                                     |
| --------------------- | ----------------------------------------------- |
| `conn add`            | Interactive wizard to save a new connection     |
| `conn list`           | Print all connections in a formatted table      |
| `conn info <alias>`   | Show full details for a single connection       |
| `conn to <alias>`     | Open an SSH session by alias                    |
| `conn edit <alias>`   | Modify an existing connection                   |
| `conn remove <alias>` | Delete a connection (with confirmation)         |
| `conn reset <alias>`  | Remove stale host keys (`ssh-keygen -R`)        |
| `conn key <action>`   | Manage SSH keys — `public`, `private`, `create` |
| `conn update`         | Self-update from GitHub                         |
| `conn help`           | Print usage reference                           |

---

## Usage

### Adding a connection

```bash
conn add
```

```
Type alias: production
Type user (default: root): deploy
Type host: prod.example.com
Type port (default: 22): 22
Password (optional — copied to clipboard on connect):
Type remote folder (optional): /var/www/myapp
```

### Listing servers

```bash
conn list
```

```
╔════════════════════════════════════════════════════════════════════════════╗
║                          SSH SERVERS LIST                                  ║
╚════════════════════════════════════════════════════════════════════════════╝

  production 🔑 📂
  ↳ root@prod.example.com:22
  ↳ /var/www/myapp

  staging
  ↳ deploy@staging.example.com:2222

  myserver
  ↳ andrea@192.168.1.100:22

────────────────────────────────────────────────────────────────────────────
  💡  Use conn to <alias> to connect
  🔑 saved password  📂 remote folder
```

> 🔑 indicates a saved password that will be automatically copied to the clipboard on connect.
> 📂 indicates a remote folder that the session will automatically cd into on connect.

### Connecting

```bash
conn to production
```

Before opening the SSH session, `conn` will:

1. Verify that an SSH key pair exists (warns if missing)
2. Check for available script updates
3. Copy the saved password to the clipboard (if one is stored)
4. Hand off to `ssh` (and automatically `cd` into the remote folder, if configured)

### Managing SSH keys

```bash
conn key public    # Print your public key
conn key create    # Generate a new id_rsa key pair
conn key private   # Print your private key (handle with care)
```

### Resetting a host key

Useful when you get a _"WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED"_ error:

```bash
conn reset myserver
```

---

## Configuration

Connections are persisted in a plain-text file:

```
~/.ssh_connections.conf
```

Each line follows the format `alias|user|host|port|password|folder`. You can back it up, version-control it, or copy it between machines freely. The `folder` field is optional — when set, the SSH session will automatically `cd` into that directory on connect.

> **Security note:** Passwords are stored in plain text. Where possible, prefer SSH key-based authentication and leave the password field empty.

---

## Requirements

- macOS or any Unix-like system
- Bash 4.0+
- OpenSSH client
- Git (required for `conn update`)
- Clipboard support — `pbcopy` on macOS (built-in), `xclip` or `xsel` on Linux

---

## Uninstallation

Remove the binary:

```bash
sudo rm /usr/local/bin/conn
```

Remove saved connections:

```bash
rm ~/.ssh_connections.conf
```

---

## Take it to production

Once you've connected to your servers with **conn**, deploy your Laravel apps with [cipi.sh](https://cipi.sh) — an open-source CLI built exclusively for Laravel. One command installs a complete production stack on any Ubuntu VPS: PHP-FPM, MariaDB, Nginx, Let's Encrypt SSL, zero-downtime deploys.

---

## Links

- **Website:** [conn.web.ap.it](https://conn.web.ap.it)
- **Repository:** [github.com/andreapollastri/conn.web.ap.it](https://github.com/andreapollastri/conn.web.ap.it)

---

## Contributing

Pull requests are welcome. For significant changes, please open an issue first to discuss what you'd like to change.

---

## License

[MIT](LICENSE) — free to use, modify and distribute.

---

Made with care by [Andrea Pollastri](https://web.ap.it)
