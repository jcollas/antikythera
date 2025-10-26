//
//  MetalRenderContext.swift
//  Antikythera
//
//  Created by Claude Code on 10/26/25.
//

import Metal
import MetalKit

/// Singleton providing global access to the Metal renderer
class MetalRenderContext {
    static let shared = MetalRenderContext()

    var renderer: MetalRenderer?

    private init() {}
}
