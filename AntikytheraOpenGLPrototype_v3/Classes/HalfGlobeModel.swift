//
//  HalfGlobeModel.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

import CoreGraphics
import OpenGLES

class HalfGlobeModel: GLModel3D {
    
    init(radius: Float) {
        super.init()
		buildModelWithRadius(radius)
    }

    func buildModelWithRadius(radius: Float) {
        let lonSideCount = 8
        let latSideCount = 8
        
        let phiStep = Float(M_PI*7/6)/Float(lonSideCount)
        let thetaStep = Float(M_PI*7/6)/Float(latSideCount)
        
        let vertexCount = latSideCount*(lonSideCount-1) + 2
        vertices = [Vertex3D](count: vertexCount, repeatedValue: Vertex3D.Zero)
        let elementCount = (latSideCount*2+2)*lonSideCount
        elements = [GLushort](count: elementCount, repeatedValue: 0)
        
        
        // Shaft Vertices:
        vertices[0] = Vertex3D(x: 0.0, y: 0.0, z: radius)
        
        for var i=1; i<(lonSideCount); i++ {
            let phiAngle = Float(i)*phiStep
            for var n=0; n<latSideCount; n++ {
                let thetaAngle = Float(n)*thetaStep
                
                let vx = radius*cos(thetaAngle)*sin(phiAngle)
                let vy = radius*sin(thetaAngle)*sin(phiAngle)
                let vz = radius*cos(phiAngle)
                
                vertices[(i-1)*latSideCount+n+1] = Vertex3D(x: vx, y: vy, z: vz)
            }
        }
        
        vertices[vertexCount-1] = Vertex3D(x: 0.0, y: 0.0, z: -radius)
        
        // Shaft Elements:
        var topStart: GLushort = 0
        var bottomStart: GLushort = 0
        
        // North Pole
        var eCount = 0;
        for var i=0; i<latSideCount; i++ {
            elements[eCount] = 0
            elements[eCount+1] = GLushort(i+1)
            eCount += 2
        }
        elements[eCount] = 0
        elements[eCount+1] = 1
        eCount += 2
        
        // Body
        for var n=0; n<(lonSideCount-2); n++ {
            topStart = GLushort(latSideCount*n+1)
            bottomStart = GLushort(latSideCount*(n+1)+1)
            
            for var i=0; i<latSideCount; i++ {
                elements[eCount] = topStart+GLushort(i)
                elements[eCount+1] = bottomStart+GLushort(i)
                eCount += 2
            }
            
            elements[eCount] = topStart
            elements[eCount+1] = bottomStart
            eCount += 2
        }
        
        // South Pole
        topStart = GLushort(latSideCount*(lonSideCount-2)+1)
        for var i=0; i<latSideCount; i++ {
            elements[eCount] = topStart+GLushort(i)
            elements[eCount+1] = GLushort(vertexCount-1)
            eCount += 2
        }
        elements[eCount] = topStart
        elements[eCount+1] = GLushort(vertexCount-1)
        eCount += 2
        
    }

}
