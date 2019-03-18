import Foundation
import PlaygroundSupport
import SpriteKit

public func degreeToRad(degree: CGFloat) -> CGFloat {
    return 0.01745329252 * degree
}

//Padrão: ponto mais próximo do centro horiozontal e topo primeiro.
public func createSemicirclePath(width: CGFloat, startAngle: CGFloat, endAngle: CGFloat, center: CGPoint, radius: CGFloat, clockwise: Bool) -> CGMutablePath { //CGPath {
    
    let p0 = getCirclePointByAngle(radius: CIRCLE_RADIUS, center: CIRCLE_CENTER, angle: startAngle)
    
    let path = CGMutablePath()
    path.move(to: p0)
    path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
    
    path.addArc(center: center, radius: radius + width, startAngle: endAngle, endAngle: startAngle, clockwise: !clockwise)
    
    path.closeSubpath()
    
    return path;
}

public func createBlackSidePath(center: CGPoint, radius: CGFloat) -> CGPath {
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

public func getCirclePointByAngle(radius: CGFloat, center: CGPoint, angle: CGFloat) -> CGPoint {
    return CGPoint(x: center.x + radius * cos(angle),
                   y: center.y + radius * sin(angle))
}

public func getAngleByCirclePoint(p: CGPoint) -> CGFloat  {
    let angle = atan2(p.y - CIRCLE_CENTER.y, p.x - CIRCLE_CENTER.x)
    return angle < 0 ? CGFloat(Double.pi) + abs(angle) : angle
}

public func createBall(p: CGPoint, radius: CGFloat) -> SKShapeNode {
    let ballNode = SKShapeNode(circleOfRadius: radius)
    ballNode.position = p
    return ballNode
}

public func accelerateBall(ball: SKPhysicsBody) {
    let velocity = ball.velocity
    let newVelocity = CGVector(dx: velocity.dx * BUMPER_SPEED_FACTOR, dy: velocity.dy * BUMPER_SPEED_FACTOR)
    ball.velocity = newVelocity
}

public func createBumperWave(bumper: SKShapeNode) {
    //let waveCenter = CGPoint(x:0,y:0)
    //let wavePosition = getCirclePointByAngle(radius: BUMPER_RADIUS, center: waveCenter, angle: 0)
    
    /*let path = CGMutablePath()
     path.move(to: wavePosition)
     path.addArc(center: waveCenter, radius: BUMPER_RADIUS, startAngle: 0, endAngle: degreeToRad(degree: 360), clockwise: true)
     path.closeSubpath()*/
    let waveNode = SKShapeNode(circleOfRadius: BUMPER_RADIUS)
    waveNode.fillColor = bumper.fillColor
    waveNode.strokeColor = bumper.fillColor
    
    let fade = SKAction.fadeOut(withDuration: WAVE_DURATION)
    let scale = SKAction.scale(to: 1.5, duration: WAVE_DURATION)
    
    fade.timingMode = .easeOut
    scale.timingMode = .easeOut
    
    bumper.addChild(waveNode)
    waveNode.run(fade)
    waveNode.run(scale)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + WAVE_DURATION, execute: {
        waveNode.removeFromParent()
    })
    
}

public func setDefaultPhysicalProperties(body: SKPhysicsBody, bitmask: UInt32) {
    body.contactTestBitMask = bitmask
    body.pinned = false
    body.allowsRotation = false
    body.friction = 0
    body.restitution = 1.0
    body.linearDamping = 0
    body.mass = 10000
}

public func generateRandomBallMovement(ballNode : SKShapeNode) {
    let rand1 = Int.random(in:-1...1)
    let rand2 = Int.random(in:-1...1)
    ballNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    ballNode.physicsBody?.applyForce(CGVector(dx: CGFloat(rand1 * 600), dy: CGFloat(rand2 * 600)))
}
