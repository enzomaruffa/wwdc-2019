import Foundation
import PlaygroundSupport
import SpriteKit

var mainNode : SKShapeNode!
var padsContainerNode : SKShapeNode!

var leftButtonNode : SKSpriteNode!
var rightButtonNode : SKSpriteNode!

var leftButtonReleasedTex : SKTexture!
var rightButtonReleasedTex : SKTexture!
var leftButtonPressedTex : SKTexture!
var rightButtonPressedTex : SKTexture!

var arcNode : SKShapeNode!

var lastTouch : UITouch!

var movingLeft = false
var movingRight = false

var hasCompletedCircle = false

public class GameScene: SKScene, SKPhysicsContactDelegate {
    
    public override func didMove(to view: SKView) {
        // Get label node from scene and store it for use later
        
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
        arcNode = SKShapeNode(circleOfRadius: 0)
        mainNode.addChild(arcNode)
        
        let origin = getCirclePointByAngle(radius: CIRCLE_RADIUS*1.2, center: CIRCLE_CENTER, angle: degreeToRad(degree: 270 - PAD_SIZE/2))
        let end = getCirclePointByAngle(radius: CIRCLE_RADIUS*1.2, center: CIRCLE_CENTER, angle: degreeToRad(degree: 90 - PAD_SIZE/2))
        
        let size = CGSize(width: abs(origin.x - end.x), height: abs(origin.y - end.y))
        
        padsContainerNode = SKShapeNode(rect: CGRect(origin: origin, size: size))
        padsContainerNode.strokeColor = SKColor.clear
        mainNode.addChild(padsContainerNode)
        
        //////////// white pad
        
        let whitePadBorder1StartAngle = degreeToRad(degree: 90-PAD_SIZE/2)
        let whitePadBorder1EndAngle = degreeToRad(degree: 90-(PAD_SIZE/2)*(PAD_CENTRAL_PROPORTION))
        let whitePadMiddleEndAngle = degreeToRad(degree: 90+(PAD_SIZE/2)*(PAD_CENTRAL_PROPORTION))
        let whitePadBorder2EndAngle = degreeToRad(degree: 90+PAD_SIZE/2)

        let whitePadMiddlePath = createSemicirclePath(width: PAD_WIDTH, startAngle: whitePadBorder1EndAngle, endAngle: whitePadMiddleEndAngle, center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: false)
        
        let whitePadMiddleNode = SKShapeNode(path: whitePadMiddlePath)
        whitePadMiddleNode.strokeColor = PAD_INSIDE_COLOR
        whitePadMiddleNode.fillColor = PAD_INSIDE_COLOR
        padsContainerNode.addChild(whitePadMiddleNode)
        //////////// black pad
        
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
            padsContainerNode.zRotation -= degreeToRad(degree: PAD_STEP)
        } else if movingRight {
            padsContainerNode.zRotation += degreeToRad(degree: PAD_STEP)
        }
        
        if !hasCompletedCircle {
            var path : CGMutablePath!
            if padsContainerNode.zRotation > 0 {
                print("Clockwise:", padsContainerNode.zRotation)
                path = createSemicirclePath(width: ARC_WIDTH, startAngle: degreeToRad(degree: 90), endAngle: degreeToRad(degree: 90) + padsContainerNode.zRotation, center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: false)
            } else {
                print("counterClockwise:", padsContainerNode.zRotation)
                path = createSemicirclePath(width: ARC_WIDTH, startAngle: degreeToRad(degree: 90), endAngle: padsContainerNode.zRotation + degreeToRad(degree: 90), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: true)
            }
            
            arcNode.removeFromParent()
            
            arcNode = SKShapeNode(path: path)
            arcNode.strokeColor = BORDER_COLOR
            arcNode.fillColor = BORDER_COLOR
            
            arcNode.zPosition = -1
            
            mainNode.addChild(arcNode)
            
            if padsContainerNode.zRotation <= degreeToRad(degree: 360) * -1 || padsContainerNode.zRotation >= degreeToRad(degree: 360)  {
                hasCompletedCircle = true
                //TODO: adicionar pagina completa
            }
            
        }
       
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
     
        
    }
}
