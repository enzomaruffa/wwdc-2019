import Foundation
import SpriteKit

public let CIRCLE_RADIUS = CGFloat(230)
public let CIRCLE_CENTER = CGPoint(x: 0, y: 0)
public let SCREEN_WIDTH = CGFloat(800)
public let SCREEN_HEIGHT = CGFloat(600)
public let ARC_WIDTH = CGFloat(5)

public let PAD_STEP = CGFloat(2.75)
public let BUMPER_SPEED_FACTOR = CGFloat(1.0633)

public let WAVE_DURATION : TimeInterval = 0.9

public let MAIN_NODE_ROTATION_INCREMENT = CGFloat(0.05/60)
public var MAIN_NODE_ROTATION_ORIGINAL = CGFloat(20/60)

public let BALL_BITMASK : UInt32 = 0x00000011
public let BORDER_BITMASK : UInt32 = 0x00000001
public let BUMPER_BITMASK : UInt32 = 0x00000010
public let PAD_BITMASK : UInt32 = 0x00000100
public let PAD_LEFT_DIRECTED_BITMASK : UInt32 = 0x00000101
public let PAD_RIGHT_DIRECTED_BITMASK : UInt32 = 0x00000111

public let BUMPER_RADIUS = CIRCLE_RADIUS*CGFloat(0.18)

public let STRONG_PURPLE = UIColor(red:0.6118, green:0.2118, blue:0.8588, alpha:1.00000)
public let WEAK_PURPLE = UIColor(red:0.6863, green:0.3686, blue:0.8863, alpha:1.00000)

public let ICE_WHITE = SKColor.init(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
public let GREY = SKColor.init(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)

/*public let WHITE_SIDE_COLOR = ICE_WHITE
public let BLACK_SIDE_COLOR = GREY
public let PAD_INSIDE_COLOR = SKColor.gray
public let PAD_OUTSIDE_COLOR = SKColor.black
public let BORDER_COLOR = SKColor.black*/

public let WHITE_SIDE_COLOR = ICE_WHITE
public let BLACK_SIDE_COLOR = GREY
public let PAD_INSIDE_COLOR = WEAK_PURPLE
public let PAD_OUTSIDE_COLOR = STRONG_PURPLE
public let BORDER_COLOR = SKColor.black

public let PAD_SIZE = CGFloat(22)
public let PAD_CENTRAL_PROPORTION = CGFloat(0.5)
public let BORDER_SIZE = CGFloat(100)

public let STARTING_BALL_SPEED = CGFloat(380)

public let BALL_PROPORTION = CGFloat(0.05)
