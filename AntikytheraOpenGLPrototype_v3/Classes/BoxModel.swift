//
//  BoxModel.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

import OpenGLES

class BoxModel: GLModel3D {

    var width: Float = 0.0
    var height: Float = 0.0
    var length: Float = 0.0

    init(width: Float, height: Float, length: Float) {
        super.init()
		buildModelWithWidth(width, height:height, length:length)
    }

    func buildModelWithWidth(w: Float, height h: Float, length len: Float) {
        
        width = w
        let halfWidth = width/2
        height = h
        let halfLength = height/2
        length = len
        let halfHeight = length/2
        
        vertices = [Vertex3D](count: 8, repeatedValue: Vertex3D.Zero)
        elements = [GLushort](count:34, repeatedValue: 0)
        
        // Pointer Vertices
        vertices[0] = Vertex3D(x: halfLength, y: -halfWidth, z: halfHeight)
        vertices[1] = Vertex3D(x: halfLength, y: halfWidth, z: halfHeight)
        
        vertices[2] = Vertex3D(x: -halfLength, y: -halfWidth, z: halfHeight)
        vertices[3] = Vertex3D(x: -halfLength, y: halfWidth, z: halfHeight)
        
        vertices[4] = Vertex3D(x: halfLength, y: -halfWidth, z: -halfHeight)
        vertices[5] = Vertex3D(x: halfLength, y: halfWidth, z: -halfHeight)
        
        vertices[6] = Vertex3D(x: -halfLength, y: -halfWidth, z: -halfHeight)
        vertices[7] = Vertex3D(x: -halfLength, y: halfWidth, z: -halfHeight)
        
        // Pointer Elements
        elements[0] =	0
        elements[1] =	1
        elements[2] =	2
        elements[3] =	3
        
        elements[4] =	3
        elements[5] =	1
        
        elements[6] =	1
        elements[7] =	5
        elements[8] =	3
        elements[9] =	7
        
        elements[10] =	7
        elements[11] =	5
        
        elements[12] =	5
        elements[13] =	4
        elements[14] =	7
        elements[15] =	6
        
        elements[16] =	6
        elements[17] =	4
        
        elements[18] =	4
        elements[19] =	0
        elements[20] =	6
        elements[21] =	2
        
        elements[22] =	2
        elements[23] =	0
        
        elements[24] =	0
        elements[25] =	4
        elements[26] =	1
        elements[27] =	5
        
        elements[28] =	5
        elements[29] =	3
        
        elements[30] =	3
        elements[31] =	7
        elements[32] =	2
        elements[33] =	6
        
        
        //	elements[0] =	0
        //	elements[1] =	1
        //	elements[2] =	3
        //	elements[3] =	5
        //	elements[4] =	7
        //	elements[5] =	6
        //	elements[6] =	3
        //	elements[7] =	2
        //	elements[8] =	0
        //	elements[9] =	6
        //	elements[10] =	4
        //	elements[11] =	5
        //	elements[12] =	0
        //	elements[13] =	1
    }

}
