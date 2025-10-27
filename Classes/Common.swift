//  Common.swift
//  Antikythera
//
//  Created by Matt Ricketson on 2/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

import CoreGraphics

func DegreesToRadians (_ value: Double) -> Double {
    return value * .pi / 180.0
}

func RadiansToDegrees (_ value: Double) -> Double {
    return value * 180.0 / .pi
}

// MARK:- Color3D

struct Color3D {
    var red: Float
    var green: Float
    var blue: Float
    var alpha: Float
    
    init(red: Float, green: Float, blue: Float, alpha: Float) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    mutating func set(_ inRed: Float, inGreen: Float, inBlue: Float, inAlpha: Float) {
        red = inRed
        green = inGreen
        blue = inBlue
        alpha = inAlpha
    }
    
    func interpolate(_ color2: Color3D, percent: Float) -> Color3D {
        var ret: Color3D!
        
        ret.red = red + ((color2.red - red) * percent)
        ret.blue = blue + ((color2.blue - blue) * percent)
        ret.green = green + ((color2.green - green) * percent)
        ret.alpha = alpha + ((color2.alpha - alpha) * percent)
        
        if (ret.red > 1.0) {
            ret.red -= 1.0
        }
        if (ret.green > 1.0) {
            ret.green -= 1.0
        }
        if (ret.blue > 1.0) {
            ret.blue -= 1.0
        }
        if (ret.alpha > 1.0) {
            ret.alpha = 1.0
        }
        if (ret.red < 0.0) {
            ret.red += 1.0
        }
        if (ret.green < 0.0) {
            ret.green += 1.0
        }
        if (ret.blue < 0.0) {
            ret.blue += 1.0
        }
        if (ret.alpha < 0.0) {
            ret.alpha += 1.0
        }
        
        return ret
    }
}

// MARK: - Vertex3D

func == (lhs: Vertex3D, rhs: Vertex3D) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

struct Vertex3D: Equatable {
    var x: Float
    var y: Float
    var z: Float
    static let zero = Vertex3D(x: 0.0, y: 0.0, z: 0.0)
    
    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    mutating func set(_ inX: Float, inY: Float, inZ: Float) {
        self.x = inX
        self.y = inY
        self.z = inZ
    }
    
}

// MARK: - Vector3D

func == (lhs: Vector3D, rhs: Vector3D) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

struct Vector3D: Equatable {
    var x: Float
    var y: Float
    var z: Float
    static let zero = Vector3D(x: 0.0, y: 0.0, z: 0.0)

    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    mutating func set(_ inX: Float, inY: Float, inZ: Float) {
        self.x = inX
        self.y = inY
        self.z = inZ
    }
    
    var magnitude: Float {
        return sqrtf((x * x) + (y * y) + (z * z))
    }
    
    mutating func normalize() {
        let vecMag = self.magnitude
        if vecMag == 0.0 {
            x = 1.0
            y = 0.0
            z = 0.0
            return
        }
        
        x /= vecMag
        y /= vecMag
        z /= vecMag
    }
    
    func dotProduct(_ vector: Vector3D) -> Float {
        return x*vector.x + y*vector.y + z * vector.z
    }
    
    func crossProduct(_ vector: Vector3D) -> Vector3D {
        var ret = Vector3D.zero
        
        ret.x = (y * vector.z) - (z * vector.y)
        ret.y = (z * vector.x) - (x * vector.z)
        ret.z = (x * vector.y) - (y * vector.x)

        return ret
    }
    
    func startAndEndPoints(_ end: Vector3D) -> Vector3D {
        var ret = Vector3D.zero

        ret.x = end.x - x
        ret.y = end.y - y
        ret.z = end.z - z
        //	Vector3DNormalize(&ret);
        return ret
    }
    
    func add(_ vector: Vector3D) -> Vector3D {
        var ret = Vector3D.zero

        ret.x = x + vector.x
        ret.y = y + vector.y
        ret.z = z + vector.z
        return ret
    }
    
    mutating func flip() {
        x = -x
        y = -y
        z = -z
    }

}

// MARK: - Rotation3D

// A Rotation3D is just a Vertex3D used to store three angles (pitch, yaw, roll) instead of cartesian coordinates.
// For simplicity, we just reuse the Vertex3D, even though the member names should probably be either xRot, yRot, 
// and zRot, or else pitch, yaw, roll.

typealias Rotation3D = Vertex3D

// MARK: - Face3D

// Face3D is used to hold three integers which will be integer index values to another array
struct Face3D {
    var v1: Int
    var v2: Int
    var v3: Int

    init(v1: Int, v2: Int, v3: Int) {
        self.v1 = v1
        self.v2 = v2
        self.v3 = v3
    }
}

// MARK: - Triangle3D

struct Triangle3D {
    var v1: Vertex3D
    var v2: Vertex3D
    var v3: Vertex3D
    
    init(v1: Vertex3D, v2: Vertex3D, v3: Vertex3D) {
        self.v1 = v1
        self.v2 = v2
        self.v3 = v3
    }

}

// MARK: - Interleaving

struct TextureCoord3D {
    var s: Float
    var t: Float
}

struct VertexData3D {
    var vertext: Vertex3D
    var normal: Vector3D
}

struct TexturedVertexData3D {
    var vertext: Vertex3D
    var normal: Vector3D
    var texCoord: TextureCoord3D
}

struct ColoredVertexData3D {
    var vertext: Vertex3D
    var normal: Vector3D
    var color: Color3D
}
