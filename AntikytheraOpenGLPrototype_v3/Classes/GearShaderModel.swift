//
//  GearShaderModel.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import OpenGLES

class GearShaderModel: GLModel3D {
    
    init(gear: Gear) {
        super.init()
		buildModelFromGear(gear)
    }

    func buildModelFromGear(gear: Gear) {
        let toothSize: Float = 0.8
        
        let sideCount = gear.getToothCount()/2
        let radius = gear.getRadius() - toothSize/2.0
//        let toothRadius = radius + toothSize
        
        let sliceAngle = Float(M_PI)/Float(sideCount)
        let halfAngle = sliceAngle/2.0
        
        let vertexCount = (sideCount*4+2)
        vertices = [Vertex3D](count: vertexCount, repeatedValue: Vertex3D.Zero)
        let elementCount = (sideCount*10+1)
        elements = [GLushort](count: elementCount, repeatedValue: 0)
        
        
        // Vertices:
        vertices[0] = Vertex3D(x: 0.0, y: 0.0, z: 1.0)
        vertices[1] = Vertex3D(x: 0.0, y: 0.0, z: -1.0)
        
        for var i=0; i<sideCount; i++ {
            let angle = Float(i)*sliceAngle
            
            vertices[i*4+2] = Vertex3D(x: radius*cos(angle-halfAngle), y: radius*sin(angle-halfAngle), z: 1.0)
            vertices[i*4+3] = Vertex3D(x: radius*cos(angle), y: radius*sin(angle), z: 1.0)
            
            vertices[i*4+4] = Vertex3D(x: radius*cos(angle-halfAngle), y: radius*sin(angle-halfAngle), z: -1.0)
            vertices[i*4+5] = Vertex3D(x: radius*cos(angle), y: radius*sin(angle), z: -1.0)
        }
        
        
        // Elements:
        for var i=0; i<sideCount; i++ {
            elements[i*10] = 0          //1
            elements[i*10+1] = GLushort(i*4+2)	//2
            elements[i*10+2] = GLushort(i*4+3)	//3
            elements[i*10+3] = GLushort(i*4+4)	//6
            elements[i*10+4] = GLushort(i*4+5)	//7
            elements[i*10+5] = 1		//5
            elements[i*10+6] = GLushort(i*4+5)	//7
            elements[i*10+8] = GLushort(i*4+3)	//3
            
            if (i<(sideCount-1)) {
                elements[i*10+7] = GLushort((i+1)*4+4)	//8
                elements[i*10+9] = GLushort((i+1)*4+2)	//4
            } else {
                elements[i*10+7] = 4	//8
                elements[i*10+9] = 2	//4
                elements[i*10+10] = 0	//1
            }
        }
    }

}