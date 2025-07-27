# 🧰 WSL Setup Guide

This repo is previewable with zero orchestration, but many stewards prefer visual tools and markdown-friendly terminals. If you're on Windows, WSL is the simplest way to honor that preference.

*Note: Requires Windows 10 (2004+) or Windows 11.*

---

## 💡 Why WSL?

- Enables Linux-style markdown preview (e.g. `bat`)
- Preserves repo layout and badge logic with dignity
- Requires minimal setup—no Docker, no port forwarding

---

## ⚙️ Step-by-Step Installation

### Step 1: Enable WSL (One Line)

Open PowerShell as administrator and run:

```powershell
wsl --install

---

### Step 2: Launch Ubuntu
Once installed, restart your system. Search for “Ubuntu” in the Start menu.

Launch it once to auto-configure (takes ~1–2 minutes).

Choose username and password when prompted.

---

### Step 3: Install Markdown Preview Tools
In the Ubuntu terminal, run:

```Bash
sudo apt update
sudo apt install bat

To preview markdown files:

```Bash
bat preview-quickstart.md

---

### 📁 Preview Key Assets

These files provide modular context across the kit:

preview-quickstart.md — repo overview and setup guide

docs/stewardship-notes.md — print-ready stewardship inserts

examples/badge-deployment.md — badge logic and mapping

Any Phase README — contextual guidance by phase

---

### 🧭 Bonus: Validate Badge Logic (Optional)
You can test badge validators using:

```Bash
./tools/validate-badge.sh data-minimization

This shows how scenarios connect to badges, validators, and remix logic.
