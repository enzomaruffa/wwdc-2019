 import SpriteKit
 import PlaygroundSupport
 
 let CIRCLE_RADIUS = CGFloat(100)
 let CIRCLE_CENTER = CGPoint(x: 150, y: 150)
 let SCREEN_WIDTH = CGFloat(640)
 let SCREEN_HEIGHT = CGFloat(480)
 
 //Padrão: ponto mais próximo do centro horiozontal e topo primeiro.
 func createSemicirclePath(width: CGFloat, startAngle: CGFloat, endAngle: CGFloat, center: CGPoint, radius: CGFloat, clockwise: Bool) -> CGMutablePath { //CGPath {
    
    let path = CGMutablePath()
    
    let p0 = getCirclePointByAngle(radius: CIRCLE_RADIUS, center: CIRCLE_CENTER, angle: startAngle)
        
    path.move(to: p0)
    path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
    
    path.addArc(center: center, radius: radius + width, startAngle: endAngle, endAngle: startAngle, clockwise: !clockwise)
    
    path.closeSubpath()
    
    return path;
 }
 
 func getCirclePointByAngle(radius: CGFloat, center: CGPoint, angle: CGFloat) -> CGPoint {
    return CGPoint(x: center.x + radius * cos(angle),
                   y: center.y + radius * sin(angle))
 }
 
 let view = SKView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
 PlaygroundPage.current.liveView = view
 PlaygroundPage.current.needsIndefiniteExecution = true
 
 let scene = SKScene(size: CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
 scene.backgroundColor = SKColor.init(red:0.85, green:0.85, blue:0.85, alpha:1.0)
 view.presentScene(scene)

 let mainNode = SKNode()
 mainNode.position = CGPoint(x: 0, y: 0)
 scene.addChild(mainNode)
 
 let circleCenter = SKShapeNode(circleOfRadius: 3)
 circleCenter.fillColor = SKColor.red
 circleCenter.position = CIRCLE_CENTER
 mainNode.addChild(circleCenter)

 
 let leftPath = createSemicirclePath(width: 3, startAngle: 3.75246, endAngle: 2.35619, center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: true)
 
 let rightPath = createSemicirclePath(width: 3, startAngle: 5.49779, endAngle: 0.785398, center: CIRCLE_CENTER, radius: CIRCLE_RADIUS, clockwise: false)
 
 let rightArcNode = SKShapeNode(path: rightPath)
 rightArcNode.fillColor = SKColor.black
 mainNode.addChild(rightArcNode)
 
 let leftArcNode = SKShapeNode(path: leftPath)
 leftArcNode.fillColor = SKColor.black
 mainNode.addChild(leftArcNode)
 
 

 
//createMainNode
//createYinYang
//createBall
