import Foundation
import SpriteKit

public let PAD_STEP = CGFloat(1.4)
public let BUMPER_SPEED_FACTOR = CGFloat(1.04)
public let WAVE_DURATION : TimeInterval = 0.8

public let MAIN_NODE_ROTATION = CGFloat(0)

public let BALL_BITMASK : UInt32 = 0x00000011
public let BORDER_BITMASK : UInt32 = 0x00000001
public let BUMPER_BITMASK : UInt32 = 0x00000010
public let PAD_BITMASK : UInt32 = 0x00000100

public let CIRCLE_RADIUS = CGFloat(275)
public let CIRCLE_CENTER = CGPoint(x: 0, y: 0)
public let SCREEN_WIDTH = CGFloat(800)
public let SCREEN_HEIGHT = CGFloat(600)
public let ARC_WIDTH = CGFloat(6)

public let BUMPER_RADIUS = CIRCLE_RADIUS*CGFloat(0.15)

public let WHITE_SIDE_COLOR = SKColor.init(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
public let BLACK_SIDE_COLOR = SKColor.init(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
public let BORDER_COLOR = SKColor.black

public var PAD_SIZE = CGFloat(20)
public var PAD_DIRECTED_HIT_PROPORTION = CGFloat(0.35)
public var BORDER_SIZE = CGFloat(120)
