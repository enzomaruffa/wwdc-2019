import Foundation
import PlaygroundSupport
import SpriteKit

public var currentBallSpeed = CGFloat(0)

// Convert degree to radians
public func degreeToRad(degree: CGFloat) -> CGFloat {
    return 0.01745329252 * degree
}

// Convert radian to degrees
public func radToDegree(rad: CGFloat) -> CGFloat {
    return rad / 0.01745329252
}

//Creates an arc path with a desired width
public func createSemicirclePath(width: CGFloat, startAngle: CGFloat, endAngle: CGFloat, center: CGPoint, radius: CGFloat, clockwise: Bool) -> CGMutablePath { //CGPath {
    
    let p0 = getCirclePointByAngle(radius: radius, center: center, angle: startAngle)
    
    let path = CGMutablePath()
    path.move(to: p0)
    path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
    
    path.addArc(center: center, radius: radius + width, startAngle: endAngle, endAngle: startAngle, clockwise: !clockwise)
    
    path.closeSubpath()
    
    return path;
}

// Creates the yin yang black side
public func createBlackSidePath(center: CGPoint, radius: CGFloat) -> CGPath {
    let p0 = getCirclePointByAngle(radius: radius, center: center, angle: 0)
    
    let path = CGMutablePath()
    path.move(to: p0)
    path.addArc(center: center, radius: radius, startAngle: degreeToRad(degree: 0), endAngle: degreeToRad(degree: 180), clockwise: false)
    
    let rightMiddlePoint = CGPoint(x: p0.x * -0.5, y: p0.y)
    path.addArc(center: rightMiddlePoint, radius: radius/2, startAngle: degreeToRad(degree: 180), endAngle: degreeToRad(degree: 0), clockwise: true)
    
    let leftMiddlePoint = CGPoint(x: p0.x / 2, y: p0.y)
    path.addArc(center: leftMiddlePoint, radius: radius/2, startAngle: degreeToRad(degree: 180), endAngle: degreeToRad(degree: 0), clockwise: false)
    
    path.closeSubpath()
    
    return path
}

// Creates a button
public func createButton(texture: SKTexture, position: CGPoint, scale: CGFloat) -> SKSpriteNode {
    let buttonNode = SKSpriteNode(texture: texture)
    buttonNode.setScale(scale)
    buttonNode.position = position
    return buttonNode
}

// Based on a circle radius and center, finds out which point sits on it's edge on a specific angle
public func getCirclePointByAngle(radius: CGFloat, center: CGPoint, angle: CGFloat) -> CGPoint {
    return CGPoint(x: center.x + radius * cos(angle),
                   y: center.y + radius * sin(angle))
}

// Find the angle that a point p is from a circle specified in Constants.swift
public func getAngleByCirclePoint(p: CGPoint) -> CGFloat  {
    let angle = atan2(p.y - CIRCLE_CENTER.y, p.x - CIRCLE_CENTER.x)
    return angle < 0 ? CGFloat(Double.pi) + abs(angle) : angle
}

// Creates a bumper for the ball
public func createBumper(p: CGPoint, radius: CGFloat, fillColor: SKColor, strokeColor: SKColor) -> SKShapeNode {
    let bumperNode = SKShapeNode(circleOfRadius: radius)
    bumperNode.position = p
    
    bumperNode.fillColor = fillColor
    bumperNode.strokeColor = strokeColor
    
    let bumperNodePhysicsBody = SKPhysicsBody(circleOfRadius: radius)
    setDefaultPhysicalProperties(body: bumperNodePhysicsBody, bitmask: BUMPER_BITMASK)
    bumperNode.physicsBody = bumperNodePhysicsBody
    
    return bumperNode
}

// Creates a ball
public func createBall(p: CGPoint, radius: CGFloat, fillColor: SKColor, strokeColor: SKColor) -> SKShapeNode {
    let ballNode = SKShapeNode(circleOfRadius: radius)
    ballNode.position = p
    
    ballNode.fillColor = fillColor
    ballNode.strokeColor = strokeColor
    
    let ballNodePhysicsBody = SKPhysicsBody(circleOfRadius: radius)
    setDefaultPhysicalProperties(body: ballNodePhysicsBody, bitmask: BALL_BITMASK)
    ballNodePhysicsBody.restitution = 0.3
    ballNodePhysicsBody.mass = 1.0
    ballNode.physicsBody = ballNodePhysicsBody
    
    return ballNode
}

// Accelerates a physical body based on a specific proportion
public func accelerateBall(ball: SKPhysicsBody, proportion: CGFloat) {
    let velocity = ball.velocity
    let newVelocity = CGVector(dx: velocity.dx * proportion, dy: velocity.dy * proportion)
    ball.velocity = newVelocity
}

// Creates a wave around a bumper
public func createBumperWave(bumper: SKShapeNode) {
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

// Sets the default physical properties for all physical bodies
public func setDefaultPhysicalProperties(body: SKPhysicsBody, bitmask: UInt32) {
    body.contactTestBitMask = bitmask
    body.pinned = false
    body.allowsRotation = false
    body.friction = 0
    body.restitution = 1.0
    body.linearDamping = 0
    body.mass = 10000
}

// Based on the specifications on Constans.swift, applies a random movement to a ShapeNode that has a physical body
public func generateRandomBallMovement(ballNode : SKShapeNode) {
    ballNode.physicsBody?.velocity = CGVector(dx:STARTING_BALL_SPEED, dy:0)
    let randomDirection = Double.random(in: 0...360)
    let p = getCirclePointByAngle(radius: CIRCLE_RADIUS, center: CIRCLE_CENTER, angle: degreeToRad(degree: CGFloat(randomDirection)))
    
    //print("Generated point: ", p)
    
    directBallTo(ball: ballNode.physicsBody!, p: p)
}

// Directs a ball to a specific point, keeping it's velocity
public func directBallTo(ball : SKPhysicsBody, p : CGPoint) {
    var speed = getBallSpeed(v: ball.velocity)
    //print("speed: ", speed)
    speed = max(1, speed)
    let nv = normalizeVector(v: CGVector(dx: p.x, dy: p.y))
    //print("nv: ", nv)
    let speedFactor = speed/(abs(nv.dx)+abs(nv.dy))
    //print("speedFactor: ", speedFactor)
    let v = CGVector(dx: nv.dx*speedFactor, dy: nv.dy*speedFactor)
    //print("v: ", v)
    ball.velocity = CGVector(dx:0, dy:0)
    ball.velocity = v
}

// Normalizes a vector
public func normalizeVector(v : CGVector) -> CGVector {
    //print("normalizeVector v: ", v)
    let vectorSize = sqrt(v.dx * v.dx + v.dy * v.dy)
    //print("vectorSize", vectorSize)
    return CGVector(dx: v.dx/vectorSize, dy: v.dy/vectorSize)
}

// Starts the game!
public func startGame(ballNode: SKShapeNode) {
    generateRandomBallMovement(ballNode: ballNode)
}

// Returns the sum of the variables of a CGVector
public func getBallSpeed(v:CGVector) -> CGFloat {
    return abs(v.dx) + abs(v.dy)
}

// Plays a sound effect then removes it from the parent node. Up to 3 seconds.
public func playSoundEffect(mainNode:SKNode, fileName: String, volume: Float) {
    var soundNode : SKAudioNode
    soundNode = SKAudioNode(fileNamed: fileName)
    soundNode.autoplayLooped = false
    soundNode.run(SKAction.changeVolume(to: volume, duration: 0))
    mainNode.addChild(soundNode)
    soundNode.run(SKAction.play())

    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
        soundNode.removeFromParent()
    })
    
}
