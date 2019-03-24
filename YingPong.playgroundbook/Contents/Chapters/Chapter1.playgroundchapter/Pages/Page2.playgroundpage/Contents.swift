
/*:
 
 # The Yin and Yang

Now that we have a perception about _mu_, it's time to see another symbol's importance!
 
 Whilst having a grasp about _mu_ is important to our daily life, our life isn't empty. We experience things and judge them. Feel them. Comprehend them.
 
 Our judgments are often based on a principle: **duality**
 
 For instance, we may think that the weather is hot. However, how can we judge it's hotness without knowing how cold feels like? It's part of our most primal functions as human beings.
 
 Following the temperature example, we can see a very interesting principle: despite hotness or coldness being somewhat opposites, they are two sides of coin! Not only that, but they are the same phenomenom, just on different scales.
 
 The point is: we usually see two sides - or scales in between - of a thing. **Duality is in everything.**
 
 The Yin Yang is a symbol that represents this duality **really** well. We have two sides - the bright and the dark one. However, a piece of brightness can be seen on the dark side, and so is the opposite. This is a visual representation of the fact that they are the same thing!
 
 I would like you to **create a Yin Yang**. It'll be rather easy, trust me. I'll do all the painting!
 
 Once you are done, feel free to go to the next page. We'll talk about balance.

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
    //sceneView.showsFPS = true
    sceneView.isMultipleTouchEnabled = true
    //sceneView.showsFields = true
    
    // Load the SKScene from 'GameScene.sks'
    
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

//#-end-hidden-code
