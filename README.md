
# 🌀 gitpull.sh – Fetch & Pull All Your Git Repos in One Go

**Keep all your top-level Git repositories fresh with a single command!**
This script will:

* 🔍 **Scan** all top-level directories in the current folder
* 📦 **Detect** which ones are Git repositories
* ⬇️ **Fetch all branches** from all remotes (with pruning)
* 🔄 **Pull the latest changes** for the currently checked-out branch
* 📊 Show you a **colorful, emoji-packed summary** at the end

---

## ✨ Features

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
├── project-b/
├── project-c/
└── gitpull.sh
```

It will:

1. Run `git fetch --all --prune` in each repo
2. Run `git pull --rebase --autostash` for the checked-out branch
3. Skip non-Git folders (or detached HEAD states)

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

## 🖥 Example Run

```
🚀 Scanning top-level directories for Git repos...

────────────────────────────────────────────────────────────
📦 project-a
🌐 Remotes:
origin  git@github.com:user/project-a.git (fetch)
⬇️  git fetch --all --prune
🔄 git pull --rebase --autostash (on main)
✅ Updated project-a (a1b2c3d Fix login bug)

────────────────────────────────────────────────────────────
📦 project-c
🌐 Remotes:
origin  git@github.com:user/project-c.git (fetch)
⬇️  git fetch --all --prune
⚠️  Detached HEAD — skipping pull (fetch already done).

────────────────────────────────────────────────────────────
📊 Summary
  ✅ Updated: 1
  ⚠️  Skipped: 1
  ❌ Failed : 0
────────────────────────────────────────────────────────────
🎉 All done!
```

---

## ⚙️ Script Behavior

* **Updated** – Repo was successfully fetched and pulled
* **Skipped** – Repo isn’t on a branch or isn’t a Git repo
* **Failed** – Fetch or pull failed (network, conflicts, etc.)

---

## 🛡 Safe by Default

This script **does not**:

* Force-checkout other branches
* Merge or rebase multiple branches
* Delete local work

Instead, it **fetches everything** and **pulls only your current branch**.

---

## 💡 Tip

You can run this daily in your repos folder to keep everything fresh:

```bash
0 9 * * * /path/to/gitpull.sh
```

---

If you’d like, I can also make **a super-short “Quick Start” version** for the README so someone can run it in under 30 seconds without reading all the details. That would be perfect for the top of the file.
