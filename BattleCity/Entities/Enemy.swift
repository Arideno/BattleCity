import Foundation
import SpriteKit

final class Enemy: SKSpriteNode {
    private var direction: Direction = .up

    convenience init() {
        self.init(imageNamed: "enemy")
        self.size = Constants.cellSize
        self.name = "enemy"
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = Constants.enemyFlag
        self.physicsBody?.collisionBitMask = Constants.wallFlag | Constants.playerFlag | Constants.bulletFlag
    }
}
