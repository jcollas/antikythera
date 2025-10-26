//
//  MetalRenderer.swift
//  Antikythera
//
//  Metal rendering system for the Antikythera Mechanism
//

import Metal
import MetalKit
import simd

// MARK: - Uniforms Structure (must match shader)

struct Uniforms {
    var modelViewProjectionMatrix: simd_float4x4
    var color: simd_float4
}

// MARK: - Metal Renderer

class MetalRenderer: NSObject {

    // MARK: - Properties

    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    var pipelineState: MTLRenderPipelineState!
    var depthStencilState: MTLDepthStencilState!

    // Matrix stacks for transform hierarchy
    private var projectionMatrix: simd_float4x4 = matrix_identity_float4x4
    private var modelViewMatrixStack: [simd_float4x4] = [matrix_identity_float4x4]

    // Current rendering state
    private var currentColor: simd_float4 = simd_float4(1, 1, 1, 1)

    // Current render command encoder (valid only during frame rendering)
    private var currentRenderEncoder: MTLRenderCommandEncoder?

    // MARK: - Initialization

    init?(device: MTLDevice) {
        self.device = device

        guard let queue = device.makeCommandQueue() else {
            return nil
        }
        self.commandQueue = queue

        super.init()

        guard setupPipeline() else {
            return nil
        }

        setupDepthStencilState()
    }

    // MARK: - Pipeline Setup

    private func setupPipeline() -> Bool {
        guard let library = device.makeDefaultLibrary() else {
            print("Failed to create Metal library")
            return false
        }

        guard let vertexFunction = library.makeFunction(name: "vertex_main"),
              let fragmentFunction = library.makeFunction(name: "fragment_main") else {
            print("Failed to create shader functions")
            return false
        }

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float

        // Configure blending for transparency (equivalent to GL_BLEND)
        pipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
        pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
        pipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        pipelineDescriptor.colorAttachments[0].rgbBlendOperation = .add
        pipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
        pipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
        pipelineDescriptor.colorAttachments[0].alphaBlendOperation = .add

        // Vertex descriptor for position attribute
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex3D>.stride
        vertexDescriptor.layouts[0].stepFunction = .perVertex

        pipelineDescriptor.vertexDescriptor = vertexDescriptor

        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            print("Failed to create pipeline state: \(error)")
            return false
        }

        return true
    }

    private func setupDepthStencilState() {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = false // Default: depth test disabled

        guard let state = device.makeDepthStencilState(descriptor: depthStencilDescriptor) else {
            fatalError("Failed to create depth stencil state")
        }

        depthStencilState = state
    }

    // MARK: - Render State Management

    func beginFrame(with renderEncoder: MTLRenderCommandEncoder) {
        currentRenderEncoder = renderEncoder
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setDepthStencilState(depthStencilState)

        // Reset matrix stack
        modelViewMatrixStack = [matrix_identity_float4x4]
    }

    func endFrame() {
        currentRenderEncoder = nil
    }

    // MARK: - Matrix Operations (OpenGL-style API)

    func setProjectionMatrix(_ matrix: simd_float4x4) {
        projectionMatrix = matrix
    }

    func loadIdentity() {
        modelViewMatrixStack[modelViewMatrixStack.count - 1] = matrix_identity_float4x4
    }

    func pushMatrix() {
        let currentMatrix = modelViewMatrixStack.last!
        modelViewMatrixStack.append(currentMatrix)
    }

    func popMatrix() {
        guard modelViewMatrixStack.count > 1 else {
            print("Warning: Attempted to pop last matrix from stack")
            return
        }
        modelViewMatrixStack.removeLast()
    }

    func translate(x: Float, y: Float, z: Float) {
        let translation = simd_float4x4(translation: simd_float3(x, y, z))
        modelViewMatrixStack[modelViewMatrixStack.count - 1] = modelViewMatrixStack.last! * translation
    }

    func rotate(angle: Float, x: Float, y: Float, z: Float) {
        let radians = angle * .pi / 180.0
        let axis = normalize(simd_float3(x, y, z))
        let rotation = simd_float4x4(rotationAngle: radians, axis: axis)
        modelViewMatrixStack[modelViewMatrixStack.count - 1] = modelViewMatrixStack.last! * rotation
    }

    func scale(x: Float, y: Float, z: Float) {
        let scale = simd_float4x4(scale: simd_float3(x, y, z))
        modelViewMatrixStack[modelViewMatrixStack.count - 1] = modelViewMatrixStack.last! * scale
    }

    func multMatrix(_ matrix: simd_float4x4) {
        modelViewMatrixStack[modelViewMatrixStack.count - 1] = modelViewMatrixStack.last! * matrix
    }

    // MARK: - Color Management

    func setColor(r: Float, g: Float, b: Float, a: Float) {
        currentColor = simd_float4(r, g, b, a)
    }

    // MARK: - Drawing

    func drawTriangleStrip(vertices: MTLBuffer, count: Int, indices: MTLBuffer, indexCount: Int) {
        guard let encoder = currentRenderEncoder else {
            print("Error: No active render encoder")
            return
        }

        // Create uniforms
        var uniforms = Uniforms(
            modelViewProjectionMatrix: projectionMatrix * modelViewMatrixStack.last!,
            color: currentColor
        )

        // Encode draw call
        encoder.setVertexBuffer(vertices, offset: 0, index: 0)
        encoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.size, index: 1)
        encoder.drawIndexedPrimitives(
            type: .triangleStrip,
            indexCount: indexCount,
            indexType: .uint16,
            indexBuffer: indices,
            indexBufferOffset: 0
        )
    }

    // MARK: - Depth Testing

    func enableDepthTest() {
        let depthDescriptor = MTLDepthStencilDescriptor()
        depthDescriptor.depthCompareFunction = .less
        depthDescriptor.isDepthWriteEnabled = true

        if let state = device.makeDepthStencilState(descriptor: depthDescriptor) {
            depthStencilState = state
            currentRenderEncoder?.setDepthStencilState(state)
        }
    }

    func disableDepthTest() {
        let depthDescriptor = MTLDepthStencilDescriptor()
        depthDescriptor.depthCompareFunction = .always
        depthDescriptor.isDepthWriteEnabled = false

        if let state = device.makeDepthStencilState(descriptor: depthDescriptor) {
            depthStencilState = state
            currentRenderEncoder?.setDepthStencilState(state)
        }
    }
}

// MARK: - Matrix Extensions

extension simd_float4x4 {
    init(translation: simd_float3) {
        self.init(
            simd_float4(1, 0, 0, 0),
            simd_float4(0, 1, 0, 0),
            simd_float4(0, 0, 1, 0),
            simd_float4(translation.x, translation.y, translation.z, 1)
        )
    }

    init(scale: simd_float3) {
        self.init(
            simd_float4(scale.x, 0, 0, 0),
            simd_float4(0, scale.y, 0, 0),
            simd_float4(0, 0, scale.z, 0),
            simd_float4(0, 0, 0, 1)
        )
    }

    init(rotationAngle angle: Float, axis: simd_float3) {
        let c = cos(angle)
        let s = sin(angle)
        let t = 1 - c
        let x = axis.x, y = axis.y, z = axis.z

        self.init(
            simd_float4(t * x * x + c,     t * x * y + z * s, t * x * z - y * s, 0),
            simd_float4(t * x * y - z * s, t * y * y + c,     t * y * z + x * s, 0),
            simd_float4(t * x * z + y * s, t * y * z - x * s, t * z * z + c,     0),
            simd_float4(0,                 0,                 0,                 1)
        )
    }

    static func perspective(fovyRadians fovy: Float, aspectRatio: Float, nearZ: Float, farZ: Float) -> simd_float4x4 {
        let ys = 1 / tanf(fovy * 0.5)
        let xs = ys / aspectRatio
        let zs = farZ / (nearZ - farZ)

        return simd_float4x4(
            simd_float4(xs,  0,  0,  0),
            simd_float4(0,  ys,  0,  0),
            simd_float4(0,   0, zs, -1),
            simd_float4(0,   0, zs * nearZ,  0)
        )
    }

    static func orthographic(left: Float, right: Float, bottom: Float, top: Float, nearZ: Float, farZ: Float) -> simd_float4x4 {
        let rl = right - left
        let tb = top - bottom
        let fn = farZ - nearZ

        return simd_float4x4(
            simd_float4(2 / rl,        0,         0, 0),
            simd_float4(0,        2 / tb,         0, 0),
            simd_float4(0,             0,  -1 / fn, 0),
            simd_float4(-(right + left) / rl, -(top + bottom) / tb, -nearZ / fn, 1)
        )
    }
}
