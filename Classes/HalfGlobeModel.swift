//
//  HalfGlobeModel.swift
//  Antikythera
//
//  Created by Matt Ricketson on 4/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

import CoreGraphics
import Metal
import MetalKit

class HalfGlobeModel: MetalModel3D {

    init(radius: Float) {
        super.init()
        buildModelWithRadius(radius)
        updateBuffers()
    }

    func buildModelWithRadius(_ radius: Float) {
        let lonSideCount = 8
        let latSideCount = 8
        
        let phiStep = Float(Float.pi*7/6)/Float(lonSideCount)
        let thetaStep = Float(Float.pi*7/6)/Float(latSideCount)
        
        let vertexCount = latSideCount*(lonSideCount-1) + 2
        vertices = [Vertex3D](repeating: Vertex3D.zero, count: vertexCount)
        let elementCount = (latSideCount*2+2)*lonSideCount
        elements = [UInt16](repeating: 0, count: elementCount)
        
        
        // Shaft Vertices:
        vertices[0] = Vertex3D(x: 0.0, y: 0.0, z: radius)
        
        for i in 1 ..< (lonSideCount) {
            let phiAngle = Float(i)*phiStep
            for n in 0 ..< latSideCount {
                let thetaAngle = Float(n)*thetaStep
                
                let vx = radius*cos(thetaAngle)*sin(phiAngle)
                let vy = radius*sin(thetaAngle)*sin(phiAngle)
                let vz = radius*cos(phiAngle)
                
                vertices[(i-1)*latSideCount+n+1] = Vertex3D(x: vx, y: vy, z: vz)
            }
        }
        
        vertices[vertexCount-1] = Vertex3D(x: 0.0, y: 0.0, z: -radius)
        
        // Shaft Elements:
        var topStart: UInt16 = 0
        var bottomStart: UInt16 = 0

        // North Pole
        var eCount = 0
        for i in 0 ..< latSideCount {
            elements[eCount] = 0
            elements[eCount+1] = UInt16(i+1)
            eCount += 2
        }
        elements[eCount] = 0
        elements[eCount+1] = 1
        eCount += 2

        // Body
        for n in 0 ..< (lonSideCount-2) {
            topStart = UInt16(latSideCount*n+1)
            bottomStart = UInt16(latSideCount*(n+1)+1)

            for i in 0 ..< latSideCount {
                elements[eCount] = topStart+UInt16(i)
                elements[eCount+1] = bottomStart+UInt16(i)
                eCount += 2
            }

            elements[eCount] = topStart
            elements[eCount+1] = bottomStart
            eCount += 2
        }

        // South Pole
        topStart = UInt16(latSideCount*(lonSideCount-2)+1)
        for i in 0 ..< latSideCount {
            elements[eCount] = topStart+UInt16(i)
            elements[eCount+1] = UInt16(vertexCount-1)
            eCount += 2
        }
        elements[eCount] = topStart
        elements[eCount+1] = UInt16(vertexCount-1)
        eCount += 2
        
    }

}
