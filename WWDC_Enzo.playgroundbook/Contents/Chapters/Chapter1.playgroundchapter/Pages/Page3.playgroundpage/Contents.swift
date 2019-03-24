

/*: ## Motion vs Stillness: balance requires changes
 
Great! Now we know how everything has two sides - and although they may seem opposite, they are rather *complimentary*. One can't exist without the other.
 
 So, it seems like a logical step that we try to balance stuff. It shouldn't be hot or cold: why can't we have a temperature that is between these extremes?
 
 Well, let's talk about motion.
 
 Motion is constant. We are subjects of lots and lots of changes, major or minor. How would we be able to balance this, constantly?
 
 Quick answer: it's not worth it.
 
 We need rhythm. We need to experience both sides, regularly - but not necessarily at the same time.
 
 When you run the code on your right, you'll see a Yin Yang and a ball.
 
 I want you to see a concept that has two sides in the place of that ball. It can be anything you would like: temperature? your emotions? It's your call.
 
 Do it. Then come back here :)
 
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
    
    var motion = false
    var life = false
    //#-end-hidden-code

    //: See this little code below? See what happens when you set these variables to true (replacing "false" with "true" and running the code again). Come back here then :)
    
    //#-editable-code
    motion = false
    life = false
    //#-end-editable-code
    
/*:
     
     When we add motion, we add the fact that we can't control everything. Some of them just go beyond our area of influence. And see, that's ok! Life is about dealing with these situations.
     
     Since we are talking about the influence of our lives: well, some things just blow their own systems - they go way ahead (and we are not talking about good or bad) of what they should be. Especially, our emotions. Nowadays, lots of mental conditions are all about how we can't fully understand that we do not control eveything, and that makes us shocked!
     
     However, understanding ourselves is a fundamental step in reducind how these situations affects us.
     
     Let us continue on our next and last page.
 
 */

    //#-hidden-code 

    if motion {
        scene.addMotion()
    }

    if life {
        scene.addLife()
    }
    
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
