
//createMainNode
//createYinYang
//createBall
import PlaygroundSupport
import SpriteKit
 
let CIRCLE_RADIUS = CGFloat(300)
let CIRCLE_CENTER = CGPoint(x: 0, y: 0)
let SCREEN_WIDTH = CGFloat(800)
let SCREEN_HEIGHT = CGFloat(600)

let ICE_WHITE = SKColor.init(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)

let mainNode = SKNode()
var currentZRotation = CGFloat(0.0);

func degreeToRad(degree: CGFloat) -> CGFloat {
    return 0.01745329252 * degree
}

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

func createBlackSidePath(center: CGPoint, radius: CGFloat) ->CGPath {
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
 
 class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        // Get label node from scene and store it for use later
        mainNode.position = CGPoint(x: 0, y: 0)
        self.addChild(mainNode)
        
        let circleCenter = SKShapeNode(circleOfRadius: 3)
        circleCenter.fillColor = SKColor.red
        circleCenter.position = CIRCLE_CENTER
        mainNode.addChild(circleCenter)
        
        //let leftPath = createSemicirclePath(width: 3, startAngle: 3.75246, endAngle: 2.35619, center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: true)
        let leftPath = createSemicirclePath(width: 4, startAngle: degreeToRad(degree: 260), endAngle: degreeToRad(degree: 100), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: true)
        
        //let rightPath = createSemicirclePath(width: 3, startAngle: 5.49779, endAngle: 0.785398, center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: false)
        let rightPath = createSemicirclePath(width: 4, startAngle: degreeToRad(degree: 280), endAngle: degreeToRad(degree: 80), center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: false)
        
        let blackSideNode = SKShapeNode(path: createBlackSidePath(center: CIRCLE_CENTER, radius: CIRCLE_RADIUS + 0))
        blackSideNode.fillColor = SKColor.black
        blackSideNode.strokeColor = SKColor.black
        mainNode.addChild(blackSideNode)
        
        let rightArcNode = SKShapeNode(path: rightPath)
        rightArcNode.fillColor = SKColor.black
        rightArcNode.strokeColor = SKColor.black
        mainNode.addChild(rightArcNode)
        
        let leftArcNode = SKShapeNode(path: leftPath)
        leftArcNode.fillColor = SKColor.black
        leftArcNode.strokeColor = SKColor.black
        mainNode.addChild(leftArcNode)
        
        let ballNode = createBall(p: CIRCLE_CENTER, radius: 8)
        ballNode.fillColor = SKColor.init(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        ballNode.strokeColor = SKColor.black
        mainNode.addChild(ballNode)
        
        let whiteRound = createBall(p: getCirclePointByAngle(radius: CIRCLE_RADIUS*0.66, center: CIRCLE_CENTER, angle: 3.1415), radius: 40)
        whiteRound.fillColor = SKColor.init(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        whiteRound.strokeColor = SKColor.black
        mainNode.addChild(whiteRound)
        
        let blackRound = createBall(p: getCirclePointByAngle(radius: CIRCLE_RADIUS*0.66, center: CIRCLE_CENTER, angle: 0), radius: 40)
        blackRound.fillColor = SKColor.black
        blackRound.strokeColor = SKColor.black
        mainNode.addChild(blackRound)
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
        
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        mainNode.zRotation = currentZRotation
        currentZRotation -= degreeToRad(degree: 5/60)
        if (currentZRotation > degreeToRad(degree: 360)) {
            currentZRotation = 0;
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
 }
 
 PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
