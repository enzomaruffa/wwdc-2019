import Foundation
import SpriteKit
import PlaygroundSupport

var mainNode : SKShapeNode!
var blackSideNode: SKShapeNode!
var leftPadContainerNode : SKShapeNode!
var rightPadContainerNode : SKShapeNode!

var leftButtonNode : SKSpriteNode!
var rightButtonNode : SKSpriteNode!

var leftButtonReleasedTex : SKTexture!
var rightButtonReleasedTex : SKTexture!
var leftButtonPressedTex : SKTexture!
var rightButtonPressedTex : SKTexture!

var whiteBumperNode : SKShapeNode!
var blackBumperNode : SKShapeNode!

var leftArcNode : SKShapeNode!
var rightArcNode : SKShapeNode!

var lastTouch : UITouch!

var movingLeft = false
var movingRight = false

var hasCompletedBlackPart = false

let instantFadeOut = SKAction.fadeOut(withDuration: 0.0)

public class GameScene: SKScene, SKPhysicsContactDelegate {
    
    public override func didMove(to view: SKView) {
        // Get label node from scene and store it for use later
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        leftButtonReleasedTex = SKTexture(imageNamed: "counterClockWiseReleased.png")
        rightButtonReleasedTex = SKTexture(imageNamed: "clockWiseReleased.png")
        leftButtonPressedTex = SKTexture(imageNamed: "counterClockWisePressed.png")
        rightButtonPressedTex = SKTexture(imageNamed: "clockWisePressed.png")
        
        mainNode = SKShapeNode(circleOfRadius: CIRCLE_RADIUS+25)
        mainNode.position = CGPoint(x: 0, y: 0)
        mainNode.strokeColor = SKColor.clear
        
        mainNode.zPosition = -2
        self.addChild(mainNode)
        
        // map stuff
        
        var fullArcNode = SKShapeNode(circleOfRadius: 0)
        let fullArcPath = createSemicirclePath(width: ARC_WIDTH, startAngle: degreeToRad(degree: 0), endAngle: degreeToRad(degree: 360), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: true)
        
        fullArcNode = SKShapeNode(path: fullArcPath)
        fullArcNode.strokeColor = BORDER_COLOR
        fullArcNode.fillColor = BORDER_COLOR
        
        mainNode.addChild(fullArcNode)
        
        blackSideNode = SKShapeNode(path: createBlackSidePath(center: CIRCLE_CENTER, radius: CIRCLE_RADIUS + 0))
        blackSideNode.fillColor = BLACK_SIDE_COLOR
        blackSideNode.strokeColor = BLACK_SIDE_COLOR
        blackSideNode.run(instantFadeOut)
        mainNode.addChild(blackSideNode)
        
        /////////
        
        leftArcNode = SKShapeNode(circleOfRadius: 0)
        let leftArcPath = createSemicirclePath(width: ARC_WIDTH, startAngle: degreeToRad(degree: 0), endAngle: degreeToRad(degree: 360), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: true)
        
        leftArcNode = SKShapeNode(path: leftArcPath)
        leftArcNode.strokeColor = BORDER_COLOR
        leftArcNode.fillColor = BORDER_COLOR
        
        mainNode.addChild(leftArcNode)
        
        rightArcNode = SKShapeNode(circleOfRadius: 0)
        let rightArcPath = createSemicirclePath(width: ARC_WIDTH, startAngle: degreeToRad(degree: 0), endAngle: degreeToRad(degree: 360), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: true)
        
        rightArcNode = SKShapeNode(path: rightArcPath)
        rightArcNode.strokeColor = BORDER_COLOR
        rightArcNode.fillColor = BORDER_COLOR
        
        mainNode.addChild(rightArcNode)
        
        //
        
        let whiteBumperPosition = getCirclePointByAngle(radius: CIRCLE_RADIUS*0.5, center: CIRCLE_CENTER, angle: degreeToRad(degree: 0))
        print(whiteBumperPosition)
        whiteBumperNode = createBumper(p: whiteBumperPosition, radius: BUMPER_RADIUS, fillColor: WHITE_SIDE_COLOR, strokeColor: BLACK_SIDE_COLOR)
        whiteBumperNode.run(instantFadeOut)
        mainNode.addChild(whiteBumperNode)
        
        let tempNodeWhite = SKShapeNode(circleOfRadius: 0)
        tempNodeWhite.position = whiteBumperPosition
        mainNode.addChild(tempNodeWhite)
        
        let blackBumperPosition = getCirclePointByAngle(radius: CIRCLE_RADIUS*0.5, center: CIRCLE_CENTER, angle: degreeToRad(degree: 180))
        print(blackBumperPosition)
        blackBumperNode = createBumper(p: blackBumperPosition, radius: BUMPER_RADIUS, fillColor: BLACK_SIDE_COLOR, strokeColor: BLACK_SIDE_COLOR)
        blackBumperNode.run(instantFadeOut)
        mainNode.addChild(blackBumperNode)
        
        let tempNodeBlack = SKShapeNode(circleOfRadius: 0)
        tempNodeBlack.position = blackBumperPosition
        mainNode.addChild(tempNodeBlack)
        
        //////////// left pad container node
        
        let originLeft = getCirclePointByAngle(radius: CIRCLE_RADIUS/2, center: CGPoint(x: 0, y: -27), angle: degreeToRad(degree: 180 - PAD_SIZE/4))
        let endLeft = getCirclePointByAngle(radius:CIRCLE_RADIUS/2, center: CGPoint(x: 0, y: -27), angle: degreeToRad(degree: 0 - PAD_SIZE/4))
        
        let sizeLeft = CGSize(width: abs(originLeft.x - endLeft.x), height: abs(originLeft.y - endLeft.y))
        
        leftPadContainerNode = SKShapeNode(rect: CGRect(origin: originLeft, size: sizeLeft))
        leftPadContainerNode.strokeColor = SKColor.clear
        tempNodeWhite.addChild(leftPadContainerNode)
        
        //////////// right pad container node
        
        let originRight = getCirclePointByAngle(radius: CIRCLE_RADIUS/2, center: CGPoint(x: 0, y: -27), angle: degreeToRad(degree: 180 - PAD_SIZE/4))
        let endRight = getCirclePointByAngle(radius:CIRCLE_RADIUS/2, center: CGPoint(x: 0, y: -27), angle: degreeToRad(degree: 0 - PAD_SIZE/4))
        
        let sizeRight = CGSize(width: abs(originRight.x - endRight.x), height: abs(originRight.y - endRight.y))
        
        rightPadContainerNode = SKShapeNode(rect: CGRect(origin: originRight, size: sizeRight))
        rightPadContainerNode.strokeColor = SKColor.clear
        tempNodeBlack.addChild(rightPadContainerNode)
        
        //////////// left pad
        
        let leftPadStartAngle = degreeToRad(degree: 0 + (PAD_SIZE/2)*(PAD_CENTRAL_PROPORTION))
        let leftPadEndAngle = degreeToRad(degree: 0 - (PAD_SIZE/2)*(PAD_CENTRAL_PROPORTION))
        
        let leftPadMiddlePath = createSemicirclePath(width: PAD_WIDTH, startAngle: leftPadStartAngle, endAngle: leftPadEndAngle, center: CIRCLE_CENTER, radius: CIRCLE_RADIUS/2, clockwise: true)
        
        let leftPadMiddleNode = SKShapeNode(path: leftPadMiddlePath)
        leftPadMiddleNode.strokeColor = PAD_INSIDE_COLOR
        leftPadMiddleNode.fillColor = PAD_INSIDE_COLOR
        
        leftPadContainerNode.addChild(leftPadMiddleNode)
        
        
        //////////// right pad
        
        let rightPadStartAngle = degreeToRad(degree: 180 - (PAD_SIZE/2)*(PAD_CENTRAL_PROPORTION))
        let rightPadEndAngle = degreeToRad(degree: 180 + (PAD_SIZE/2)*(PAD_CENTRAL_PROPORTION))
        
        let rightPadMiddlePath = createSemicirclePath(width: PAD_WIDTH, startAngle: rightPadStartAngle, endAngle: rightPadEndAngle, center: CIRCLE_CENTER, radius: CIRCLE_RADIUS/2, clockwise: false)
        
        let rightPadMiddleNode = SKShapeNode(path: rightPadMiddlePath)
        rightPadMiddleNode.strokeColor = PAD_INSIDE_COLOR
        rightPadMiddleNode.fillColor = PAD_INSIDE_COLOR
        
        rightPadContainerNode.addChild(rightPadMiddleNode)
        
        /////////// buttons
        
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
        
        if movingLeft && leftPadContainerNode.zRotation > degreeToRad(degree: -180)  {
            leftPadContainerNode.zRotation -= degreeToRad(degree: PAD_STEP)
            rightPadContainerNode.zRotation -= degreeToRad(degree: PAD_STEP)
        } else if movingRight && leftPadContainerNode.zRotation < degreeToRad(degree: 0) {
            leftPadContainerNode.zRotation += degreeToRad(degree: PAD_STEP)
            rightPadContainerNode.zRotation += degreeToRad(degree: PAD_STEP)
        }
        
        if !hasCompletedBlackPart {
            if leftPadContainerNode.zRotation < 0 {
                let leftArcPath = createSemicirclePath(width: 1, startAngle: degreeToRad(degree: 0), endAngle: leftPadContainerNode.zRotation, center: whiteBumperNode.position, radius: CIRCLE_RADIUS/2, clockwise: true)
                
                leftArcNode.removeFromParent()
                
                leftArcNode = SKShapeNode(path: leftArcPath)
                leftArcNode.strokeColor = BORDER_COLOR
                leftArcNode.fillColor = BORDER_COLOR
                
                leftArcNode.zPosition = -1
                
                mainNode.addChild(leftArcNode)
                
                let rightArcPath = createSemicirclePath(width: 1, startAngle: degreeToRad(degree: 180), endAngle: degreeToRad(degree: 180) + rightPadContainerNode.zRotation, center: blackBumperNode.position, radius: CIRCLE_RADIUS/2, clockwise: true)
                
                rightArcNode.removeFromParent()
                
                rightArcNode = SKShapeNode(path: rightArcPath)
                rightArcNode.strokeColor = BORDER_COLOR
                rightArcNode.fillColor = BORDER_COLOR
                
                rightArcNode.zPosition = -1
                
                mainNode.addChild(rightArcNode)
            }


            if leftPadContainerNode.zRotation <= degreeToRad(degree: -180)  {
                hasCompletedBlackPart = true
                PlaygroundPage.current.assessmentStatus = .pass(message: "This is the Yin Yang. Wondering how it will turn into YingPong... [Next page!](@next)")
                self.showObjects()
            }
         
         }
        
    }
    
    public func showObjects() {
        let fadeInAction = SKAction.fadeIn(withDuration: 3.5)
        
        whiteBumperNode.run(fadeInAction)
        blackBumperNode.run(fadeInAction)
        blackSideNode.run(fadeInAction)
        
        rightArcNode.run(SKAction.fadeOut(withDuration: 2.5))
        leftArcNode.run(SKAction.fadeOut(withDuration: 2.5))
    }
}
