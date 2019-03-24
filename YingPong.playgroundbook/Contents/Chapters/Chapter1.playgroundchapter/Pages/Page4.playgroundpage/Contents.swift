
/*:
 
 # Control
 
 Now, we'll play a little game. I hope that you have a better understanding about how we, as human beings, must accept some tough - yet very valuable - unspoken facts.
 
 In this game, I want you to not let the ball - that experience that I've asked you to think about before - escape from our "normal" zones and behaviors. **You'll control our good ol' purple pads, just like you did before.**
 
 But beware, **life might keep presenting you new challenges**. Or you may have less time to spend on evaluating decisions? Huh, guess I've just spoiled something...
 
 Don't forget: the most important part of the journey is to enjoy it. **Be happy and live with harmony :)**
 
 - Note: For a proper experience, use your iPad on landscape mode and, after reading this text, hide it. We'll be using the full view :)
 
 */

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
    //sceneView.showsFPS = true
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
