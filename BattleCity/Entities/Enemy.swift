import Foundation
import SpriteKit

final class Enemy: SKSpriteNode {
    private(set) var direction: Direction = .up
    private var gameZone: GameZone!
    private var lastShootTime: TimeInterval = 0

    convenience init(gameZone: GameZone) {
        self.init(imageNamed: "enemy")
        self.size = Constants.cellSize
        self.gameZone = gameZone
        self.name = "enemy"
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = Constants.enemyFlag
        self.physicsBody?.collisionBitMask = Constants.wallFlag | Constants.playerFlag
        self.physicsBody?.contactTestBitMask = Constants.bulletFlag
    }

    func moveUp(completion: @escaping () -> Void) {
        guard !hasActions() else { return }
        direction = .up
        run(SKAction.sequence([SKAction.rotate(toAngle: 0, duration: 0), SKAction.move(by: CGVector(dx: 0, dy: Constants.cellSize.height), duration: 0.2)]), completion: completion)
    }

    func moveDown(completion: @escaping () -> Void) {
        guard !hasActions() else { return }
        direction = .down
        run(SKAction.sequence([SKAction.rotate(toAngle: .pi, duration: 0), SKAction.move(by: CGVector(dx: 0, dy: -Constants.cellSize.height), duration: 0.2)]), completion: completion)
    }

    func moveLeft(completion: @escaping () -> Void) {
        guard !hasActions() else { return }
        direction = .left
        run(SKAction.sequence([SKAction.rotate(toAngle: .pi / 2, duration: 0), SKAction.move(by: CGVector(dx: -Constants.cellSize.width, dy: 0), duration: 0.2)]), completion: completion)
    }

    func moveRight(completion: @escaping () -> Void) {
        guard !hasActions() else { return }
        direction = .right
        run(SKAction.sequence([SKAction.rotate(toAngle: -.pi / 2, duration: 0), SKAction.move(by: CGVector(dx: Constants.cellSize.width, dy: 0), duration: 0.2)]), completion: completion)
    }

    func shoot(currentTime: TimeInterval) {
        guard abs(lastShootTime - currentTime) > 1 else { return }
        lastShootTime = currentTime
        let bullet = Bullet(radius: 5, isPlayer: false)
        bullet.isHidden = true
        gameZone.addChild(bullet)
        bullet.spawn(direction: direction, position: position)
    }
}
