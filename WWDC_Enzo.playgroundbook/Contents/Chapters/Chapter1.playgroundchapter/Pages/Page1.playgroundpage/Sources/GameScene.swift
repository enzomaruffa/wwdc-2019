import Foundation
import PlaygroundSupport
import SpriteKit

var mainNode : SKShapeNode!

var borderNode : SKShapeNode!

public class GameScene: SKScene {
    
    public override func didMove(to view: SKView) {
        
        mainNode = SKShapeNode(circleOfRadius: CIRCLE_RADIUS+25)
        mainNode.position = CGPoint(x: 0, y: 0)
        mainNode.strokeColor = SKColor.clear
        self.addChild(mainNode)
        //
        let borderPath = createSemicirclePath(width: ARC_WIDTH, startAngle: degreeToRad(degree: 0), endAngle: degreeToRad(degree: 360), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: true)
        
        borderNode = SKShapeNode(path: borderPath)
        borderNode.strokeColor = BORDER_COLOR
        borderNode.fillColor = BORDER_COLOR
        
        originalBorderPosition = borderNode.position
        mainNode.addChild(borderNode)
        
        
       
    }
    
    @objc public static override var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*let touch = Array(touches)[touches.count-1]
        let location = touch.location(in: self)
        
        if leftButtonNode.contains(location) {
            leftButtonNode.texture = leftButtonPressedTex
            movingLeft = false
            movingRight = true
        } else if rightButtonNode.contains(location) {
            rightButtonNode.texture = rightButtonPressedTex
            movingRight = false
            movingLeft = true
        }
        //print(movingLeft)
        //print(movingRight)
        
        lastTouch = touch*/
        
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { touchMoved(toPoint: t.location(in: self)) }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*let touch = touches.first!
        let location = touch.location(in: self)
        
        if leftButtonNode.contains(location) {
            leftButtonNode.texture = leftButtonReleasedTex
        } else if rightButtonNode.contains(location) {
            rightButtonNode.texture = rightButtonReleasedTex
        }
        
        if touch.location(in: self) == lastTouch.location(in: self) {
            movingRight = false
            movingLeft = false
        }*/
        
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    public override func update(_ currentTime: TimeInterval) {
        
    }
}
