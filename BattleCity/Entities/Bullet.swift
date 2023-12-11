import Foundation
import SpriteKit

final class Bullet: SKShapeNode {
    convenience init(radius: CGFloat, isPlayer: Bool) {
        self.init(circleOfRadius: radius)
        self.fillColor = isPlayer ? .white : .red
        self.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = Constants.bulletFlag
        self.physicsBody?.contactTestBitMask = Constants.wallFlag | Constants.enemyFlag | Constants.playerFlag
        self.name = isPlayer ? "bulletPlayer" : "bulletEnemy"
    }

    func spawn(direction: Rotation, position: CGPoint) {
        var addBulletY: CGFloat = 0
        var addBulletX: CGFloat = 0
        let bulletMoveAction: SKAction
        switch direction {
        case .left:
            addBulletX = -30
            bulletMoveAction = SKAction.moveTo(x: 0, duration: TimeInterval(position.x / 200))
        case .right:
            addBulletX = 30
            bulletMoveAction = SKAction.moveTo(x: Constants.screenSize.width, duration: TimeInterval(position.x / 200))
        case .up:
            addBulletY = 30
            bulletMoveAction = SKAction.moveTo(y: Constants.screenSize.height, duration: TimeInterval(position.y / 200))
        case .down:
            addBulletY = -30
            bulletMoveAction = SKAction.moveTo(y: 0, duration: TimeInterval(position.y / 200))
        }

        self.position = CGPoint(x: position.x + addBulletX, y: position.y + addBulletY)
        isHidden = false
        run(bulletMoveAction)
    }
}
