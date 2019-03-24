
/*:
 
 # Balance and Harmony
 
 We work hard towards whatever we think fulfill us.
 And that is completely fair!
 
 However, we mustn't forget about balance and harmony.
 
 We will get there soon enough! First, we need to talk about _mu_
 
 ---
 
 # _Mu_
 
 Roughly translated, _mu_ means "not have; without". It's a keyword in Zen Buddhism traditions.
 
 The concept behind seems kinda simple: "nothingness", or "the absence of"
 
 Although _mu_ has this apparent simplicty, _mu_ is completely symbolic. That means that it's really, really difficult to express what it means in words - or even properly think about it.
 
 Once you see something, hear a word or a sound or even think about anything, you are somehow applying your experience and perceptions over it. How can you truly understand something by itself? Without **any** previous judgement?
 
 Well, it's almost impossible. And that's ok.
 
 See, how can we picture "nothingness"? You may think about an empty white canvas, but it's a white canvas nonetheless!
 
 It's often visual representation is a black circle, hand-drawn in a single stroke: an _ensō_ - a japanese wordß
 
 We'll do a bit different, though. I would like you to use the purple pad and control buttons to draw a circle on our little screen to the right. You'll get the hang of it.
 
 Once you have done it, feel free to appreciate it. Stare into it for a bit, but don't overthink it. Actually, don't think about it. Just stare, and stare. Nothingness isn't!
 

 - Note: For a proper experience, use your iPad on landscape mode and, after reading this text, hide it. We'll be using the full view :)
 
 */

//#-hidden-code

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
    
    // Load the SKScene from 'GameScene.sks'
    
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

//#-end-hidden-code
