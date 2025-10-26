//  OpenGLCommon.h
//  AntikytheraOpenGLPrototype
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
    
//    mutating rotateToDirection(pitch: Float, azimuth: Float) {
//       	x = -sin(DEGREES_TO_RADIANS(azimuth)) * cos(DEGREES_TO_RADIANS(pitch))
//        y = sin(DEGREES_TO_RADIANS(pitch))
//        z = cos(DEGREES_TO_RADIANS(pitch)) * cos(DEGREES_TO_RADIANS(azimuth))
//    }
    
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
    
//    func calculateSurfaceNormal(triangle: Triangle3D) -> Vector3D {
//        let u = triangle.v2.startAndEndPoints(triangle.v1)
//        let v = triangle.v3.startAndEndPoints(triangle.v1)
//        
//        var ret = Vector3D()
//        ret.x = (u.y * v.z) - (u.z * v.y)
//        ret.y = (u.z * v.x) - (u.x * v.z)
//        ret.z = (u.x * v.y) - (u.y * v.x)
//        return ret
//    }

}

// MARK: - VertexArray3D
/*
typedef struct {
	Vertex3D *set;
	int count;
} VertexArray3D;
static inline VertexArray3D* VertexArray3DConstruct()
{
	VertexArray3D *va;
	va = (VertexArray3D*)malloc(sizeof(VertexArray3D));
	va->set = NULL; //(Vertex3D*)malloc(sizeof(Vertex3D));
	va->count = 0;
	return va;
}
static inline VertexArray3D VertexArray3DMake(Vertex3D *vertices, int count)
{
	VertexArray3D va;
	va.set = vertices;
	va.count = count;
	return va;
}
static inline VertexArray3D* VertexArray3DAddVertex(VertexArray3D *array, Vertex3D vertex)
{
	(*array).set = (Vertex3D*)realloc((*array).set,((*array).count+1)*sizeof(Vertex3D));
	(*array).set[(*array).count] = vertex;
	(*array).count++;
	return array;
}
static inline void setVertexPointer(VertexArray3D array)
{
	glVertexPointer(3, GL_FLOAT, 0, array.set);
}
//deprecated:
static inline void glDrawVertexArray(VertexArray3D va)
{
	glVertexPointer(3, GL_FLOAT, 0, va.set);
	glDrawArrays(GL_TRIANGLES, 0, va.count*3);
}

// MARK: - DrawTask3D

typedef struct {
	GLushort *faces;
	int count;
	GLenum mode;
} DrawTask3D;
static inline DrawTask3D* DrawTask3DConstruct(GLenum mode)
{
	DrawTask3D *task;
	task = (DrawTask3D*)malloc(sizeof(DrawTask3D));
	(*task).faces = (GLushort*)malloc(sizeof(GLushort));
	(*task).count = 0;
	(*task).mode = mode;
	return task;
}
static inline DrawTask3D* DrawTask3DAddIndex(DrawTask3D *task, GLushort index)
{
	(*task).faces = (GLushort*)realloc((*task).faces,((*task).count+1)*sizeof(GLushort));
	(*task).faces[(*task).count] = index;
	(*task).count++;
	return task;
}
static inline DrawTask3D* DrawTask3DAddFace(DrawTask3D *task, Face3D face)
{
	(*task).faces = (GLushort*)realloc((*task).faces,((*task).count+3)*sizeof(GLushort));
	(*task).faces[(*task).count] = face.v1;
	(*task).faces[(*task).count+1] = face.v2;
	(*task).faces[(*task).count+2] = face.v3;
	(*task).count+=3;
	return task;
}
static inline void drawTask(DrawTask3D task)
{
	glDrawElements(task.mode, task.count, GL_UNSIGNED_SHORT, task.faces);
}
*/

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

// MARK: - Matrices

/*
typedef GLfloat Matrix3D[16];
*/

// OpenGL ES hardware accelerates Vector * Matrix but not Matrix * Matrix
/* 
 These defines, the fast sine function, and the vectorized version of the 
 matrix multiply function below are based on the Matrix4Mul method from 
 the vfp-math-library. The code has been modified, and are subject to  
 the original license terms and ownership as follow:
 
 VFP math library for the iPhone / iPod touch
 
 Copyright (c) 2007-2008 Wolfgang Engel and Matthias Grundmann
 http://code.google.com/p/vfpmathlibrary/
 
 This software is provided 'as-is', without any express or implied warranty.
 In no event will the authors be held liable for any damages arising
 from the use of this software.
 Permission is granted to anyone to use this software for any purpose,
 including commercial applications, and to alter it and redistribute it freely,
 subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must
 not claim that you wrote the original software. If you use this
 software in a product, an acknowledgment in the product documentation
 would be appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must
 not be misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source distribution.
 */

/*
static inline float fastAbs(float x) { return (x < 0) ? -x : x; }
static inline GLfloat fastSinf(GLfloat x)
{
	// fast sin function; maximum error is 0.001
	const float P = 0.225;
	
	x = x * M_1_PI;
	int k = (int) round(x);
	x = x - k;
    
	float y = (4 - 4 * fastAbs(x)) * x;
    
	y = P * (y * fastAbs(y) - y) + y;
    
	return (k&1) ? -y : y;
}

#if TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR
#define VFP_CLOBBER_S0_S31 "s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7", "s8",  \
"s9", "s10", "s11", "s12", "s13", "s14", "s15", "s16",  \
"s17", "s18", "s19", "s20", "s21", "s22", "s23", "s24",  \
"s25", "s26", "s27", "s28", "s29", "s30", "s31"
#define VFP_VECTOR_LENGTH(VEC_LENGTH) "fmrx    r0, fpscr                         \n\t" \
"bic     r0, r0, #0x00370000               \n\t" \
"orr     r0, r0, #0x000" #VEC_LENGTH "0000 \n\t" \
"fmxr    fpscr, r0                         \n\t"
#define VFP_VECTOR_LENGTH_ZERO "fmrx    r0, fpscr            \n\t" \
"bic     r0, r0, #0x00370000  \n\t" \
"fmxr    fpscr, r0            \n\t" 
#endif
static inline void Matrix3DMultiply(Matrix3D m1, Matrix3D m2, Matrix3D result)
{
#if TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR
    __asm__ __volatile__ ( VFP_VECTOR_LENGTH(3)
                          
                          // Interleaving loads and adds/muls for faster calculation.
                          // Let A:=src_ptr_1, B:=src_ptr_2, then
                          // function computes A*B as (B^T * A^T)^T.
                          
                          // Load the whole matrix into memory.
                          "fldmias  %2, {s8-s23}    \n\t"
                          // Load first column to scalar bank.
                          "fldmias  %1!, {s0-s3}    \n\t"
                          // First column times matrix.
                          "fmuls s24, s8, s0        \n\t"
                          "fmacs s24, s12, s1       \n\t"
                          
                          // Load second column to scalar bank.
                          "fldmias %1!,  {s4-s7}    \n\t"
                          
                          "fmacs s24, s16, s2       \n\t"
                          "fmacs s24, s20, s3       \n\t"
                          // Save first column.
                          "fstmias  %0!, {s24-s27}  \n\t" 
                          
                          // Second column times matrix.
                          "fmuls s28, s8, s4        \n\t"
                          "fmacs s28, s12, s5       \n\t"
                          
                          // Load third column to scalar bank.
                          "fldmias  %1!, {s0-s3}    \n\t"
                          
                          "fmacs s28, s16, s6       \n\t"
                          "fmacs s28, s20, s7       \n\t"
                          // Save second column.
                          "fstmias  %0!, {s28-s31}  \n\t" 
                          
                          // Third column times matrix.
                          "fmuls s24, s8, s0        \n\t"
                          "fmacs s24, s12, s1       \n\t"
                          
                          // Load fourth column to scalar bank.
                          "fldmias %1,  {s4-s7}    \n\t"
                          
                          "fmacs s24, s16, s2       \n\t"
                          "fmacs s24, s20, s3       \n\t"
                          // Save third column.
                          "fstmias  %0!, {s24-s27}  \n\t" 
                          
                          // Fourth column times matrix.
                          "fmuls s28, s8, s4        \n\t"
                          "fmacs s28, s12, s5       \n\t"
                          "fmacs s28, s16, s6       \n\t"
                          "fmacs s28, s20, s7       \n\t"
                          // Save fourth column.
                          "fstmias  %0!, {s28-s31}  \n\t" 
                          
                          VFP_VECTOR_LENGTH_ZERO
                          : "=r" (result), "=r" (m2)
                          : "r" (m1), "0" (result), "1" (m2)
                          : "r0", "cc", "memory", VFP_CLOBBER_S0_S31
                          );
#else
    result[0] = m1[0] * m2[0] + m1[4] * m2[1] + m1[8] * m2[2] + m1[12] * m2[3];
    result[1] = m1[1] * m2[0] + m1[5] * m2[1] + m1[9] * m2[2] + m1[13] * m2[3];
    result[2] = m1[2] * m2[0] + m1[6] * m2[1] + m1[10] * m2[2] + m1[14] * m2[3];
    result[3] = m1[3] * m2[0] + m1[7] * m2[1] + m1[11] * m2[2] + m1[15] * m2[3];
    
    result[4] = m1[0] * m2[4] + m1[4] * m2[5] + m1[8] * m2[6] + m1[12] * m2[7];
    result[5] = m1[1] * m2[4] + m1[5] * m2[5] + m1[9] * m2[6] + m1[13] * m2[7];
    result[6] = m1[2] * m2[4] + m1[6] * m2[5] + m1[10] * m2[6] + m1[14] * m2[7];
    result[7] = m1[3] * m2[4] + m1[7] * m2[5] + m1[11] * m2[6] + m1[15] * m2[7];
    
    result[8] = m1[0] * m2[8] + m1[4] * m2[9] + m1[8] * m2[10] + m1[12] * m2[11];
    result[9] = m1[1] * m2[8] + m1[5] * m2[9] + m1[9] * m2[10] + m1[13] * m2[11];
    result[10] = m1[2] * m2[8] + m1[6] * m2[9] + m1[10] * m2[10] + m1[14] * m2[11];
    result[11] = m1[3] * m2[8] + m1[7] * m2[9] + m1[11] * m2[10] + m1[15] * m2[11];
    
    result[12] = m1[0] * m2[12] + m1[4] * m2[13] + m1[8] * m2[14] + m1[12] * m2[15];
    result[13] = m1[1] * m2[12] + m1[5] * m2[13] + m1[9] * m2[14] + m1[13] * m2[15];
    result[14] = m1[2] * m2[12] + m1[6] * m2[13] + m1[10] * m2[14] + m1[14] * m2[15];
    result[15] = m1[3] * m2[12] + m1[7] * m2[13] + m1[11] * m2[14] + m1[15] * m2[15];
#endif
    
}
static inline void Matrix3DSetIdentity(Matrix3D matrix)
{
    matrix[0] = matrix[5] =  matrix[10] = matrix[15] = 1.0;
    matrix[1] = matrix[2] = matrix[3] = matrix[4] = 0.0;
    matrix[6] = matrix[7] = matrix[8] = matrix[9] = 0.0;    
    matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
}
static inline void Matrix3DSetTranslation(Matrix3D matrix, GLfloat xTranslate, GLfloat yTranslate, GLfloat zTranslate)
{
    matrix[0] = matrix[5] =  matrix[10] = matrix[15] = 1.0;
    matrix[1] = matrix[2] = matrix[3] = matrix[4] = 0.0;
    matrix[6] = matrix[7] = matrix[8] = matrix[9] = 0.0;    
    matrix[11] = 0.0;
    matrix[12] = xTranslate;
    matrix[13] = yTranslate;
    matrix[14] = zTranslate;   
}
static inline void Matrix3DSetScaling(Matrix3D matrix, GLfloat xScale, GLfloat yScale, GLfloat zScale)
{
    matrix[1] = matrix[2] = matrix[3] = matrix[4] = 0.0;
    matrix[6] = matrix[7] = matrix[8] = matrix[9] = 0.0;
    matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
    matrix[0] = xScale;
    matrix[5] = yScale;
    matrix[10] = zScale;
    matrix[15] = 1.0;
}
static inline void Matrix3DSetUniformScaling(Matrix3D matrix, GLfloat scale)
{
    Matrix3DSetScaling(matrix, scale, scale, scale);
}
static inline void Matrix3DSetXRotationUsingRadians(Matrix3D matrix, GLfloat degrees)
{
    matrix[0] = matrix[15] = 1.0;
    matrix[1] = matrix[2] = matrix[3] = matrix[4] = 0.0;
    matrix[7] = matrix[8] = 0.0;    
    matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
    
    matrix[5] = cosf(degrees);
    matrix[6] = -fastSinf(degrees);
    matrix[9] = -matrix[6];
    matrix[10] = matrix[5];
}
static inline void Matrix3DSetXRotationUsingDegrees(Matrix3D matrix, GLfloat degrees)
{
    Matrix3DSetXRotationUsingRadians(matrix, degrees * M_PI / 180.0);
}
static inline void Matrix3DSetYRotationUsingRadians(Matrix3D matrix, GLfloat degrees)
{
    matrix[0] = cosf(degrees);
    matrix[2] = fastSinf(degrees);
    matrix[8] = -matrix[2];
    matrix[10] = matrix[0];
    matrix[1] = matrix[3] = matrix[4] = matrix[6] = matrix[7] = 0.0;
    matrix[9] = matrix[11] = matrix[13] = matrix[12] = matrix[14] = 0.0;
    matrix[5] = matrix[15] = 1.0;
}
static inline void Matrix3DSetYRotationUsingDegrees(Matrix3D matrix, GLfloat degrees)
{
    Matrix3DSetYRotationUsingRadians(matrix, degrees * M_PI / 180.0);
}
static inline void Matrix3DSetZRotationUsingRadians(Matrix3D matrix, GLfloat degrees)
{
    matrix[0] = cosf(degrees);
    matrix[1] = fastSinf(degrees);
    matrix[4] = -matrix[1];
    matrix[5] = matrix[0];
    matrix[2] = matrix[3] = matrix[6] = matrix[7] = matrix[8] = 0.0;
    matrix[9] = matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
    matrix[10] = matrix[15] = 1.0;
}
static inline void Matrix3DSetZRotationUsingDegrees(Matrix3D matrix, GLfloat degrees)
{
    Matrix3DSetZRotationUsingRadians(matrix, degrees * M_PI / 180.0);
}
static inline void Matrix3DSetRotationByRadians(Matrix3D matrix, GLfloat angle, GLfloat x, GLfloat y, GLfloat z)
{
    GLfloat mag = sqrtf((x*x) + (y*y) + (z*z));
    if (mag == 0.0)
    {
        x = 1.0;
        y = 0.0;
        z = 0.0;
    }
    else if (mag != 1.0)
    {
        x /= mag;
        y /= mag;
        z /= mag;
    }
    
    GLfloat c = cosf(angle);
    GLfloat s = fastSinf(angle);
    matrix[3] = matrix[7] = matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
    matrix[15] = 1.0;
    
    
    matrix[0] = (x*x)*(1-c) + c;
    matrix[1] = (y*x)*(1-c) + (z*s);
    matrix[2] = (x*z)*(1-c) - (y*s);
    matrix[4] = (x*y)*(1-c)-(z*s);
    matrix[5] = (y*y)*(1-c)+c;
    matrix[6] = (y*z)*(1-c)+(x*s);
    matrix[8] = (x*z)*(1-c)+(y*s);
    matrix[9] = (y*z)*(1-c)-(x*s);
    matrix[10] = (z*z)*(1-c)+c;
    
}
static inline void Matrix3DSetRotationByDegrees(Matrix3D matrix, GLfloat angle, GLfloat x, GLfloat y, GLfloat z)
{
    Matrix3DSetRotationByRadians(matrix, angle * M_PI / 180.0, x, y, z);
}
static inline void Matrix3DSetShear(Matrix3D matrix, GLfloat xShear, GLfloat yShear)
{
    matrix[0] = matrix[5] =  matrix[10] = matrix[15] = 1.0;
    matrix[1] = matrix[2] = matrix[3] = 0.0;
    matrix[6] = matrix[7] = matrix[8] = matrix[9] = 0.0;    
    matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0.0;
    matrix[1] = xShear;
    matrix[4] = yShear;
}
#pragma mark -
#pragma mark VertexTextureCombinations
#pragma mark -
// This implements a binary search tree that will help us determine which vertices need to be duplicated. In
// OpenGL, each vertex has to have one and only one set of texture coordinates, so if a single vertex is shared
// by multiple triangles and has different texture coordinates in each, those vertices need to be duplicated
// so that there is one copy of that vertex for every distinct set of texture coordinates.

// This works with index values, not actual Vertex3D values, for speed, and because that's the way the 
// OBJ file format tells us about them
//
// An actualVertex value of UINT_MAX means that the actual integer value hasn't been determined yet. 
typedef struct {
	GLuint	originalVertex;
	GLuint	textureCoords;
	GLuint	actualVertex;
	void	*greater;
	void	*lesser;
	
} VertexTextureIndex;
static inline VertexTextureIndex * VertexTextureIndexMake (GLuint inVertex, GLuint inTextureCoords, GLuint inActualVertex)
{
	VertexTextureIndex *ret = malloc(sizeof(VertexTextureIndex));
	ret->originalVertex = inVertex;
	ret->textureCoords = inTextureCoords;
	ret->actualVertex = inActualVertex;
	ret->greater = NULL;
	ret->lesser = NULL;
	return ret;
}
#define VertexTextureIndexMakeEmpty(x,y) VertexTextureIndexMake(x, y, UINT_MAX)
// recursive search function - looks for a match for a given combination of vertex and 
// texture coordinates. If not found, returns UINT_MAX
static inline GLuint VertexTextureIndexMatch(VertexTextureIndex *node, GLuint matchVertex, GLuint matchTextureCoords)
{
	if (node->originalVertex == matchVertex && node->textureCoords == matchTextureCoords)
		return node->actualVertex;
	
	if (node->greater != NULL)
	{
		GLuint greaterIndex = VertexTextureIndexMatch(node->greater, matchVertex, matchTextureCoords);
		if (greaterIndex != UINT_MAX)
			return greaterIndex;
	}
	
	if (node->lesser != NULL)
	{
		GLuint lesserIndex = VertexTextureIndexMatch(node->lesser, matchVertex, matchTextureCoords);
		return lesserIndex;
	}
	return UINT_MAX;
}
static inline VertexTextureIndex * VertexTextureIndexAddNode(VertexTextureIndex *node, GLuint newVertex, GLuint newTextureCoords)
{
	// If requested new node matches the one being added to, then don't add, just return pointer to match
	if (node->originalVertex == newVertex && node->textureCoords == newTextureCoords)
		return node;
	if (node->originalVertex > newVertex || (node->originalVertex == newVertex && node->textureCoords > newTextureCoords))
	{
		if (node->lesser != NULL)
			return VertexTextureIndexAddNode(node->lesser, newVertex, newTextureCoords);
		else
		{
			VertexTextureIndex *newNode = VertexTextureIndexMakeEmpty(newVertex, newTextureCoords);
			node->lesser = newNode;
			return node->lesser;
		}
	}
	else
	{
		if (node->greater != NULL)
			return VertexTextureIndexAddNode(node->greater, newVertex, newTextureCoords);
		else
		{
			VertexTextureIndex *newNode = VertexTextureIndexMakeEmpty(newVertex, newTextureCoords);
			node->greater = newNode;
			return node->greater;
		}	
	}
	return NULL; // shouldn't ever reach here.
}
static inline BOOL VertexTextureIndexContainsVertexIndex(VertexTextureIndex *node, GLuint matchVertex)
{
	if (node->originalVertex == matchVertex)
		return YES;
	
	BOOL greaterHas = NO;
	BOOL lesserHas = NO;
	
	if (node->greater != NULL)
		greaterHas = VertexTextureIndexContainsVertexIndex(node->greater, matchVertex);
	if (node->lesser != NULL)
		lesserHas = VertexTextureIndexContainsVertexIndex(node->lesser, matchVertex);
	return lesserHas || greaterHas;
}
static inline void VertexTextureIndexFree(VertexTextureIndex *node)
{
	if (node != NULL)
	{
		if (node->greater != NULL)
			VertexTextureIndexFree(node->greater);
		if (node->lesser != NULL)
			VertexTextureIndexFree(node->lesser);
		free(node);
	}
	
}
static inline GLuint VertexTextureIndexCountNodes(VertexTextureIndex *node)
{
	GLuint ret = 0;  
	
	if (node)
	{
		ret++; // count this node
		
		// Add the children
		if (node->greater != NULL)
			ret += VertexTextureIndexCountNodes(node->greater);
		if (node->lesser != NULL)
			ret += VertexTextureIndexCountNodes(node->lesser);
	}
	return ret;
}
#pragma mark -
#pragma mark Missing GLUT Functionality
// This is a modified version of the function of the same name from 
// the Mesa3D project ( http://mesa3d.org/ ), which is  licensed
// under the MIT license, which allows use, modification, and 
// redistribution
static inline void gluLookAt(GLfloat eyex, GLfloat eyey, GLfloat eyez,
							 GLfloat centerx, GLfloat centery, GLfloat centerz,
							 GLfloat upx, GLfloat upy, GLfloat upz)
{
	GLfloat m[16];
	GLfloat x[3], y[3], z[3];
	GLfloat mag;
	
	/* Make rotation matrix */
	
	/* Z vector */
	z[0] = eyex - centerx;
	z[1] = eyey - centery;
	z[2] = eyez - centerz;
	mag = sqrtf(z[0] * z[0] + z[1] * z[1] + z[2] * z[2]);
	if (mag) {			/* mpichler, 19950515 */
		z[0] /= mag;
		z[1] /= mag;
		z[2] /= mag;
	}
	
	/* Y vector */
	y[0] = upx;
	y[1] = upy;
	y[2] = upz;
	
	/* X vector = Y cross Z */
	x[0] = y[1] * z[2] - y[2] * z[1];
	x[1] = -y[0] * z[2] + y[2] * z[0];
	x[2] = y[0] * z[1] - y[1] * z[0];
	
	/* Recompute Y = Z cross X */
	y[0] = z[1] * x[2] - z[2] * x[1];
	y[1] = -z[0] * x[2] + z[2] * x[0];
	y[2] = z[0] * x[1] - z[1] * x[0];
	
	/* mpichler, 19950515 */
	/* cross product gives area of parallelogram, which is < 1.0 for
	 * non-perpendicular unit-length vectors; so normalize x, y here
	 */
	
	mag = sqrtf(x[0] * x[0] + x[1] * x[1] + x[2] * x[2]);
	if (mag) {
		x[0] /= mag;
		x[1] /= mag;
		x[2] /= mag;
	}
	
	mag = sqrtf(y[0] * y[0] + y[1] * y[1] + y[2] * y[2]);
	if (mag) {
		y[0] /= mag;
		y[1] /= mag;
		y[2] /= mag;
	}
	
#define M(row,col)  m[col*4+row]
	M(0, 0) = x[0];
	M(0, 1) = x[1];
	M(0, 2) = x[2];
	M(0, 3) = 0.0;
	M(1, 0) = y[0];
	M(1, 1) = y[1];
	M(1, 2) = y[2];
	M(1, 3) = 0.0;
	M(2, 0) = z[0];
	M(2, 1) = z[1];
	M(2, 2) = z[2];
	M(2, 3) = 0.0;
	M(3, 0) = 0.0;
	M(3, 1) = 0.0;
	M(3, 2) = 0.0;
	M(3, 3) = 1.0;
#undef M
	glMultMatrixf(m);
	
	/* Translate Eye to Origin */
	glTranslatef(-eyex, -eyey, -eyez);
	
}
#pragma mark -
#pragma mark Misc
static inline void billboardCurrentMatrix(void)
{
	float modelview[16];
	glGetFloatv(GL_MODELVIEW_MATRIX , modelview);
	
	
	for(int i=0; i<3; i++ ) 
	{	
		for(int j=0; j<3; j++ ) 
		{
			if ( i==j ) modelview[i*4+j] = 1.0;
            else modelview[i*4+j] = 0.0;
        }
	}
	glLoadMatrixf(modelview);
}

*/
