//
//  MetalModel3D.swift
//  Antikythera
//
//  Metal-based 3D model rendering (replaces GLModel3D)
//

import Metal
import MetalKit

class MetalModel3D: NSObject, ModelView {

    // MARK: - Properties

    var vertices: [Vertex3D] = []
    var elements: [UInt16] = []

    private var vertexBuffer: MTLBuffer?
    private var indexBuffer: MTLBuffer?
    private var device: MTLDevice?

    // MARK: - Initialization

    override init() {
        super.init()
        self.device = MTLCreateSystemDefaultDevice()
    }

    // MARK: - Buffer Management

    func updateBuffers() {
        guard let device = device else {
            print("Error: No Metal device available")
            return
        }

        // Create vertex buffer
        if !vertices.isEmpty {
            let vertexDataSize = vertices.count * MemoryLayout<Vertex3D>.stride
            vertexBuffer = device.makeBuffer(bytes: vertices, length: vertexDataSize, options: [])
        }

        // Create index buffer
        if !elements.isEmpty {
            let indexDataSize = elements.count * MemoryLayout<UInt16>.stride
            indexBuffer = device.makeBuffer(bytes: elements, length: indexDataSize, options: [])
        }
    }

    // MARK: - Drawing

    func draw() {
        // Get the global renderer instance
        guard let renderer = MetalRenderContext.shared.renderer else {
            print("Error: No active Metal renderer")
            return
        }

        // Ensure buffers are up to date
        if vertexBuffer == nil || indexBuffer == nil {
            updateBuffers()
        }

        guard let vertexBuffer = vertexBuffer,
              let indexBuffer = indexBuffer else {
            return
        }

        // Draw using the renderer
        renderer.drawTriangleStrip(
            vertices: vertexBuffer,
            count: vertices.count,
            indices: indexBuffer,
            indexCount: elements.count
        )
    }
}
