# Build Scripts

This directory contains Python scripts used during the OpenGL ES to Metal conversion.

## Scripts

### update_xcode_project.py
**Purpose**: Updates the Xcode project to add Metal files and remove OpenGL files.

**What it does**:
- Adds Metal framework references
- Adds MetalKit framework references
- Removes OpenGLES framework
- Removes GLKit framework
- Adds Metal source files (MetalRenderer, MetalView, etc.)
- Removes OpenGL source files (GLView, GLViewController, GLModel3D)
- Updates deployment target to iOS 14.0

**Usage**:
```bash
cd /Users/jcollas/Developer/antikythera
python3 scripts/update_xcode_project.py
```

**Creates backup**: `project.pbxproj.backup`

---

### add_macos_target.py
**Purpose**: Adds a macOS target to the Xcode project.

**What it does**:
- Creates new macOS native target
- Adds AppKit framework for macOS
- Shares source files with iOS target
- Configures macOS deployment target (11.0)
- Sets up macOS build configurations
- Creates build phases (Resources, Sources, Frameworks)

**Usage**:
```bash
cd /Users/jcollas/Developer/antikythera
python3 scripts/add_macos_target.py
```

**Creates backup**: `project.pbxproj.backup2`

---

### fix_macos_resources.py
**Purpose**: Fixes macOS target resources by removing iOS-specific files.

**What it does**:
- Removes Main.storyboard from macOS target resources
- iOS storyboards are not compatible with macOS
- Allows macOS app to use programmatic UI creation

**Usage**:
```bash
cd /Users/jcollas/Developer/antikythera
python3 scripts/fix_macos_resources.py
```

**Creates backup**: `project.pbxproj.backup3`

---

## Notes

- All scripts create backups before modifying the project file
- Scripts must be run from the repository root directory
- Scripts were used during the initial conversion and may not be needed again
- Keep these scripts for reference or future similar conversions

## Script Execution Order

During the conversion, scripts were run in this order:

1. **update_xcode_project.py** - First, to add Metal infrastructure
2. **add_macos_target.py** - Second, to add macOS support
3. **fix_macos_resources.py** - Third, to fix macOS resource issues

---

**Created**: October 26, 2025
**Part of**: OpenGL ES → Metal Conversion Project
