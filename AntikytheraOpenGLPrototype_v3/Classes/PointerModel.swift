//
//  PointerModel.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/18/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

import CoreGraphics
import OpenGLES

class PointerModel: GLModel3D {

    var shaftLength: Float = 0.0
    var shaftRadius: Float = 0.0
    
    var pointerLength: Float = 0.0
    var pointerWidth: Float = 0.0

    init(shaftLength sLen: Float, shaftRadius sRad: Float, pointerLength pLen: Float, pointerWidth pWidth: Float) {
        super.init()
		buildModelWithShaftLength(sLen, shaftRadius:sRad, pointerLength:pLen, pointerWidth:pWidth) //Weird bug: for some reason -- gone?
    }

    func buildModelWithShaftLength(_ sLen: Float, shaftRadius sRad: Float, pointerLength pLen: Float, pointerWidth pWidth: Float) {
        let sideCount = 8
        
        shaftLength = sLen
        shaftRadius = sRad
        
        pointerLength = pLen
        pointerWidth = pWidth
        
        let sliceAngle = 2.0 * .pi / Float(sideCount)
        let halfAngle = sliceAngle/2.0
        
        vertices = [Vertex3D](repeating: Vertex3D.zero, count: (sideCount*4+2) + 8)
        elements = [GLushort](repeating: 0, count: (sideCount*10+1) + (2) + (14))
        
        // Shaft Vertices:
        vertices[0] = Vertex3D(x: 0.0, y: 0.0, z: self.shaftLength)
        vertices[1] = Vertex3D.zero
        
        for i in 0 ..< sideCount {
            let angle = Float(i)*sliceAngle
            
            vertices[i*4+2] = Vertex3D(x: self.shaftRadius*cos(angle-halfAngle), y: self.shaftRadius*sin(angle-halfAngle), z:self.shaftLength)
            vertices[i*4+3] = Vertex3D(x: self.shaftRadius*cos(angle), y: self.shaftRadius*sin(angle), z:self.shaftLength)
            
            vertices[i*4+4] = Vertex3D(x: self.shaftRadius*cos(angle-halfAngle), y: self.shaftRadius*sin(angle-halfAngle), z: 0.0)
            vertices[i*4+5] = Vertex3D(x: self.shaftRadius*cos(angle), y: self.shaftRadius*sin(angle), z: 0.0)
        }
        
        
        // Shaft Elements:
        for i in 0 ..< sideCount {
            elements[i*10] = 0			//1
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
        
        // Transition:
        let le = (sideCount-1)*10+10
        let lv = (sideCount-1)*4+5
        elements[le+1] = 0
        elements[le+2] = GLushort(lv+1)
        
        // Pointer Vertices
        let height = self.shaftLength/abs(self.shaftLength)
        vertices[lv+1] = Vertex3D(x: self.shaftRadius, y: 0.0, z: height)
        vertices[lv+2] = Vertex3D(x: 0.0, y: self.shaftRadius, z: height)
        
        vertices[lv+3] = Vertex3D(x: self.pointerLength, y: 0.0, z: height)
        vertices[lv+4] = Vertex3D(x: self.pointerLength-self.shaftRadius, y: self.shaftRadius, z: height)
        
        vertices[lv+5] = Vertex3D(x: self.shaftRadius, y: 0.0, z: 0.0)
        vertices[lv+6] = Vertex3D(x: 0.0, y: self.shaftRadius, z: 0.0)
        
        vertices[lv+7] = Vertex3D(x: self.pointerLength, y: 0.0, z: 0.0)
        vertices[lv+8] = Vertex3D(x: self.pointerLength-self.shaftRadius, y: self.shaftRadius, z: 0.0)
        
        // Pointer Elements
        elements[le+3] = GLushort(lv+1)
        elements[le+4] = GLushort(lv+2)
        elements[le+5] = GLushort(lv+4)
        elements[le+6] = GLushort(lv+6)
        elements[le+7] = GLushort(lv+8)
        elements[le+8] = GLushort(lv+7)
        elements[le+9] = GLushort(lv+4)
        elements[le+10] = GLushort(lv+3)
        elements[le+11] = GLushort(lv+1)
        elements[le+12] = GLushort(lv+7)
        elements[le+13] = GLushort(lv+5)
        elements[le+14] = GLushort(lv+6)
        elements[le+15] = GLushort(lv+1)
        elements[le+16] = GLushort(lv+2)
    }

}
