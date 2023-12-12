import Foundation
import SpriteKit

class Enemy: SKSpriteNode {
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

    fileprivate var gameZone: GameZone!
    private var lastShootTime: TimeInterval = 0
    private(set) var isMoving: Bool = false
    private var movesCount = 0
    fileprivate var lifes: Int!

    override init(texture: SKTexture?, color: NSColor, size: CGSize) {
        super.init(texture: texture, color: .white, size: size)
        self.name = "enemy"
        self.physicsBody = SKPhysicsBody(rectangleOf: Constants.cellSize)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = Constants.enemyFlag
        self.physicsBody?.collisionBitMask = Constants.wallFlag | Constants.playerFlag
        self.physicsBody?.contactTestBitMask = Constants.bulletFlag
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func move() {
        isMoving = true
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
    }

    func shoot(currentTime: TimeInterval) {
        guard abs(lastShootTime - currentTime) > 1 else { return }
        lastShootTime = currentTime
        let bullet = Bullet(radius: 5, isPlayer: false)
        bullet.isHidden = true
        gameZone.addChild(bullet)
        bullet.spawn(direction: direction, position: position)
    }

    func shouldDie() -> Bool {
        lifes -= 1
        return lifes <= 0
    }
}

final class EnemySmall: Enemy {
    init(gameZone: GameZone) {
        super.init(texture: SKTexture(imageNamed: "enemy"), color: .white, size: .init(width: 30, height: 30))
        self.gameZone = gameZone
        self.lifes = 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class EnemyBig: Enemy {
    init(gameZone: GameZone) {
        super.init(texture: SKTexture(imageNamed: "enemy_big"), color: .white, size: .init(width: 40, height: 40))
        self.gameZone = gameZone
        self.lifes = 2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
