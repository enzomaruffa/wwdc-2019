import PlaygroundSupport
import SpriteKit
import Foundation

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.backgroundColor = ICE_WHITE
    scene.scaleMode = .aspectFill
    
    
    // Present the scene
    sceneView.presentScene(scene)
    //sceneView.showsPhysics = true
    sceneView.showsFPS = true
    sceneView.isMultipleTouchEnabled = true
    //sceneView.showsFields = true
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView


