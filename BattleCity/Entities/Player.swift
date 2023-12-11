import Foundation
import SpriteKit

final class Player: SKSpriteNode {
    private var direction: Rotation = .up

    convenience init() {
        self.init(imageNamed: "player")
        self.size = Constants.cellSize
        self.name = "player"
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = Constants.playerFlag
        self.physicsBody?.collisionBitMask = Constants.wallFlag | Constants.enemyFlag | Constants.bulletFlag
    }
}
