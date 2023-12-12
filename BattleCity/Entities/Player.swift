import Foundation
import SpriteKit

final class Player: SKSpriteNode {
    var direction: Direction = .up {
        didSet {
            switch direction {
            case .up:
                zRotation = 0
            case .down:
                zRotation = .pi
            case .left:
                zRotation = .pi / 2
            case .right:
                zRotation = -.pi / 2
            }
        }
    }
    private var gameZone: GameZone!
    private(set) var isMoving = false
    var isCommandedToMove = false
    private var movesCount = 0

    convenience init(gameZone: GameZone) {
        self.init(imageNamed: "player")
        self.gameZone = gameZone
        self.size = Constants.cellSize
        self.name = "player"
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = Constants.playerFlag
        self.physicsBody?.collisionBitMask = Constants.wallFlag | Constants.enemyFlag | Constants.bulletFlag
    }

    func move() {
        if isMoving {
            switch direction {
            case .up:
                position.y += 1
            case .down:
                position.y -= 1
            case .left:
                position.x -= 1
            case .right:
                position.x += 1
            }
            movesCount += 1

            if movesCount == 40 {
                isMoving = false
                movesCount = 0
            }
        } else if isCommandedToMove {
            isMoving = true
        }
    }

    func shoot() {
        guard !hasActions() else { return }
        let bullet = Bullet(radius: 5, isPlayer: true)
        bullet.isHidden = true
        gameZone.addChild(bullet)
        bullet.spawn(direction: direction, position: position)
    }
}
