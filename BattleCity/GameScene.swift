import SpriteKit

final class GameScene: SKScene {

    private var gameZone: GameZone!
    private var player: Player!

    override func didMove(to view: SKView) {
        gameZone = GameZone(zoneColor: .black, zoneSize: Constants.screenSize)
        player = Player(gameZone: gameZone)

        addChild(gameZone)

        let levelGenerator = LevelGenerator(width: Int(Constants.screenSize.width / Constants.cellSize.width), height: Int(Constants.screenSize.height / Constants.cellSize.height))
        levelGenerator.build(gameZone: gameZone, player: player)

        physicsWorld.contactDelegate = self
    }

    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case Constants.upArrow: player.moveUp()
        case Constants.downArrow: player.moveDown()
        case Constants.leftArrow: player.moveLeft()
        case Constants.rightArrow: player.moveRight()
        case Constants.space: player.shoot()
        default: break
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "bulletPlayer" && contact.bodyB.node?.name == "gameZone") {
            contact.bodyA.node?.removeFromParent()
        }
        if (contact.bodyA.node?.name == "gameZone" && contact.bodyB.node?.name == "bulletPlayer") {
            contact.bodyB.node?.removeFromParent()
        }

        if (contact.bodyA.node?.name == "bulletEnemy" && contact.bodyB.node?.name == "gameZone") {
            contact.bodyA.node?.removeFromParent()
        }
        if (contact.bodyA.node?.name == "gameZone" && contact.bodyB.node?.name == "bulletEnemy") {
            contact.bodyB.node?.removeFromParent()
        }
    }
}
