import Foundation
import SpriteKit

public let PAD_STEP = CGFloat(3.01)
public let BUMPER_SPEED_FACTOR = CGFloat(1.0733)
public let WAVE_DURATION : TimeInterval = 0.8
public let MAIN_NODE_ROTATION_INCREMENT = CGFloat(0.33/60)
public var MAIN_NODE_ROTATION_ORIGINAL = CGFloat(15/60)

public let BALL_BITMASK : UInt32 = 0x00000011
public let BORDER_BITMASK : UInt32 = 0x00000001
public let BUMPER_BITMASK : UInt32 = 0x00000010
public let PAD_BITMASK : UInt32 = 0x00000100
public let PAD_LEFT_DIRECTED_BITMASK : UInt32 = 0x00000101
public let PAD_RIGHT_DIRECTED_BITMASK : UInt32 = 0x00000111

public let CIRCLE_RADIUS = CGFloat(275)
public let CIRCLE_CENTER = CGPoint(x: 0, y: 0)
public let SCREEN_WIDTH = CGFloat(800)
public let SCREEN_HEIGHT = CGFloat(600)
public let ARC_WIDTH = CGFloat(5)

public let BUMPER_RADIUS = CIRCLE_RADIUS*CGFloat(0.15)

public let WHITE_SIDE_COLOR = SKColor.init(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
public let BLACK_SIDE_COLOR = SKColor.init(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
public let PAD_INSIDE_COLOR = SKColor.gray
public let PAD_OUTSIDE_COLOR = SKColor.black

public let BORDER_COLOR = SKColor.black

public let PAD_SIZE = CGFloat(20)
public let PAD_CENTRAL_PROPORTION = CGFloat(0.6)
public let BORDER_SIZE = CGFloat(120)

public let STARTING_BALL_SPEED = CGFloat(550)

public let BALL_PROPORTION = CGFloat(0.05)
