import Foundation
import SpriteKit

final class GameZone: SKSpriteNode {
    convenience init(zoneColor: NSColor, zoneSize: CGSize) {
        self.init(color: zoneColor, size: zoneSize)
        self.anchorPoint = .zero
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: zoneSize.width, height: zoneSize.height))
        self.physicsBody?.affectedByGravity = false
        self.name = "gameZone"
    }
}

