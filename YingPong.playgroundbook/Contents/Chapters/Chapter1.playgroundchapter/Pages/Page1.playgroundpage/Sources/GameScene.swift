import Foundation
import PlaygroundSupport
import SpriteKit

// Page elements
var mainNode : SKShapeNode!
var padContainerNode : SKShapeNode!

var leftButtonNode : SKSpriteNode!
var rightButtonNode : SKSpriteNode!

var leftButtonReleasedTex : SKTexture!
var rightButtonReleasedTex : SKTexture!
var leftButtonPressedTex : SKTexture!
var rightButtonPressedTex : SKTexture!

var arcNode : SKShapeNode!

// Last touch object, so we can properly use multitouch
var lastTouch : UITouch!

var movingLeft = false
var movingRight = false

var hasCompletedCircle = false

public class GameScene: SKScene, SKPhysicsContactDelegate {
    
    public override func didMove(to view: SKView) {
        
        leftButtonReleasedTex = SKTexture(imageNamed: "counterClockWiseReleased.png")
        rightButtonReleasedTex = SKTexture(imageNamed: "clockWiseReleased.png")
        leftButtonPressedTex = SKTexture(imageNamed: "counterClockWisePressed.png")
        rightButtonPressedTex = SKTexture(imageNamed: "clockWisePressed.png")
        
        mainNode = SKShapeNode(circleOfRadius: CIRCLE_RADIUS+25)
        mainNode.position = CGPoint(x: 0, y: 0)
        mainNode.strokeColor = SKColor.clear
        
        mainNode.zPosition = -2
        self.addChild(mainNode)
        
        //
        // Placeholder for the final arc node
        arcNode = SKShapeNode(circleOfRadius: 0)
        mainNode.addChild(arcNode)


        // Creation of the pad container node
        
        let origin = getCirclePointByAngle(radius: CIRCLE_RADIUS*1.2, center: CIRCLE_CENTER, angle: degreeToRad(degree: 270 - PAD_SIZE/2))
        let end = getCirclePointByAngle(radius: CIRCLE_RADIUS*1.2, center: CIRCLE_CENTER, angle: degreeToRad(degree: 90 - PAD_SIZE/2))
        
        let size = CGSize(width: abs(origin.x - end.x), height: abs(origin.y - end.y))
        
        padContainerNode = SKShapeNode(rect: CGRect(origin: origin, size: size))
        padContainerNode.strokeColor = SKColor.clear
        mainNode.addChild(padContainerNode)
        
        // Creating of the pad node
        
        let padStartAngle = degreeToRad(degree: 90-(PAD_SIZE/2)*(PAD_CENTRAL_PROPORTION))
        let padEndAngle = degreeToRad(degree: 90+(PAD_SIZE/2)*(PAD_CENTRAL_PROPORTION))

        let padMiddlePath = createSemicirclePath(width: PAD_WIDTH, startAngle: padStartAngle, endAngle: padEndAngle, center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: false)
        
        let padMiddleNode = SKShapeNode(path: padMiddlePath)
        padMiddleNode.strokeColor = PAD_INSIDE_COLOR
        padMiddleNode.fillColor = PAD_INSIDE_COLOR
        
        padContainerNode.addChild(padMiddleNode)
        
        // Buttons are created relative to the circle center, which sits in the middle of the screen
        
        let leftButtonPoint = getCirclePointByAngle(radius: CIRCLE_RADIUS*1.7, center: CIRCLE_CENTER, angle: degreeToRad(degree: 180))
        leftButtonNode = createButton(texture : leftButtonReleasedTex, position: CGPoint(x: leftButtonPoint.x, y: leftButtonPoint.y - SCREEN_HEIGHT/3.3), scale: 0.35)
        self.addChild(leftButtonNode)
    
        let rightButtonPoint = getCirclePointByAngle(radius: CIRCLE_RADIUS*1.7, center: CIRCLE_CENTER, angle: degreeToRad(degree: 0))
         rightButtonNode = createButton(texture : rightButtonReleasedTex, position: CGPoint(x: rightButtonPoint.x, y: rightButtonPoint.y - SCREEN_HEIGHT/3.3), scale: 0.35)
        self.addChild(rightButtonNode)
    
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
        let touch = Array(touches)[touches.count-1]
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
        
        lastTouch = touch
        
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { touchMoved(toPoint: t.location(in: self)) }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        
        if leftButtonNode.contains(location) {
            leftButtonNode.texture = leftButtonReleasedTex
        } else if rightButtonNode.contains(location) {
            rightButtonNode.texture = rightButtonReleasedTex
        }
        
        if touch.location(in: self) == lastTouch.location(in: self) {
            movingRight = false
            movingLeft = false
        }
        
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    public override func update(_ currentTime: TimeInterval) {
       
        if movingLeft {
            padContainerNode.zRotation -= degreeToRad(degree: PAD_STEP)
        } else if movingRight {
            padContainerNode.zRotation += degreeToRad(degree: PAD_STEP)
        }
        
        if !hasCompletedCircle {
            var path : CGMutablePath!
            if padContainerNode.zRotation > 0 {
                print("Clockwise:", padContainerNode.zRotation)
                path = createSemicirclePath(width: ARC_WIDTH, startAngle: degreeToRad(degree: 90), endAngle: degreeToRad(degree: 90) + padContainerNode.zRotation, center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: false)
            } else {
                print("counterClockwise:", padContainerNode.zRotation)
                path = createSemicirclePath(width: ARC_WIDTH, startAngle: degreeToRad(degree: 90), endAngle: padContainerNode.zRotation + degreeToRad(degree: 90), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: true)
            }
            
            arcNode.removeFromParent()
            
            arcNode = SKShapeNode(path: path)
            arcNode.strokeColor = BORDER_COLOR
            arcNode.fillColor = BORDER_COLOR
            
            arcNode.zPosition = -1
            
            mainNode.addChild(arcNode)
            
            if padContainerNode.zRotation <= degreeToRad(degree: 360) * -1 || padContainerNode.zRotation >= degreeToRad(degree: 360)  {
                hasCompletedCircle = true
                PlaygroundPage.current.assessmentStatus = .pass(message: "Great! Let's move on :) [Next page!](@next)")
            }
            
        }
       
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
     
        
    }
}
