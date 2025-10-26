# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an iOS/macOS application that renders a 3D, real-time, interactive model of the Antikythera Mechanism using Metal. The Antikythera Mechanism is an ancient Greek analog computer used to predict astronomical positions and eclipses.

**Historical Context**: This was originally an iOS 3.2 project from 2010 (for the original iPad), later migrated to Swift 3 and iOS 10. The code has been converted from legacy OpenGL ES 1.x to modern Metal for iOS 14+ and macOS 11+ support.

## Building and Running

### Build Commands
```bash
# Build the project
xcodebuild -project AntikytheraOpenGLPrototype_v3/AntikytheraOpenGLPrototype.xcodeproj -scheme AntikytheraOpenGLPrototype -configuration Debug build

# Clean build
xcodebuild -project AntikytheraOpenGLPrototype_v3/AntikytheraOpenGLPrototype.xcodeproj -scheme AntikytheraOpenGLPrototype clean

# Build for simulator
xcodebuild -project AntikytheraOpenGLPrototype_v3/AntikytheraOpenGLPrototype.xcodeproj -scheme AntikytheraOpenGLPrototype -sdk iphonesimulator
```

### Opening in Xcode
```bash
open AntikytheraOpenGLPrototype_v3/AntikytheraOpenGLPrototype.xcodeproj
```

## Architecture

### Core Model-View Design Pattern

The application follows a strict separation between mechanical models and their visual representations:

**Model Layer** (mechanical simulation):
- `AntikytheraMechanism` - Main device that loads from `device.json` and manages all gears, connectors, and pointers
- `Gear` - Individual gear components with tooth counts, radius calculations, and neighbor relationships
- `Connector` - Connects gears together (includes `PinAndSlotConnector` subclass)
- All implement `DeviceComponent` protocol with rotation propagation

**View Layer** (Metal rendering):
- `AntikytheraMechanismView` - Root view coordinating all component views
- `GearView` - Visual representation of gears
- `ConnectorView` / `PinAndSlotConnectorView` - Visual connectors between gears
- `PointerView` / `LunarPointerView` - Calendar pointers and indicators
- All implement `ModelView` protocol with `draw()` method
- Views use `MetalRenderContext.shared.renderer` to access the Metal renderer

### JSON-Driven Configuration

The entire mechanism is defined in `Classes/device.json`:
- **Gears**: Name, tooth count, placement (fixed, verticalOffset, angledRelative), linked gears
- **Connectors**: Links between gears with radius and type (connector vs pin-and-slot)
- **Pointers**: Calendar indicators attached to specific gears

Key implementation detail: Gears must be placed in dependency order (gear B positioned relative to gear A requires A to be placed first). The `sortGearsForPlacementOrder()` method in `AntikytheraMechanism.swift` handles this topological sort.

### Rotation Propagation System

When a gear rotates:
1. User input rotates the input gear (gA1) via `UserDialView`
2. Gear calculates rotation ratio based on radius/tooth count: `ratio = sourceRadius/thisRadius`
3. Gear updates its rotation and calls `updateNeighborRotations()`
4. Each neighbor receives `updateRotation(arcAngle, fromSource:)` with the source to prevent infinite loops
5. Propagation continues through the entire mechanism

### Metal Rendering Pipeline

1. `MetalView` (MTKView) manages the render loop and calls `MetalViewDelegate.drawView()`
2. `MetalViewController` sets up 3D perspective matrix (45° FOV) using simd matrices
3. For each frame:
   - `MetalRenderer.beginFrame()` is called with the MTLRenderCommandEncoder
   - Camera system updates view transform via `MetalRenderer` matrix stack API
   - `AntikytheraMechanismView.draw()` iterates all sub-views
   - Each view calls `MetalRenderer` methods (pushMatrix, translate, rotate, scale, setColor)
   - Model classes (`MetalModel3D` subclasses) draw geometry using Metal buffers
   - 2D overlay rendered by switching to orthographic projection matrix
   - `MetalRenderer.endFrame()` finalizes the command buffer
4. All geometry rendered as indexed triangle lists using Metal pipeline state
5. Shaders in `Shaders.metal` handle vertex transformation and fragment coloring

### Visualization Modes

The app supports multiple visualization states (set via double-tap menu):
- `.default` - Full mechanism
- `.pointers` - Calendar pointers only
- `.gears` - Gears only
- `.box` - Enclosure box
- `.pinAndSlot` - Pin-and-slot connector detail

Views that implement `AMViewStateHandler` protocol respond to state changes by adjusting opacity/visibility.

## Key Files and Their Responsibilities

### Core Architecture
- `AntikytheraMechanism.swift` - Loads JSON, builds gear graph, propagates rotations
- `AntikytheraMechanismView.swift` - Constructs all visual elements, manages view state
- `Gear.swift` - Gear model with neighbor graph and rotation propagation
- `Models.swift` - Protocols defining the model-view architecture
- `device.json` - Complete mechanism specification (32 gears, 15 connectors, 6 pointers)

### Metal Rendering
- `MetalViewController.swift` - Main view controller, sets up Metal rendering, handles touch/mouse input
- `MetalView.swift` - MTKView subclass with platform abstraction (iOS/macOS)
- `MetalRenderer.swift` - Core rendering engine with OpenGL-style matrix stack API
- `MetalModel3D.swift` - Base Metal mesh class with MTLBuffer management
- `Shaders.metal` - Vertex and fragment shaders for MVP transformation and coloring
- `MetalRenderContext.swift` - Singleton providing global access to renderer

### Model Classes (Geometry)
- `GearModel.swift`, `GearShaderModel.swift` - Gear mesh generation
- `BoxModel.swift` - Box/cube geometry
- `ConnectorModel.swift` - Cylindrical connector geometry
- `PointerModel.swift` - Pointer/shaft geometry
- `HalfGlobeModel.swift` - Spherical geometry for lunar display

### View Classes (Rendering)
- `GearView.swift` - Renders individual gears
- `BoxView.swift` - Renders enclosure box
- `PointerView.swift`, `LunarPointerView.swift` - Renders calendar pointers
- `ConnectorView.swift`, `PinAndSlotConnectorView.swift` - Renders gear connectors
- `UserDialView.swift` - 2D dial overlay for user interaction

### Utilities
- `Common.swift` - 3D math primitives (Vector3D, Vertex3D, Color3D)

## Camera System

Multiple camera implementations provide different viewpoints:
- `UICamera` - Interactive user-controlled camera (default)
- `TopCamera` - Fixed top-down view
- `SideCamera` - Fixed side view
- `ShowcaseCamera` - Automated showcase rotation
- `FlyThroughCamera` - Animated fly-through

All implement `CameraViewpoint` protocol and optional `Touchable` protocol for touch interaction.

## Input Interaction

Touch/mouse handling in `MetalViewController`:
- **iOS**: Single touch on dial → enters dial mode, rotates mechanism via `UserDialView`
- **iOS**: Single touch elsewhere → delegates to camera's `Touchable` implementation
- **iOS**: Double tap → shows visualization mode menu
- **macOS**: Platform-specific mouse/trackpad input abstraction in place

Input flow: `touchesBegan` → check if touch in dial region → either `UserDialView` or camera handles interaction

## Important Technical Details

### Metal Rendering
- Uses modern Metal API with programmable shaders (`Shaders.metal`)
- Matrix operations using simd library (simd_float4x4, simd_float3)
- Depth testing enabled by default, can be toggled per-draw-call
- Alpha blending configured in render pipeline state
- Retina/HiDPI support automatic via MTKView
- All geometry rendered as indexed triangle lists using MTLRenderPipelineState

### Platform Support
- **iOS 14+**: UIKit integration with UITouch handling
- **macOS 11+**: AppKit integration with NSEvent handling (abstraction in place)
- Conditional compilation using `#if os(iOS)/#elseif os(macOS)`
- Platform-agnostic view types via typealias

### Geometry and Math
- 3D geometry constructed programmatically (no external model files)
- Gear radius formula: `radius = teeth / (2π)` with optional scale factor
- Rotation angles stored in radians, converted to degrees for Metal renderer
- Z-depth spacing between gears typically 5.0 units (defined as offsets in JSON)
- All model classes inherit from `MetalModel3D` and manage MTLBuffer resources

### Matrix Stack API
The `MetalRenderer` provides an OpenGL-style matrix stack for backward compatibility:
- `pushMatrix()` / `popMatrix()` - Save/restore transformation state
- `translate()`, `rotate()`, `scale()` - Modify current matrix
- Internally uses simd matrices with stack implementation
- Final MVP matrix passed to shaders via uniform buffer
