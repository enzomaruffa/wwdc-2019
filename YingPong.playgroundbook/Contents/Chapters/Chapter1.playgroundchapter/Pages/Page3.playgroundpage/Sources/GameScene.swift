import Foundation
import PlaygroundSupport
import SpriteKit

var mainNode : SKShapeNode!
var ballNode : SKShapeNode!
var padsContainerNode : SKShapeNode!

var whiteBumperNode : SKShapeNode!
var blackBumperNode : SKShapeNode!
var leftArcNode : SKShapeNode!
var rightArcNode : SKShapeNode!

var originalRightBorderPosition : CGPoint!
var originalLeftBorderPosition : CGPoint!

var currentBallSpeedFactor = CGFloat(1)

var motion = false
var life = false

public var MAIN_NODE_ROTATION = MAIN_NODE_ROTATION_ORIGINAL

public class GameScene: SKScene, SKPhysicsContactDelegate {

    public func addMotion() {
        motion = true
    }

    public func addLife() {
        life = true
    }
    
    public override func didMove(to view: SKView) {
        // Get label node from scene and store it for use later
        
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

        var border = life ? BORDER_SIZE : 180

        let rightPath = createSemicirclePath(width: ARC_WIDTH, startAngle: degreeToRad(degree: 0+border/2), endAngle: degreeToRad(degree: 0-border/2), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: true)
        
        rightArcNode = SKShapeNode(path: rightPath)
        rightArcNode.strokeColor = BORDER_COLOR
        rightArcNode.fillColor = BORDER_COLOR
        
        originalRightBorderPosition = rightArcNode.position
        
        let rightPathPhysicsBody = SKPhysicsBody(polygonFrom: rightPath)
        setDefaultPhysicalProperties(body: rightPathPhysicsBody, bitmask: BORDER_BITMASK)
        rightArcNode.physicsBody = rightPathPhysicsBody
        mainNode.addChild(rightArcNode)
        
        let leftPath = createSemicirclePath(width: ARC_WIDTH, startAngle: degreeToRad(degree: 180+border/2), endAngle: degreeToRad(degree: 180-border/2), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: true)
        
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
        //
        
        ballNode = createBall(p: CIRCLE_CENTER, radius: CIRCLE_RADIUS * BALL_PROPORTION, fillColor: WHITE_SIDE_COLOR, strokeColor: BLACK_SIDE_COLOR)
        self.addChild(ballNode)
        //
        
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
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { touchMoved(toPoint: t.location(in: self)) }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    public override func update(_ currentTime: TimeInterval) {
        if motion {
            var currentZRotation = mainNode.zRotation
            currentZRotation -= degreeToRad(degree: MAIN_NODE_ROTATION)
            if (currentZRotation <= 0) {
                currentZRotation = degreeToRad(degree: 360);
            }
            mainNode.zRotation = currentZRotation
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
    }
}
