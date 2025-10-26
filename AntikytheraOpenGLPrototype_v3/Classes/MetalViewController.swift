//
//  MetalViewController.swift
//  Antikythera
//
//  Metal-based view controller (replaces GLViewController)
//

#if os(iOS)
import UIKit
typealias PlatformViewController = UIViewController
#elseif os(macOS)
import AppKit
typealias PlatformViewController = NSViewController
#endif

import MetalKit
import simd

class MetalViewController: PlatformViewController, MetalViewDelegate {

    // MARK: - Properties

    var metalView: MetalView!
    var renderer: MetalRenderer!

    // Device and rendering
    var antikytheraMechanism: AntikytheraMechanism!
    var antikytheraMechanismView: AntikytheraMechanismView!

    var userDial: UserDialView!
    var dialMode = false

    var camera: CameraViewpoint!
    var touchDelegate: Touchable?

    // View configuration
    let zNear: Float = 1.0
    let zFar: Float = 2000.0
    let fieldOfView: Float = 45.0

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMetalView()
        setupRenderer()
        setupScene()
    }

    // MARK: - Setup

    private func setupMetalView() {
        // Get or create MetalView
        if let existingView = self.view as? MetalView {
            metalView = existingView
        } else {
            // Create new MetalView if not loaded from storyboard
            let frame = self.view.bounds
            metalView = MetalView(frame: frame, device: MTLCreateSystemDefaultDevice())
            #if os(iOS)
            metalView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            #elseif os(macOS)
            metalView.autoresizingMask = [.width, .height]
            #endif
            self.view = metalView
        }

        // Set render delegate (may already be set by storyboard, but ensure it's set)
        metalView.renderDelegate = self

        // Get renderer (should already be initialized in MetalView.setupMetal)
        guard let existingRenderer = metalView.renderer else {
            fatalError("MetalView.renderer is nil - setupMetal() may not have been called")
        }
        renderer = existingRenderer

        // Set up the global render context
        MetalRenderContext.shared.renderer = renderer
    }

    private func setupRenderer() {
        // Ensure metalView is set up
        guard metalView != nil else {
            fatalError("metalView is nil in setupRenderer - setupMetalView() must be called first")
        }

        // Set up perspective projection matrix
        #if os(iOS)
        let viewSize = metalView.bounds.size
        #elseif os(macOS)
        let viewSize = metalView.frame.size
        #endif

        let aspectRatio = Float(viewSize.width / viewSize.height)
        let fovyRadians = fieldOfView * .pi / 180.0

        let projectionMatrix = simd_float4x4.perspective(
            fovyRadians: fovyRadians,
            aspectRatio: aspectRatio,
            nearZ: zNear,
            farZ: zFar
        )

        renderer.setProjectionMatrix(projectionMatrix)
    }

    private func setupScene() {
        // Set up camera
        #if os(iOS)
        camera = UICamera(view: self.view)
        #elseif os(macOS)
        // For macOS, we'll need to create a macOS-compatible camera
        // For now, use a simple camera that can be updated later
        camera = TopCamera()
        #endif

        touchDelegate = camera as? Touchable

        // Load mechanism from JSON
        antikytheraMechanism = AntikytheraMechanism(
            loadFromJsonFile: Bundle.main.url(forResource: "device", withExtension: "json")!
        )
        antikytheraMechanismView = AntikytheraMechanismView(mechanism: antikytheraMechanism)

        // Set up user dial
        #if os(iOS)
        var dialRad = Float(self.view.bounds.size.width) / 10.0
        if dialRad < 40.0 {
            dialRad = 40.0
        }

        userDial = UserDialView(radius: dialRad, mechanism: antikytheraMechanism, view: self.view)
        userDial.color = Color3D(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        userDial.position = Vector3D(
            x: Float(self.view.bounds.size.width) - dialRad * 2.0,
            y: dialRad * 2.0,
            z: 0.0
        )
        dialMode = false
        #endif
    }

    // MARK: - MetalViewDelegate

    func drawView(_ theView: MetalView) {
        // Clear and setup (handled by MTKView)
        renderer.loadIdentity()

        // Update camera viewpoint
        camera.updateViewpoint()

        // Draw main mechanism
        antikytheraMechanismView.draw()

        #if os(iOS)
        // Draw 2D overlay (user dial) in orthographic projection
        pushOrthoMatrix()
        renderer.pushMatrix()
        userDial.draw()
        renderer.popMatrix()
        popOrthoMatrix()
        #endif
    }

    func setupView(_ theView: MetalView) {
        // Only setup renderer if metalView has been initialized
        // This can be called before viewDidLoad() when the view size changes
        guard metalView != nil else {
            return
        }
        setupRenderer()
    }

    // MARK: - Matrix Helpers

    func pushOrthoMatrix() {
        // Save current projection and switch to orthographic
        #if os(iOS)
        let width = Float(view.bounds.size.width)
        let height = Float(view.bounds.size.height)
        #elseif os(macOS)
        let width = Float(view.frame.size.width)
        let height = Float(view.frame.size.height)
        #endif

        let orthoMatrix = simd_float4x4.orthographic(
            left: 0,
            right: width,
            bottom: 0,
            top: height,
            nearZ: -5,
            farZ: 1
        )

        renderer.setProjectionMatrix(orthoMatrix)
        renderer.loadIdentity()
    }

    func popOrthoMatrix() {
        // Restore perspective projection
        guard metalView != nil else {
            return
        }
        setupRenderer()
    }

    // MARK: - Status Bar

    #if os(iOS)
    override var prefersStatusBarHidden: Bool {
        return true
    }
    #endif

    // MARK: - Touch/Mouse Handling

    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let allTouches = event?.touches(for: self.view)

        if !dialMode && allTouches?.count == 1 {
            let touch = allTouches?.first
            let location = touch?.location(in: self.view)
            if userDial.hitTest(Vector3D(
                x: Float(location!.x),
                y: Float(self.view.bounds.size.height - location!.y),
                z: 0.0
            )) {
                userDial.color = Color3D(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.3)
                dialMode = true
                userDial.touchesBegan(touches, withEvent: event)
            } else {
                userDial.color = Color3D(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
                dialMode = false
            }
        }

        if !dialMode {
            touchDelegate?.touchesBegan(touches, withEvent: event)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dialMode {
            userDial.touchesMoved(touches, withEvent: event)
        } else {
            touchDelegate?.touchesMoved(touches, withEvent: event)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let allTouches = event?.touches(for: self.view)

        if dialMode && allTouches?.count == 1 {
            dialMode = false
            userDial.color = Color3D(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
        } else if !dialMode {
            touchDelegate?.touchesEnded(touches, withEvent: event)
        }

        if touches.first?.tapCount ?? 0 >= 2 {
            showVisualizationMenu()
        }
    }

    private func showVisualizationMenu() {
        let alertController = UIAlertController(
            title: "Visualization mode",
            message: "",
            preferredStyle: .actionSheet
        )

        let pointersAction = UIAlertAction(title: "Pointers", style: .default) { _ in
            self.antikytheraMechanismView.setCurrentState(.pointers, phase: .running)
        }

        let gearsAction = UIAlertAction(title: "Gears", style: .default) { _ in
            self.antikytheraMechanismView.setCurrentState(.gears, phase: .running)
        }

        let boxAction = UIAlertAction(title: "Box", style: .default) { _ in
            self.antikytheraMechanismView.setCurrentState(.box, phase: .running)
        }

        let pinSlotAction = UIAlertAction(title: "Pin and Slot", style: .default) { _ in
            self.antikytheraMechanismView.setCurrentState(.pinAndSlot, phase: .running)
        }

        let defaultAction = UIAlertAction(title: "Default", style: .cancel) { _ in
            self.antikytheraMechanismView.setCurrentState(.default, phase: .running)
        }

        alertController.addAction(pointersAction)
        alertController.addAction(gearsAction)
        alertController.addAction(boxAction)
        alertController.addAction(pinSlotAction)
        alertController.addAction(defaultAction)

        self.present(alertController, animated: true, completion: nil)
    }
    #endif

    #if os(macOS)
    // macOS mouse handling will be added here
    override func mouseDown(with event: NSEvent) {
        // TODO: Implement mouse handling for macOS
    }

    override func mouseDragged(with event: NSEvent) {
        // TODO: Implement mouse handling for macOS
    }

    override func mouseUp(with event: NSEvent) {
        // TODO: Implement mouse handling for macOS
    }
    #endif
}
