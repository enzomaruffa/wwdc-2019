
//: A rose is a rose is a rose.

//#-hidden-code

import PlaygroundSupport
import SpriteKit
import Foundation
import AVFoundation

var AudioPlayer = AVAudioPlayer()

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
    
    // Load the SKScene from 'GameScene.sks'
    
    let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: "BackgroundSong", ofType: "mp3")!)
    AudioPlayer = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
    AudioPlayer.prepareToPlay()
    AudioPlayer.numberOfLoops = -1
    AudioPlayer.volume = 0.08
    AudioPlayer.play()
    
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

//#-end-hidden-code
