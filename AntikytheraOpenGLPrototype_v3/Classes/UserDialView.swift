//
//  UserDialView.m
//  AntikytheraOpenGLPrototype
//
//  Created by Matt Ricketson on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


class UserDialView: NSObject, ModelView, Touchable {
    var position: Vertex3D
    var rotation: Double
    var radius: Double
    var color: Color3D
    
    var myView: UIView!
    var myMechanism: AntikytheraMechanism!
    
    // Touch-handling:
    var lastPosition: Vector3D
    
    let boxModel: BoxModel

    init(radius rad: Float, mechanism: AntikytheraMechanism, view: UIView) {
		position = Vertex3DMake(0.0, 0.0, 0.0)
        lastPosition = position
        rotation = 0
		radius = Double(rad)
		color = Color3DMake(1.0, 1.0, 1.0, 1.0)
		
		myView = view
		myMechanism = mechanism
		
		boxModel = BoxModel(width:Float(rad*0.1), height:Float(rad*0.75), length:0.5)
}

    func setOpacity(opac: Float) { color.alpha = opac }

    func hitTest(hit: Vector3D) -> Bool {
        let outerRadius = radius*1.75
        let innerRadius = radius*0.75
        let distance = hypot(Double(hit.x-position.x), Double(hit.y-position.y))
        
        if ((distance <= outerRadius)&&(distance >= innerRadius)) {
            return true
        } else {
            return false
        }
    }

    func draw() {
        let sides = 32
        
        let angleInc = 360.0/Double(sides)
        
        glPushMatrix()
        
        glTranslatef(position.x, position.y, position.z)
        glRotatef(GLfloat(rotation), 0.0, 0.0, 1.0)
        
        for var i=0; i<sides; i++ {
            let angle = Double(i)*angleInc
            
            glPushMatrix()
            glTranslatef(GLfloat(radius*cos(DegreesToRadians(angle))), GLfloat(radius*sin(DegreesToRadians(angle))), 0.0)
            glRotatef(GLfloat(angle), 0.0, 0.0, 1.0)
            glColor4f(color.red, color.green, color.blue, color.alpha)
            boxModel.draw()
            glPopMatrix()
        }
        
        glPopMatrix()
    }

    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let allTouches = event?.touchesForView(myView)
        let touch = allTouches?.first
        let location = touch?.locationInView(myView)
        lastPosition = Vertex3DMake(location!.x, myView.bounds.size.height-location!.y, 0.0)
    }
    
    func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let allTouches = event?.touchesForView(myView)
        let touch = allTouches?.first
        let location = touch?.locationInView(myView)
        let newPosition = Vertex3DMake(location!.x, myView.bounds.size.height-location!.y, 0.0)
        
        var norm1 = Vector3DMakeWithStartAndEndPoints(position,lastPosition)
        var norm2 = Vector3DMakeWithStartAndEndPoints(position,newPosition)
        
        Vector3DNormalize(&norm1)
        Vector3DNormalize(&norm2)
        
        var angle: Double = Double(atan2f(norm2.y,norm2.x) - atan2f(norm1.y,norm1.x))
        
        if (fabs(angle) >= M_PI) {
            if (angle > 0) {
                angle -= 2.0*M_PI
            } else {
                angle += 2.0*M_PI
            }
        }
        
        angle = RadiansToDegrees(angle)
        if (angle != 0.0) {
            rotation += angle
            NSLog("%f",angle)
            myMechanism.rotate(Float(angle))
            
            lastPosition = newPosition
        }
    }
    
    func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    
    func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }

}
