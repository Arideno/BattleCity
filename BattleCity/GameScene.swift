import SpriteKit

final class GameScene: SKScene {

    private var gameZone: GameZone!
    private var player: Player!
    private var level: Level!
    private var score = 0
    private var scoreText: SKLabelNode!

    override func didMove(to view: SKView) {
        scoreText = SKLabelNode(text: "Score: \(score)")
        scoreText.position = CGPoint(x: 70, y: 30)
        scoreText.zPosition = 1000

        gameZone = GameZone(zoneColor: .black, zoneSize: Constants.screenSize)
        player = Player(gameZone: gameZone)
        player.delegate = self

        addChild(gameZone)
        addChild(scoreText)

        let levelGenerator = LevelGenerator(width: Int(Constants.screenSize.width / Constants.cellSize.width), height: Int(Constants.screenSize.height / Constants.cellSize.height), difficulty: .easy)
        level = levelGenerator.build()

        drawLevel()

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

    private func drawLevel() {
        var basePosition = Point(x: 0, y: 0)

        for y in 0..<level.height {
            for x in 0..<level.width {
                if level.grid[y][x] == .wall {
                    let wall = Wall()
                    wall.position = CGPoint(x: CGFloat(x) * Constants.cellSize.width + Constants.cellSize.width / 2, y: CGFloat(y) * Constants.cellSize.height + Constants.cellSize.height / 2)
                    gameZone.addChild(wall)
                } else if level.grid[y][x] == .base {
                    basePosition = Point(x: x, y: y)
                }
            }
        }

        for _ in 0..<level.difficulty.enemyCount {
            let enemy = Enemy()
            enemy.position = CGPoint(x: CGFloat(level.enemySpawnPoint.x) * Constants.cellSize.width + Constants.cellSize.width / 2, y: CGFloat(level.enemySpawnPoint.y) * Constants.cellSize.height + Constants.cellSize.height / 2)
            gameZone.addChild(enemy)
        }

        player.position = CGPoint(x: CGFloat(level.playerPosition.x) * Constants.cellSize.width + Constants.cellSize.width / 2, y: CGFloat(level.playerPosition.y) * Constants.cellSize.height + Constants.cellSize.height / 2)
        gameZone.addChild(player)

        let base = Base()
        base.position = CGPoint(x: CGFloat(basePosition.x) * Constants.cellSize.width + Constants.cellSize.width / 2, y: CGFloat(basePosition.y) * Constants.cellSize.height + Constants.cellSize.height / 2)
        gameZone.addChild(base)
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

        if (contact.bodyA.node?.name == "bulletPlayer" && contact.bodyB.node?.name == "wall") {
            let point = gameZoneToLevelPosition(coordinate: contact.bodyB.node!.position)
            level.grid[point.y][point.x] = .space
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
        }
        if (contact.bodyA.node?.name == "wall" && contact.bodyB.node?.name == "bulletPlayer") {
            let point = gameZoneToLevelPosition(coordinate: contact.bodyA.node!.position)
            level.grid[point.y][point.x] = .space
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
        }

        if (contact.bodyA.node?.name == "bulletEnemy" && contact.bodyB.node?.name == "wall") {
            let point = gameZoneToLevelPosition(coordinate: contact.bodyB.node!.position)
            level.grid[point.y][point.x] = .space
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
        }
        if (contact.bodyA.node?.name == "wall" && contact.bodyB.node?.name == "bulletEnemy") {
            let point = gameZoneToLevelPosition(coordinate: contact.bodyA.node!.position)
            level.grid[point.y][point.x] = .space
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
        }

        if (contact.bodyA.node?.name == "bulletPlayer" && contact.bodyB.node?.name == "enemy") {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            score += level.difficulty.scoreForEnemy
            scoreText.text = "Score: \(score)"
        }
        if (contact.bodyA.node?.name == "enemy" && contact.bodyB.node?.name == "bulletPlayer") {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            score += level.difficulty.scoreForEnemy
            scoreText.text = "Score: \(score)"
        }
    }
}

extension GameScene: PlayerDelegate {
    func onPlayerMoved(direction: Direction) {
        level.movePlayerPosition(direction: direction)
        print(level!)
    }
}
