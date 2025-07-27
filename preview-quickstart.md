# 🖥️ Preview Quickstart

This repo is designed for modular preview—no orchestration, no setup drama.

Whether you're validating badge logic, browsing examples, or preparing binders, follow these steps to view assets locally and with dignity.

---

## 🔧 Local Markdown Viewing (No GitHub Pages Needed)

### On Windows (WSL Recommended)
1. Install WSL (if not already):  
   - Run: `wsl --install`
2. Install `bat` for pretty preview:
   - Run: `sudo apt install bat`
3. Use `bat` to view markdown:
   - Example: `bat examples/badge-deployment.md`

### On macOS/Linux
- Use built-in `cat`, `bat`, or any markdown preview tool.
- Example: `bat docs/stewardship-notes.md`

---

## 🪪 Badge Logic Walkthrough

Explore how badges are earned, validated, and remixed.

### Badge Files
- `examples/badge-deployment.md`: Real-world badge mapping
- `tools/validate-badge.sh`: CLI validator

### Validate a Badge
```bash
./tools/validate-badge.sh data-minimization
