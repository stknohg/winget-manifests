# Personal winget manifests

This is my personal winget manifests.

## How to use

Clone this repository first.  
Then `winget install` command with `-m (--manifest)` option.

e.g.

```powershell
git clone https://github.com/stknohg/winget-manifests.git

winget install -m .\manifests\Amazon.SessionManagerPlugin\
```

### Note

This repository contains a single version manifest only.  
I'm intentionally ignoring manifest versioning.