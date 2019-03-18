import PlaygroundSupport
import SpriteKit

let mainNode = SKNode()
var ballNode : SKShapeNode!
var padsContainerNode : SKShapeNode!
var leftButtonNode : SKShapeNode!
var rightButtonNode : SKShapeNode!

var movingLeft = false
var movingRight = false

var minPadsZRotation = CGFloat(degreeToRad(degree: -19.999));
var maxPadsZRotation = CGFloat(degreeToRad(degree: +19.999));

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        // Get label node from scene and store it for use later
        
        physicsWorld.contactDelegate = self
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.speed = 1
        
        mainNode.position = CGPoint(x: 0, y: 0)
        self.addChild(mainNode)
        
        let blackSideNode = SKShapeNode(path: createBlackSidePath(center: CIRCLE_CENTER, radius: CIRCLE_RADIUS + 0))
        blackSideNode.fillColor = BLACK_SIDE_COLOR
        blackSideNode.strokeColor = BLACK_SIDE_COLOR
        mainNode.addChild(blackSideNode)
        
        //
        let rightPath = createSemicirclePath(width: ARC_WIDTH, startAngle: degreeToRad(degree: 0+BORDER_SIZE/2), endAngle: degreeToRad(degree: 0-BORDER_SIZE/2), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: true)
        
        let rightArcNode = SKShapeNode(path: rightPath)
        rightArcNode.strokeColor = BORDER_COLOR
        rightArcNode.fillColor = BORDER_COLOR
        
        let rightPathPhysicsBody = SKPhysicsBody(polygonFrom: rightPath)
        setDefaultPhysicalProperties(body: rightPathPhysicsBody, bitmask: BORDER_BITMASK)
        rightArcNode.physicsBody = rightPathPhysicsBody
        mainNode.addChild(rightArcNode)
        
        
       let leftPath = createSemicirclePath(width: ARC_WIDTH, startAngle: degreeToRad(degree: 180+BORDER_SIZE/2), endAngle: degreeToRad(degree: 180-BORDER_SIZE/2), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: true)
        
        let leftArcNode = SKShapeNode(path: leftPath)
        leftArcNode.strokeColor = BORDER_COLOR
        leftArcNode.fillColor = BORDER_COLOR
        
        let leftPathPhysicsBody = SKPhysicsBody(polygonFrom: leftPath)
        setDefaultPhysicalProperties(body: leftPathPhysicsBody, bitmask: BORDER_BITMASK)
        leftArcNode.physicsBody = leftPathPhysicsBody
        mainNode.addChild(leftArcNode)
        
        //
        
        let whiteRound = createBall(p: getCirclePointByAngle(radius: CIRCLE_RADIUS*0.5, center: CIRCLE_CENTER, angle: degreeToRad(degree: 180)), radius: BUMPER_RADIUS)
        whiteRound.fillColor = WHITE_SIDE_COLOR
        whiteRound.strokeColor = WHITE_SIDE_COLOR
        
        let whiteRoundPhysicsBody = SKPhysicsBody(circleOfRadius: BUMPER_RADIUS)
        setDefaultPhysicalProperties(body: whiteRoundPhysicsBody, bitmask: BUMPER_BITMASK)
        whiteRound.physicsBody = whiteRoundPhysicsBody
        
        mainNode.addChild(whiteRound)
        
        let blackRound = createBall(p: getCirclePointByAngle(radius: CIRCLE_RADIUS*0.5, center: CIRCLE_CENTER, angle: 0), radius: BUMPER_RADIUS)
        blackRound.fillColor = BLACK_SIDE_COLOR
        blackRound.strokeColor = BLACK_SIDE_COLOR
        
        let blackRoundPhysicsBody = SKPhysicsBody(circleOfRadius: BUMPER_RADIUS)
        setDefaultPhysicalProperties(body: blackRoundPhysicsBody, bitmask: BUMPER_BITMASK)
        blackRound.physicsBody = blackRoundPhysicsBody
        
        mainNode.addChild(blackRound)
        
        //
        
        let origin = getCirclePointByAngle(radius: CIRCLE_RADIUS*1.2, center: CIRCLE_CENTER, angle: degreeToRad(degree: 270 - PAD_SIZE/2))
        let end = getCirclePointByAngle(radius: CIRCLE_RADIUS*1.2, center: CIRCLE_CENTER, angle: degreeToRad(degree: 90+PAD_SIZE/2))
        
        let size = CGSize(width: abs(origin.x - end.x), height: abs(origin.y - end.y))
        
        padsContainerNode = SKShapeNode(rect: CGRect(origin: origin, size: size))
        padsContainerNode.strokeColor = SKColor.clear
        mainNode.addChild(padsContainerNode)
        
        //////////// white pad
        
        let whitePadPath = createSemicirclePath(width: ARC_WIDTH, startAngle: degreeToRad(degree: 90-PAD_SIZE/2), endAngle: degreeToRad(degree: 90+PAD_SIZE/2), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: false)
        
        let whitePadNode = SKShapeNode(path: whitePadPath)
        whitePadNode.strokeColor = WHITE_SIDE_COLOR
        whitePadNode.fillColor = SKColor.red
        
        let whitePadPhysicsBody = SKPhysicsBody(polygonFrom: whitePadPath)
        setDefaultPhysicalProperties(body: whitePadPhysicsBody, bitmask: PAD_BITMASK)
        whitePadNode.physicsBody = whitePadPhysicsBody
        padsContainerNode.addChild(whitePadNode)
        
        //////////// black pad
        
        let blackPadPath = createSemicirclePath(width: ARC_WIDTH, startAngle: degreeToRad(degree: 270-PAD_SIZE/2), endAngle: degreeToRad(degree: 270+PAD_SIZE/2), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: false)
        
        let blackPadNode = SKShapeNode(path: blackPadPath)
        blackPadNode.strokeColor = BLACK_SIDE_COLOR
        blackPadNode.fillColor = SKColor.red
        
        let blackPadPhysicsBody = SKPhysicsBody(polygonFrom: blackPadPath)
        setDefaultPhysicalProperties(body: blackPadPhysicsBody, bitmask: PAD_BITMASK)
        blackPadNode.physicsBody = blackPadPhysicsBody
        padsContainerNode.addChild(blackPadNode)
        
        //
        
        ballNode = createBall(p: CIRCLE_CENTER, radius: CIRCLE_RADIUS*0.05)
        ballNode.fillColor = WHITE_SIDE_COLOR
        ballNode.strokeColor = BLACK_SIDE_COLOR
        self.addChild(ballNode)
        
        let ballNodePhysicsBody = SKPhysicsBody(circleOfRadius: CIRCLE_RADIUS*0.05)
        setDefaultPhysicalProperties(body: ballNodePhysicsBody, bitmask: 0x00000011)
        ballNodePhysicsBody.mass = 0.1
        ballNode.physicsBody = ballNodePhysicsBody
        
        let rand1 = Double.random(in: 1.0...4.0)
        ballNode.physicsBody?.applyForce(CGVector(dx: CGFloat(rand1 * 1000), dy: CGFloat(rand1 * 1000)))
        
        leftButtonNode = createBall(p: getCirclePointByAngle(radius: CIRCLE_RADIUS*1.5, center: CIRCLE_CENTER, angle: degreeToRad(degree: 180)), radius: 50)
        leftButtonNode.fillColor = SKColor.red
        self.addChild(leftButtonNode)
        
        rightButtonNode = createBall(p: getCirclePointByAngle(radius: CIRCLE_RADIUS*1.5, center: CIRCLE_CENTER, angle: degreeToRad(degree: 0)), radius: 50)
        rightButtonNode.fillColor = SKColor.blue
        self.addChild(rightButtonNode)
    }
    
    @objc static override var supportsSecureCoding: Bool {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        
        if padsContainerNode.contains(location) {
            //if isBallInside() {
                ballNode.position = CGPoint(x: 0, y: 0)
            //}
            generateRandomBallMovement(ballNode: ballNode)
        }
        
        if leftButtonNode.contains(location) {
            movingLeft = true
            movingRight = false
        } else if rightButtonNode.contains(location) {
            movingRight = true
            movingLeft = false
        }
        
        print(movingLeft)
        print(movingRight)
        
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: self)
        
        movingRight = false
        movingLeft = false
        
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        var currentZRotation = mainNode.zRotation
        currentZRotation -= degreeToRad(degree: MAIN_NODE_ROTATION)
        if (currentZRotation < 0) {
            currentZRotation = degreeToRad(degree: 360);
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
        
        if !mainNode.contains(ballNode.position) {
            //if isBallInside() {
            ballNode.position = CGPoint(x: 0, y: 0)
            //}
            generateRandomBallMovement(ballNode: ballNode)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let secondNode = contact.bodyB.node as! SKShapeNode
        
        if (contact.bodyA.contactTestBitMask == BALL_BITMASK) &&
            (contact.bodyB.contactTestBitMask == PAD_BITMASK)
            ||  (contact.bodyB.contactTestBitMask == BALL_BITMASK) &&
            (contact.bodyA.contactTestBitMask == PAD_BITMASK) {
            
            let ball = contact.bodyB.contactTestBitMask == BALL_BITMASK ? contact.bodyB : contact.bodyA;
            let pad = contact.bodyB.contactTestBitMask == BALL_BITMASK ? contact.bodyA : contact.bodyB;
            
            let contactPoint = contact.contactPoint
            let contactAngle = getAngleByCirclePoint(p: contactPoint)
            
            print(contactAngle)
            print(mainNode.zRotation)
            
            let transformatedAngle = contactAngle - degreeToRad(degree: 90)
            print(transformatedAngle)
            
            print(padsContainerNode.zRotation)
            
            let contact_y = contactPoint.y
            let target_y = secondNode.position.y
            let margin = secondNode.frame.size.height/2 - 25
            
            print("Hit")
        } else if (contact.bodyA.contactTestBitMask == BALL_BITMASK) &&
            (contact.bodyB.contactTestBitMask == BUMPER_BITMASK)
            ||  (contact.bodyB.contactTestBitMask == BALL_BITMASK) &&
            (contact.bodyA.contactTestBitMask == BUMPER_BITMASK) {
            
            let ball = contact.bodyB.contactTestBitMask == BALL_BITMASK ? contact.bodyB : contact.bodyA;
            let bumper = contact.bodyB.contactTestBitMask == BALL_BITMASK ? contact.bodyA : contact.bodyB;
            
            accelerateBall(ball: ball)
            createBumperWave(bumper: bumper.node as! SKShapeNode)
        }
    }
}

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.backgroundColor = SKColor.init(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
    scene.scaleMode = .aspectFill
    
    
    // Present the scene
    sceneView.presentScene(scene)
    //sceneView.showsPhysics = true
    sceneView.showsFPS = true
    //sceneView.showsFields = true
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView


