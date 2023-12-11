import Foundation
import SpriteKit

final class Wall: SKSpriteNode {
    convenience init() {
        self.init(imageNamed: "wall")
        self.size = Constants.cellSize
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = Constants.wallFlag
        self.physicsBody?.collisionBitMask = Constants.playerFlag | Constants.enemyFlag
        self.physicsBody?.contactTestBitMask = Constants.bulletFlag
        self.name = "wall"
    }
}
