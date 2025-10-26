//
//  MetalView.swift
//  Antikythera
//
//  Metal-based rendering view (replaces GLView)
//

import Metal
import MetalKit

#if os(iOS)
import UIKit
typealias PlatformView = UIView
#elseif os(macOS)
import AppKit
typealias PlatformView = NSView
#endif

// MARK: - Metal View Delegate Protocol

@objc protocol MetalViewDelegate: AnyObject {
    func drawView(_ view: MetalView)
    func setupView(_ view: MetalView)
}

// MARK: - Metal View

class MetalView: MTKView {

    // MARK: - Properties

    @IBOutlet weak var renderDelegate: MetalViewDelegate?
    var renderer: MetalRenderer!

    private var renderingFrequency: Double = 60.0

    // MARK: - Initialization

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupMetal()
    }

    override init(frame: CGRect, device: MTLDevice?) {
        super.init(frame: frame, device: device)
        setupMetal()
    }

    private func setupMetal() {
        // Get default Metal device
        guard let metalDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this device")
        }

        self.device = metalDevice

        // Create renderer
        guard let renderer = MetalRenderer(device: metalDevice) else {
            fatalError("Failed to create Metal renderer")
        }
        self.renderer = renderer

        // Configure MTKView
        self.colorPixelFormat = .bgra8Unorm
        self.depthStencilPixelFormat = .depth32Float
        self.clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)

        #if os(iOS)
        self.contentScaleFactor = UIScreen.main.scale
        #elseif os(macOS)
        self.layer?.contentsScale = NSScreen.main?.backingScaleFactor ?? 1.0
        #endif

        // Set delegate
        self.delegate = self

        // Set rendering frequency based on platform
        #if os(iOS) && !targetEnvironment(simulator)
        renderingFrequency = 60.0
        #else
        renderingFrequency = 30.0
        #endif

        // Configure preferred frames per second
        self.preferredFramesPerSecond = Int(renderingFrequency)

        // Enable drawing
        self.isPaused = false
        self.enableSetNeedsDisplay = false
    }

    // MARK: - Animation Control

    func startAnimation() {
        self.isPaused = false
    }

    func stopAnimation() {
        self.isPaused = true
    }

    func setAnimationInterval(_ interval: TimeInterval) {
        renderingFrequency = 1.0 / interval
        self.preferredFramesPerSecond = Int(renderingFrequency)
    }

    // MARK: - Cleanup

    deinit {
        stopAnimation()
    }
}

// MARK: - MTKViewDelegate

extension MetalView: MTKViewDelegate {

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // Handle resize if needed
        renderDelegate?.setupView(self)
    }

    func draw(in view: MTKView) {
        // Get command buffer
        guard let commandBuffer = renderer.commandQueue.makeCommandBuffer() else {
            return
        }

        // Get render pass descriptor
        guard let renderPassDescriptor = currentRenderPassDescriptor else {
            return
        }

        // Get render encoder
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }

        // Begin rendering
        renderer.beginFrame(with: renderEncoder)

        // Call delegate to perform actual drawing
        renderDelegate?.drawView(self)

        // End rendering
        renderer.endFrame()
        renderEncoder.endEncoding()

        // Present drawable
        if let drawable = currentDrawable {
            commandBuffer.present(drawable)
        }

        // Commit command buffer
        commandBuffer.commit()
    }
}
