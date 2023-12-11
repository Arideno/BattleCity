import Foundation
import SpriteKit

final class Base: SKSpriteNode {
    convenience init() {
        self.init(imageNamed: "base")
        self.size = Constants.cellSize
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = Constants.baseFlag
        self.physicsBody?.contactTestBitMask = Constants.bulletFlag
        self.name = "base"
    }
}
