import Foundation
import SpriteKit

final class Player: SKSpriteNode {
    private var direction: Direction = .up
    private var gameZone: GameZone!
    weak var delegate: PlayerDelegate?

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

    func moveUp() {
        guard !hasActions() else { return }
        direction = .up
        run(SKAction.sequence([SKAction.rotate(toAngle: 0, duration: 0), SKAction.move(by: CGVector(dx: 0, dy: Constants.cellSize.height), duration: 0.2)]))
        { [weak delegate] in
            delegate?.onPlayerMoved(direction: .up)
        }
    }

    func moveDown() {
        guard !hasActions() else { return }
        direction = .down
        run(SKAction.sequence([SKAction.rotate(toAngle: .pi, duration: 0), SKAction.move(by: CGVector(dx: 0, dy: -Constants.cellSize.height), duration: 0.2)])) { [weak delegate] in
            delegate?.onPlayerMoved(direction: .down)
        }
    }

    func moveLeft() {
        guard !hasActions() else { return }
        direction = .left
        run(SKAction.sequence([SKAction.rotate(toAngle: .pi / 2, duration: 0), SKAction.move(by: CGVector(dx: -Constants.cellSize.width, dy: 0), duration: 0.2)])) { [weak delegate] in
            delegate?.onPlayerMoved(direction: .left)
        }
    }

    func moveRight() {
        guard !hasActions() else { return }
        direction = .right
        run(SKAction.sequence([SKAction.rotate(toAngle: -.pi / 2, duration: 0), SKAction.move(by: CGVector(dx: Constants.cellSize.width, dy: 0), duration: 0.2)])) { [weak delegate] in
            delegate?.onPlayerMoved(direction: .right)
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

protocol PlayerDelegate: AnyObject {
    func onPlayerMoved(direction: Direction)
}
