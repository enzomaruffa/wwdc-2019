import Foundation
import PlaygroundSupport
import SpriteKit

var mainNode : SKShapeNode!
var ballNode : SKShapeNode!
var padsContainerNode : SKShapeNode!

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

var originalRightBorderPosition : CGPoint!
var originalLeftBorderPosition : CGPoint!

var spinCounter: Int!
var spinCounterNode : SKLabelNode!

var lastTouch : UITouch!

var movingLeft = false
var movingRight = false

var minPadsZRotation = CGFloat(degreeToRad(degree: ((180 - BORDER_SIZE - PAD_SIZE)/2) * -1 * 0.99));
var maxPadsZRotation = CGFloat(degreeToRad(degree: ((180 - BORDER_SIZE - PAD_SIZE)/2) * 0.99));

var currentBallSpeedFactor = CGFloat(1)

public var MAIN_NODE_ROTATION = MAIN_NODE_ROTATION_ORIGINAL

public class GameScene: SKScene, SKPhysicsContactDelegate {
    
    public override func didMove(to view: SKView) {
        // Get label node from scene and store it for use later
        
        leftButtonReleasedTex = SKTexture(imageNamed: "counterClockWiseReleased.png")
        rightButtonReleasedTex = SKTexture(imageNamed: "clockWiseReleased.png")
        leftButtonPressedTex = SKTexture(imageNamed: "counterClockWisePressed.png")
        rightButtonPressedTex = SKTexture(imageNamed: "clockWisePressed.png")
        
        physicsWorld.contactDelegate = self
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.speed = 1
        
        mainNode = SKShapeNode(circleOfRadius: CIRCLE_RADIUS+25)
        mainNode.position = CGPoint(x: 0, y: 0)
        mainNode.strokeColor = SKColor.clear
        self.addChild(mainNode)
        
        let blackSideNode = SKShapeNode(path: createBlackSidePath(center: CIRCLE_CENTER, radius: CIRCLE_RADIUS + 0))
        blackSideNode.fillColor = BLACK_SIDE_COLOR
        blackSideNode.strokeColor = BLACK_SIDE_COLOR
        mainNode.addChild(blackSideNode)
        
        //
        let rightPath = createSemicirclePath(width: ARC_WIDTH, startAngle: degreeToRad(degree: 0+BORDER_SIZE/2), endAngle: degreeToRad(degree: 0-BORDER_SIZE/2), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: true)
        
        rightArcNode = SKShapeNode(path: rightPath)
        rightArcNode.strokeColor = BORDER_COLOR
        rightArcNode.fillColor = BORDER_COLOR
        
        originalRightBorderPosition = rightArcNode.position
        
        let rightPathPhysicsBody = SKPhysicsBody(polygonFrom: rightPath)
        setDefaultPhysicalProperties(body: rightPathPhysicsBody, bitmask: BORDER_BITMASK)
        rightArcNode.physicsBody = rightPathPhysicsBody
        mainNode.addChild(rightArcNode)
        
        let leftPath = createSemicirclePath(width: ARC_WIDTH, startAngle: degreeToRad(degree: 180+BORDER_SIZE/2), endAngle: degreeToRad(degree: 180-BORDER_SIZE/2), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: true)
        
        leftArcNode = SKShapeNode(path: leftPath)
        leftArcNode.strokeColor = BORDER_COLOR
        leftArcNode.fillColor = BORDER_COLOR
        
        originalLeftBorderPosition = leftArcNode.position
        
        let leftPathPhysicsBody = SKPhysicsBody(polygonFrom: leftPath)
        setDefaultPhysicalProperties(body: leftPathPhysicsBody, bitmask: BORDER_BITMASK)
        leftArcNode.physicsBody = leftPathPhysicsBody
        mainNode.addChild(leftArcNode)
        
        //
        
        whiteBumperNode = createBumper(p: getCirclePointByAngle(radius: CIRCLE_RADIUS*0.5, center: CIRCLE_CENTER, angle: degreeToRad(degree: 0)), radius: BUMPER_RADIUS, fillColor: WHITE_SIDE_COLOR, strokeColor: WHITE_SIDE_COLOR)
        
        mainNode.addChild(whiteBumperNode)
        
        blackBumperNode = createBumper(p: getCirclePointByAngle(radius: CIRCLE_RADIUS*0.5, center: CIRCLE_CENTER, angle: 135), radius: BUMPER_RADIUS, fillColor: BLACK_SIDE_COLOR, strokeColor: BLACK_SIDE_COLOR)
        
        mainNode.addChild(blackBumperNode)
        
        //
        
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
        
        let whitePadBorder1Path = createSemicirclePath(width: PAD_WIDTH, startAngle: whitePadBorder1StartAngle, endAngle: whitePadBorder1EndAngle - degreeToRad(degree: 0.3), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: false)
        
        let whitePadBorder1Node = SKShapeNode(path: whitePadBorder1Path)
        whitePadBorder1Node.strokeColor = PAD_OUTSIDE_COLOR
        whitePadBorder1Node.fillColor = PAD_OUTSIDE_COLOR
        
        let whitePadBorder1PhysicsBody = SKPhysicsBody(polygonFrom: whitePadBorder1Path)
        setDefaultPhysicalProperties(body: whitePadBorder1PhysicsBody, bitmask: PAD_LEFT_DIRECTED_BITMASK)
        whitePadBorder1Node.physicsBody = whitePadBorder1PhysicsBody
        padsContainerNode.addChild(whitePadBorder1Node)
        
        let whitePadMiddlePath = createSemicirclePath(width: PAD_WIDTH, startAngle: whitePadBorder1EndAngle, endAngle: whitePadMiddleEndAngle, center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: false)
        
        let whitePadMiddleNode = SKShapeNode(path: whitePadMiddlePath)
        whitePadMiddleNode.strokeColor = PAD_INSIDE_COLOR
        whitePadMiddleNode.fillColor = PAD_INSIDE_COLOR
        
        let whitePadMiddlePhysicsBody = SKPhysicsBody(polygonFrom: whitePadMiddlePath)
        setDefaultPhysicalProperties(body: whitePadMiddlePhysicsBody, bitmask: PAD_RIGHT_DIRECTED_BITMASK)
        whitePadMiddleNode.physicsBody = whitePadMiddlePhysicsBody
        padsContainerNode.addChild(whitePadMiddleNode)
        
        let whitePadBorder2Path = createSemicirclePath(width: PAD_WIDTH, startAngle: whitePadMiddleEndAngle + degreeToRad(degree: 0.3), endAngle: whitePadBorder2EndAngle, center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: false)
        
        let whitePadBorder2Node = SKShapeNode(path: whitePadBorder2Path)
        whitePadBorder2Node.strokeColor = PAD_OUTSIDE_COLOR
        whitePadBorder2Node.fillColor = PAD_OUTSIDE_COLOR
        
        let whitePadBorder2PhysicsBody = SKPhysicsBody(polygonFrom: whitePadBorder2Path)
        setDefaultPhysicalProperties(body: whitePadBorder2PhysicsBody, bitmask: PAD_BITMASK)
        whitePadBorder2Node.physicsBody = whitePadBorder2PhysicsBody
        padsContainerNode.addChild(whitePadBorder2Node)
        
        //////////// black pad
        
        let blackPadBorder1StartAngle = degreeToRad(degree: 270-PAD_SIZE/2)
        let blackPadBorder1EndAngle = degreeToRad(degree: 270-(PAD_SIZE/2)*(PAD_CENTRAL_PROPORTION))
        let blackPadMiddleEndAngle = degreeToRad(degree: 270+(PAD_SIZE/2)*(PAD_CENTRAL_PROPORTION))
        let blackPadBorder2EndAngle = degreeToRad(degree: 270+PAD_SIZE/2)
        
        let blackPadBorder1Path = createSemicirclePath(width: PAD_WIDTH, startAngle: blackPadBorder1StartAngle, endAngle: blackPadBorder1EndAngle - degreeToRad(degree: 0.3), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: false)
        
        let blackPadBorder1Node = SKShapeNode(path: blackPadBorder1Path)
        blackPadBorder1Node.strokeColor = PAD_OUTSIDE_COLOR
        blackPadBorder1Node.fillColor = PAD_OUTSIDE_COLOR
        
        let blackPadBorder1PhysicsBody = SKPhysicsBody(polygonFrom: blackPadBorder1Path)
        setDefaultPhysicalProperties(body: blackPadBorder1PhysicsBody, bitmask: PAD_RIGHT_DIRECTED_BITMASK)
        blackPadBorder1Node.physicsBody = blackPadBorder1PhysicsBody
        padsContainerNode.addChild(blackPadBorder1Node)
        
        let blackPadMiddlePath = createSemicirclePath(width: PAD_WIDTH, startAngle: blackPadBorder1EndAngle, endAngle: blackPadMiddleEndAngle, center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: false)
        
        let blackPadMiddleNode = SKShapeNode(path: blackPadMiddlePath)
        blackPadMiddleNode.strokeColor = PAD_INSIDE_COLOR
        blackPadMiddleNode.fillColor = PAD_INSIDE_COLOR
        
        let blackPadMiddlePhysicsBody = SKPhysicsBody(polygonFrom: blackPadMiddlePath)
        setDefaultPhysicalProperties(body: blackPadMiddlePhysicsBody, bitmask: PAD_BITMASK)
        blackPadMiddleNode.physicsBody = blackPadMiddlePhysicsBody
        padsContainerNode.addChild(blackPadMiddleNode)
        
        let blackPadBorder2Path = createSemicirclePath(width: PAD_WIDTH, startAngle: blackPadMiddleEndAngle + degreeToRad(degree: 0.3), endAngle: blackPadBorder2EndAngle, center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: false)
        
        let blackPadBorder2Node = SKShapeNode(path: blackPadBorder2Path)
        blackPadBorder2Node.strokeColor = PAD_OUTSIDE_COLOR
        blackPadBorder2Node.fillColor = PAD_OUTSIDE_COLOR
        
        let blackPadBorder2PhysicsBody = SKPhysicsBody(polygonFrom: blackPadBorder2Path)
        setDefaultPhysicalProperties(body: blackPadBorder2PhysicsBody, bitmask: PAD_LEFT_DIRECTED_BITMASK)
        blackPadBorder2Node.physicsBody = blackPadBorder2PhysicsBody
        padsContainerNode.addChild(blackPadBorder2Node)
        
        //
        
        ballNode = createBall(p: CIRCLE_CENTER, radius: CIRCLE_RADIUS * BALL_PROPORTION, fillColor: WHITE_SIDE_COLOR, strokeColor: BLACK_SIDE_COLOR)
        self.addChild(ballNode)
        //
        
        
        let leftButtonPoint = getCirclePointByAngle(radius: CIRCLE_RADIUS*1.7, center: CIRCLE_CENTER, angle: degreeToRad(degree: 180))
        leftButtonNode = createButton(texture : leftButtonReleasedTex, position: CGPoint(x: leftButtonPoint.x, y: leftButtonPoint.y - SCREEN_HEIGHT/3.3), scale: 0.35)
        self.addChild(leftButtonNode)
    
        let rightButtonPoint = getCirclePointByAngle(radius: CIRCLE_RADIUS*1.7, center: CIRCLE_CENTER, angle: degreeToRad(degree: 0))
         rightButtonNode = createButton(texture : rightButtonReleasedTex, position: CGPoint(x: rightButtonPoint.x, y: rightButtonPoint.y - SCREEN_HEIGHT/3.3), scale: 0.35)
        self.addChild(rightButtonNode)
        
        spinCounter = -1
        
        spinCounterNode = SKLabelNode(text: String(spinCounter))
        spinCounterNode.position = CGPoint(x: SCREEN_WIDTH/2*(-1), y:SCREEN_HEIGHT/2.5)
        //spinCounterNode.position = CIRCLE_CENTER
        spinCounterNode.fontSize = CGFloat(80)
        spinCounterNode.fontColor = SKColor.black
        
        self.addChild(spinCounterNode)
        
        let spinsNode = SKLabelNode(text: "spins")
        spinsNode.position = CGPoint(x: SCREEN_WIDTH/2*(-1), y:SCREEN_HEIGHT/2.5 - 40)
        //spinsNode.position = CIRCLE_CENTER
        spinsNode.fontSize = CGFloat(40)
        spinsNode.fontColor = SKColor.black
        
        self.addChild(spinsNode)

        startGame(ballNode: ballNode as SKShapeNode!)
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
        var currentZRotation = mainNode.zRotation
        currentZRotation -= degreeToRad(degree: MAIN_NODE_ROTATION)
        if (currentZRotation <= 0) {
            currentZRotation = degreeToRad(degree: 360);
            spinCounter += 1
            spinCounterNode.text = String(spinCounter)
        }
        mainNode.zRotation = currentZRotation
        
        if movingLeft {
            if padsContainerNode.zRotation - degreeToRad(degree: PAD_STEP) > minPadsZRotation {
                padsContainerNode.zRotation -= degreeToRad(degree: PAD_STEP)
            }
        } else if movingRight {
            if padsContainerNode.zRotation + degreeToRad(degree: PAD_STEP) < maxPadsZRotation {
                padsContainerNode.zRotation += degreeToRad(degree: PAD_STEP)
            }
        }
        
        let speed = getBallSpeed(v: (ballNode.physicsBody?.velocity)!)
        
        if speed <= 10 && !mainNode.contains(ballNode.position) { // caso reset
            ballNode.run(SKAction.fadeIn(withDuration: 0.5))
            ballNode.physicsBody?.linearDamping = 0.0
            ballNode.position = CGPoint(x: 0, y: 0)
            rightArcNode.position = originalRightBorderPosition
            leftArcNode.position = originalLeftBorderPosition
            currentBallSpeedFactor = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                generateRandomBallMovement(ballNode: ballNode)
            })
        } else if speed > 105 && !mainNode.contains(ballNode.position) { // caso saia, desacelera
            MAIN_NODE_ROTATION = max(MAIN_NODE_ROTATION/2.5, MAIN_NODE_ROTATION_ORIGINAL)
            ballNode.physicsBody?.linearDamping = 0.96
            accelerateBall(ball: ballNode.physicsBody!, proportion : CGFloat(100/speed))
            ballNode.run(SKAction.fadeOut(withDuration: 1.2))
        }
        
        MAIN_NODE_ROTATION += MAIN_NODE_ROTATION_INCREMENT
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
        
        var currentBallVelocity = CGVector(dx: -1, dy: -1)
        var speed = CGFloat(-1)
        
        /*if (contact.bodyA.contactTestBitMask == BALL_BITMASK)
            ||  (contact.bodyB.contactTestBitMask == BALL_BITMASK) {
            var currentBallVelocity = ballNode.physicsBody!.velocity
            var speed = getBallSpeed(v: currentBallVelocity)
            print("previous speed: ", speed)
            print("previous ballVelocity: ", currentBallVelocity)
        }*/
        
        if (contact.bodyA.contactTestBitMask == BALL_BITMASK) &&
            (contact.bodyB.contactTestBitMask == PAD_LEFT_DIRECTED_BITMASK)
            ||  (contact.bodyB.contactTestBitMask == BALL_BITMASK) &&
            (contact.bodyA.contactTestBitMask == PAD_LEFT_DIRECTED_BITMASK) {
            
            let ball = contact.bodyB.contactTestBitMask == BALL_BITMASK ? contact.bodyB : contact.bodyA;
            let pad = contact.bodyB.contactTestBitMask == BALL_BITMASK ? contact.bodyA : contact.bodyB;
            
            let contactPoint = contact.contactPoint
            
            let target = CGPoint(x: whiteBumperNode.position.x - contactPoint.x,
                                 y: whiteBumperNode.position.y - contactPoint.y)
            
            print(" PAD HIT!")
            
            directBallTo(ball: ball, p: target)
            accelerateBall(ball: ball, proportion: (STARTING_BALL_SPEED * currentBallSpeedFactor / getBallSpeed(v: ball.velocity)))
            
     
            playSoundEffect(mainNode: self, fileName: "Teco.mp3", volume: 0.5)
            
        } else if (contact.bodyA.contactTestBitMask == BALL_BITMASK) &&
            (contact.bodyB.contactTestBitMask == PAD_RIGHT_DIRECTED_BITMASK)
            ||  (contact.bodyB.contactTestBitMask == BALL_BITMASK) &&
            (contact.bodyA.contactTestBitMask == PAD_RIGHT_DIRECTED_BITMASK) {
            
            let ball = contact.bodyB.contactTestBitMask == BALL_BITMASK ? contact.bodyB : contact.bodyA;
            let pad = contact.bodyB.contactTestBitMask == BALL_BITMASK ? contact.bodyA : contact.bodyB;
            
            let contactPoint = contact.contactPoint
            
            let target = CGPoint(x: blackBumperNode.position.x - contactPoint.x,
                                 y: blackBumperNode.position.y - contactPoint.y)
            
            directBallTo(ball: ball, p: target)
            accelerateBall(ball: ball, proportion: (STARTING_BALL_SPEED * currentBallSpeedFactor / getBallSpeed(v: ball.velocity)))
        
            playSoundEffect(mainNode: self, fileName: "Teco.mp3", volume: 0.5)
            
        } else if (contact.bodyA.contactTestBitMask == BALL_BITMASK) &&
            (contact.bodyB.contactTestBitMask == BUMPER_BITMASK)
            ||  (contact.bodyB.contactTestBitMask == BALL_BITMASK) &&
            (contact.bodyA.contactTestBitMask == BUMPER_BITMASK) {
            
            let ball = contact.bodyB.contactTestBitMask == BALL_BITMASK ? contact.bodyB : contact.bodyA;
            let bumper = contact.bodyB.contactTestBitMask == BALL_BITMASK ? contact.bodyA : contact.bodyB;
            
            print(" BUMPER HIT!")
            
            accelerateBall(ball: ball, proportion: CGFloat(BUMPER_SPEED_FACTOR))
            
            createBumperWave(bumper: bumper.node as! SKShapeNode)
            currentBallSpeedFactor *= BUMPER_SPEED_FACTOR
            
            accelerateBall(ball: ball, proportion: (STARTING_BALL_SPEED * currentBallSpeedFactor / getBallSpeed(v: ball.velocity)))
            
            if (bumper.node == whiteBumperNode) {
                playSoundEffect(mainNode: self, fileName: "TimpanoAgudo.mp3", volume: 1)
            } else {
                playSoundEffect(mainNode: self, fileName: "TimpanoGrave.mp3", volume: 1)
            }

            
        } else if (contact.bodyA.contactTestBitMask == BALL_BITMASK) &&
            (contact.bodyB.contactTestBitMask == BUMPER_BITMASK)
            ||  (contact.bodyB.contactTestBitMask == BALL_BITMASK) &&
            (contact.bodyA.contactTestBitMask == BUMPER_BITMASK) {
            
            let ball = contact.bodyB.contactTestBitMask == BALL_BITMASK ? contact.bodyB : contact.bodyA;
            let bumper = contact.bodyB.contactTestBitMask == BALL_BITMASK ? contact.bodyA : contact.bodyB;
            
            print(" WALL HIT!")
            accelerateBall(ball: ball, proportion: (STARTING_BALL_SPEED * currentBallSpeedFactor / getBallSpeed(v: ball.velocity)))
        }
        
        

        
        /*if (contact.bodyA.contactTestBitMask == BALL_BITMASK)
            ||  (contact.bodyB.contactTestBitMask == BALL_BITMASK) {
            currentBallVelocity = ballNode.physicsBody!.velocity
            speed = getBallSpeed(v: currentBallVelocity)
            print("new speed: ", speed)
            print("new ballVelocity: ", currentBallVelocity)
            print(" ")
        }*/
    }
}
