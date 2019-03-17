import PlaygroundSupport
import SpriteKit

let CIRCLE_RADIUS = CGFloat(275)
let CIRCLE_CENTER = CGPoint(x: 0, y: 0)
let SCREEN_WIDTH = CGFloat(800)
let SCREEN_HEIGHT = CGFloat(600)
let ARC_WIDTH = CGFloat(6)

let ICE_WHITE = SKColor.init(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)

let mainNode = SKNode()
var ballNode : SKShapeNode!
var padsContainerNode : SKShapeNode!
var leftButtonNode : SKShapeNode!
var rightButtonNode : SKShapeNode!
var currentZRotation = CGFloat(0.0);

let PAD_STEP = CGFloat(1.4)

let BALL_BITMASK : UInt32 = 0x00000011
let BORDER_BITMASK : UInt32 = 0x00000001
let BUMPER_BITMASK : UInt32 = 0x00000010

var movingLeft = false
var movingRight = false

func degreeToRad(degree: CGFloat) -> CGFloat {
    return 0.01745329252 * degree
}

var minPadsZRotation = CGFloat(degreeToRad(degree: -19.8));
var maxPadsZRotation = CGFloat(degreeToRad(degree: +19.8));

//Padrão: ponto mais próximo do centro horiozontal e topo primeiro.
func createSemicirclePath(width: CGFloat, startAngle: CGFloat, endAngle: CGFloat, center: CGPoint, radius: CGFloat, clockwise: Bool) -> CGMutablePath { //CGPath {
    
    let p0 = getCirclePointByAngle(radius: CIRCLE_RADIUS, center: CIRCLE_CENTER, angle: startAngle)
    
    let path = CGMutablePath()
    path.move(to: p0)
    path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
    
    path.addArc(center: center, radius: radius + width, startAngle: endAngle, endAngle: startAngle, clockwise: !clockwise)
    
    path.closeSubpath()
    
    return path;
}

func createBlackSidePath(center: CGPoint, radius: CGFloat) -> CGPath {
    let p0 = getCirclePointByAngle(radius: radius, center: center, angle: 0)
    
    let path = CGMutablePath()
    path.move(to: p0)
    path.addArc(center: center, radius: radius, startAngle: degreeToRad(degree: 0), endAngle: degreeToRad(degree: 180), clockwise: false)
    
    let rightMiddlePoint = CGPoint(x: p0.x * -0.5, y: p0.y)
    path.addArc(center: rightMiddlePoint, radius: radius/2, startAngle: degreeToRad(degree: 180), endAngle: degreeToRad(degree: 0), clockwise: false)
    
    let leftMiddlePoint = CGPoint(x: p0.x / 2, y: p0.y)
    path.addArc(center: leftMiddlePoint, radius: radius/2, startAngle: degreeToRad(degree: 180), endAngle: degreeToRad(degree: 0), clockwise: true)
    
    path.closeSubpath()
    
    return path
}

func getCirclePointByAngle(radius: CGFloat, center: CGPoint, angle: CGFloat) -> CGPoint {
    return CGPoint(x: center.x + radius * cos(angle),
                   y: center.y + radius * sin(angle))
}

func createBall(p: CGPoint, radius: CGFloat) -> SKShapeNode {
    let ballNode = SKShapeNode(circleOfRadius: radius)
    ballNode.position = p
    return ballNode
}

func setDefaultPhysicalProperties(body: SKPhysicsBody, bitmask: UInt32) {
    body.contactTestBitMask = bitmask
    body.pinned = false
    body.allowsRotation = false
    body.friction = 0
    body.restitution = 1.0
    body.linearDamping = 0
    body.mass = 10000
}

func generateRandomBallMovement() {
    let rand1 = Int.random(in:-1...1)
    let rand2 = Int.random(in:-1...1    )
    ballNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    ballNode.physicsBody?.applyForce(CGVector(dx: CGFloat(rand1 * 600), dy: CGFloat(rand2 * 600)))
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        // Get label node from scene and store it for use later
        
        physicsWorld.contactDelegate = self
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.speed = 1
        
        mainNode.position = CGPoint(x: 0, y: 0)
        self.addChild(mainNode)
        
        let circleCenter = SKShapeNode(circleOfRadius: 3)
        circleCenter.fillColor = SKColor.red
        circleCenter.position = CIRCLE_CENTER
        mainNode.addChild(circleCenter)
        
        let blackSideNode = SKShapeNode(path: createBlackSidePath(center: CIRCLE_CENTER, radius: CIRCLE_RADIUS + 0))
        blackSideNode.fillColor = SKColor.black
        blackSideNode.strokeColor = SKColor.black
        mainNode.addChild(blackSideNode)
        
        //
        let rightPath = createSemicirclePath(width: ARC_WIDTH, startAngle: degreeToRad(degree: 60), endAngle: degreeToRad(degree: 300), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: true)
        
        let rightArcNode = SKShapeNode(path: rightPath)
        rightArcNode.strokeColor = ICE_WHITE
        rightArcNode.fillColor = SKColor.gray
        
        let rightPathPhysicsBody = SKPhysicsBody(polygonFrom: rightPath)
        setDefaultPhysicalProperties(body: rightPathPhysicsBody, bitmask: BORDER_BITMASK)
        rightArcNode.physicsBody = rightPathPhysicsBody
        mainNode.addChild(rightArcNode)
        
        
       let leftPath = createSemicirclePath(width: ARC_WIDTH, startAngle: degreeToRad(degree: 240), endAngle: degreeToRad(degree: 120), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: true)
        
        let leftArcNode = SKShapeNode(path: leftPath)
        leftArcNode.strokeColor = ICE_WHITE
        leftArcNode.fillColor = SKColor.gray
        
        let leftPathPhysicsBody = SKPhysicsBody(polygonFrom: leftPath)
        setDefaultPhysicalProperties(body: leftPathPhysicsBody, bitmask: BORDER_BITMASK)
        leftArcNode.physicsBody = leftPathPhysicsBody
        mainNode.addChild(leftArcNode)
        
        //
        
        let whiteRound = createBall(p: getCirclePointByAngle(radius: CIRCLE_RADIUS*0.66, center: CIRCLE_CENTER, angle: degreeToRad(degree: 180)), radius: CIRCLE_RADIUS*0.15)
        whiteRound.fillColor = SKColor.init(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        whiteRound.strokeColor = SKColor.black
        
        let whiteRoundPhysicsBody = SKPhysicsBody(circleOfRadius: CIRCLE_RADIUS*0.15)
        setDefaultPhysicalProperties(body: whiteRoundPhysicsBody, bitmask: BUMPER_BITMASK)
        whiteRound.physicsBody = whiteRoundPhysicsBody
        
        mainNode.addChild(whiteRound)
        
        let blackRound = createBall(p: getCirclePointByAngle(radius: CIRCLE_RADIUS*0.66, center: CIRCLE_CENTER, angle: 0), radius: CIRCLE_RADIUS*0.15)
        blackRound.fillColor = SKColor.black
        blackRound.strokeColor = SKColor.black
        
        let blackRoundPhysicsBody = SKPhysicsBody(circleOfRadius: CIRCLE_RADIUS*0.15)
        setDefaultPhysicalProperties(body: blackRoundPhysicsBody, bitmask: BUMPER_BITMASK)
        blackRound.physicsBody = blackRoundPhysicsBody
        
        mainNode.addChild(blackRound)
        
        //
        
        let origin = getCirclePointByAngle(radius: CIRCLE_RADIUS*1.2, center: CIRCLE_CENTER, angle: degreeToRad(degree: 260))
        let end = getCirclePointByAngle(radius: CIRCLE_RADIUS*1.2, center: CIRCLE_CENTER, angle: degreeToRad(degree: 80))
        
        let size = CGSize(width: abs(origin.x - end.x), height: abs(origin.y - end.y))
        
        padsContainerNode = SKShapeNode(rect: CGRect(origin: origin, size: size))
        padsContainerNode.strokeColor = SKColor.clear
        mainNode.addChild(padsContainerNode)
        
        let whitePadPath = createSemicirclePath(width: ARC_WIDTH, startAngle: degreeToRad(degree: 80), endAngle: degreeToRad(degree: 100), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: false)
        
        let whitePadNode = SKShapeNode(path: whitePadPath)
        whitePadNode.strokeColor = ICE_WHITE
        whitePadNode.fillColor = SKColor.red
        
        let whitePadPhysicsBody = SKPhysicsBody(polygonFrom: whitePadPath)
        setDefaultPhysicalProperties(body: whitePadPhysicsBody, bitmask: BORDER_BITMASK)
        whitePadNode.physicsBody = whitePadPhysicsBody
        padsContainerNode.addChild(whitePadNode)
        
        let blackPadPath = createSemicirclePath(width: ARC_WIDTH, startAngle: degreeToRad(degree: 260), endAngle: degreeToRad(degree: 280), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: false)
        
        let blackPadNode = SKShapeNode(path: blackPadPath)
        blackPadNode.strokeColor = ICE_WHITE
        blackPadNode.fillColor = SKColor.red
        
        let blackPadPhysicsBody = SKPhysicsBody(polygonFrom: blackPadPath)
        setDefaultPhysicalProperties(body: blackPadPhysicsBody, bitmask: BORDER_BITMASK)
        blackPadNode.physicsBody = blackPadPhysicsBody
        padsContainerNode.addChild(blackPadNode)
        
        //
        
        ballNode = createBall(p: CIRCLE_CENTER, radius: CIRCLE_RADIUS*0.05)
        ballNode.fillColor = ICE_WHITE
        ballNode.strokeColor = SKColor.black
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
            generateRandomBallMovement()
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
        mainNode.zRotation = currentZRotation
        currentZRotation -= degreeToRad(degree: 3/60)
        if (currentZRotation > degreeToRad(degree: 360)) {
            currentZRotation = 0;
        }
        
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
            generateRandomBallMovement()
        }
    }
    
    /*func didBegin(_ contact: SKPhysicsContact) {
        let secondNode = contact.bodyB.node as! SKShapeNode
        
        print(contact.bodyA)
        print(contact.bodyB)
        
        if (contact.bodyA.categoryBitMask == BALL_BITMASK) &&
            (contact.bodyB.categoryBitMask == BORDER_BITMASK) {
            
            let contactPoint = contact.contactPoint
            let contact_y = contactPoint.y
            let target_y = secondNode.position.y
            let margin = secondNode.frame.size.height/2 - 25
            
            print("Hit")
        }
    }*/
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


