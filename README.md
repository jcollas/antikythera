
Antikythera
===========

A 3D, real-time, interactive model of the Antikythera Mechanism using Metal rendering.

## Overview

The Antikythera Mechanism is an ancient Greek analog computer (circa 100 BCE) used to predict astronomical positions and eclipses. This app provides an interactive 3D visualization of its complex gear system.

**Current Version**: Modern Metal-based renderer for iOS 14+ and macOS 11+

**Historical Evolution**:
- 2010: Original OpenGL ES 1.x version for iOS 3.2 (original iPad)
- 2016: Migrated to Swift 3 and iOS 10
- 2025: Converted to Metal rendering for modern iOS and macOS

See a demonstration of the original version [here](http://youtu.be/LL7KxN7tOKE).

## Features

- **32 interconnected gears** with accurate tooth counts and ratios
- **Real-time rotation propagation** through the entire mechanism
- **Interactive controls** via touch/mouse input
- **Multiple camera views** (user-controlled, top, side, showcase, fly-through)
- **Visualization modes** (full mechanism, gears only, pointers, box, connector detail)
- **JSON-driven configuration** for easy mechanism modification
- **Metal rendering** with programmable shaders for modern performance

## Building

### Requirements
- Xcode 12+
- iOS 14+ or macOS 11+
- Swift 5+

### Build Commands
```bash
# Build the project
xcodebuild -project Antikythera/Antikythera.xcodeproj \
  -scheme Antikythera -configuration Debug build

# Open in Xcode
open Antikythera/Antikythera.xcodeproj
```

## Architecture

### Model-View Pattern
- **Model Layer**: `AntikytheraMechanism`, `Gear`, `Connector` - mechanical simulation
- **View Layer**: `GearView`, `ConnectorView`, `PointerView` - Metal rendering
- **Configuration**: `device.json` - complete mechanism specification

### Rendering Pipeline
- **Metal API** with programmable shaders (`Shaders.metal`)
- **Matrix stack** for OpenGL-style transformations
- **Platform support** for both iOS (UIKit) and macOS (AppKit)

For detailed architecture and development guidance, see [CLAUDE.md](CLAUDE.md).

## Interaction

- **iOS**: Touch the dial to rotate the mechanism; touch elsewhere to control camera; double-tap for visualization menu
- **macOS**: Use mouse/trackpad for camera control and mechanism interaction

## Credits

Originally created for the Spring 2010 iPhone Development course taught by Prof. Robert Muller at Boston College.

-------
License
=======

This code is distributed under the terms and conditions of the MIT license. 
