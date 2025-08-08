
# 🌀 gitpull.sh – Fetch & Pull All Your Git Repos in One Go

**Keep all your Git repositories fresh with a single command!**
This script will:

* 🔍 **Scan** for Git repositories up to a set depth (default: `2`)
* 📦 **Detect** which ones are Git repositories
* ⬇️ **Fetch all branches** from all remotes (with pruning)
* 🔄 **Pull the latest changes** for the currently checked-out branch
* 📊 Show you a **colorful, emoji-packed summary** at the end

---

## ✨ Features

* **Configurable search depth** – default is **2 levels deep**
* **Hands-off updates** – runs through every repo it finds
* **Safe pulls** – only pulls the branch you’re currently on
* **Full fetch** – keeps *all* branch refs up-to-date
* **Pretty output** – dividers, emojis, and clear sections
* **Summary report** – see updated, skipped, and failed repos in one view

---

## 📂 Example Setup

If your directory looks like this:

```
.
├── project-a/
├── project-b/subproject-b1
├── project-b/subproject-b2
├── project-c/
└── gitpull.sh
```

With default depth of `2`, it will find:

```
project-a
project-b/subproject-b1
project-b/subproject-b2
project-c
```

---

## 🚀 Installation

1. Copy `gitpull.sh` into the directory containing your repos.
2. Make it executable:

   ```bash
   chmod +x gitpull.sh
   ```
3. Run it:

   ```bash
   ./gitpull.sh
   ```

---

## ⚙️ Options

| Option    | Description                | Example                |
| --------- | -------------------------- | ---------------------- |
| `-d N`    | Set scan depth to `N`      | `./gitpull.sh -d 3`    |
| `DEPTH=N` | Set scan depth via env var | `DEPTH=1 ./gitpull.sh` |

**Default depth is 2**.

---

## 🖥 Example Run

```
🚀 Scanning for Git repos (max depth: 2)...

────────────────────────────────────────────────────────────
📦 project-a
🌐 Remotes:
origin  git@github.com:user/project-a.git (fetch)
⬇️  git fetch --all --prune
🔄 git pull --rebase --autostash (on main)
✅ Updated project-a (a1b2c3d Fix login bug)

────────────────────────────────────────────────────────────
📦 project-b/subproject-b1
🌐 Remotes:
origin  git@github.com:user/subproject-b1.git (fetch)
⬇️  git fetch --all --prune
⚠️  Detached HEAD — skipping pull (fetch already done).

────────────────────────────────────────────────────────────
📊 Summary
  📁 Repos found: 2
  ✅ Updated    : 1
  ⚠️  Skipped     : 1
  ❌ Failed      : 0
────────────────────────────────────────────────────────────
🎉 All done!
```

---

## 🛡 Safe by Default

This script **does not**:

* Force-checkout other branches
* Merge or rebase multiple branches
* Delete local work

Instead, it **fetches everything** and **pulls only your current branch**.

---

## 💡 Tip

Run it daily to keep your repos fresh:

```bash
0 9 * * * /path/to/gitpull.sh
```
