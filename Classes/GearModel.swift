//
//  GearModel.swift
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import CoreGraphics
import Metal
import MetalKit

class GearModel: MetalModel3D {

    init(gear: Gear) {
        super.init()
        buildModelFromGear(gear)
        updateBuffers()
    }

    func buildModelFromGear(_ gear: Gear) {
        let toothSize: Float = 0.8
        let toothCount = gear.toothCount
        let radius = gear.radius - toothSize/2.0
        let toothRadius = radius + toothSize
        
        let sliceAngle = (2.0 * .pi)/Float(toothCount)
        let halfAngle = sliceAngle/2.0
        
        vertices = [Vertex3D](repeating: Vertex3D.zero, count: toothCount*4+2)
        elements = [UInt16](repeating: 0, count: toothCount*10+1)
        
        // Vertices:
        vertices[0] = Vertex3D(x: 0.0, y: 0.0, z: 1.0)
        vertices[1] = Vertex3D(x: 0.0, y: 0.0, z: -1.0)

        for i in 0 ..< toothCount {
            let angle = Float(i)*sliceAngle
            
            vertices[i*4+2] = Vertex3D(x: radius*cos(angle-halfAngle), y: radius*sin(angle-halfAngle), z: 1.0)
            vertices[i*4+3] = Vertex3D(x: toothRadius*cos(angle), y: toothRadius*sin(angle), z: 1.0)
            
            vertices[i*4+4] = Vertex3D(x: radius*cos(angle-halfAngle), y: radius*sin(angle-halfAngle), z: -1.0)
            vertices[i*4+5] = Vertex3D(x: toothRadius*cos(angle), y: toothRadius*sin(angle), z: -1.0)
        }
        
        
        // Elements:
        for i in 0 ..< toothCount {
            elements[i*10] = 0			//1
            elements[i*10+1] = UInt16(i*4+2)	//2
            elements[i*10+2] = UInt16(i*4+3)	//3
            elements[i*10+3] = UInt16(i*4+4)	//6
            elements[i*10+4] = UInt16(i*4+5)	//7
            elements[i*10+5] = 1		//5
            elements[i*10+6] = UInt16(i*4+5)	//7
            elements[i*10+8] = UInt16(i*4+(3))	//3

            if (i<(toothCount-1)) {
                elements[i*10+7] = UInt16((i+1)*4+4)	//8
                elements[i*10+9] = UInt16((i+1)*4+2)	//4
            } else {
                elements[i*10+7] = 4	//8
                elements[i*10+9] = 2	//4
                elements[i*10+10] = 0	//1
            }
        }
    }

}
