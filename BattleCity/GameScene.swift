import SpriteKit

final class GameScene: SKScene {

    private var gameZone: GameZone!
    private var player: Player!
    private var enemies = [Enemy]()
    private var level: Level!
    private var score = 0
    private var scoreText: SKLabelNode!
    private var prevTime: TimeInterval = 0
    private let difficulty: Difficulty
    private var levelGenerator: LevelGenerator!

    init(size: CGSize, difficulty: Difficulty) {
        self.difficulty = difficulty
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        scoreText = SKLabelNode(text: "Score: \(score)")
        scoreText.position = CGPoint(x: 70, y: 40)
        scoreText.zPosition = 1000

        gameZone = GameZone(zoneColor: .black, zoneSize: Constants.screenSize)
        player = Player(gameZone: gameZone)

        addChild(gameZone)
        addChild(scoreText)

        levelGenerator = LevelGenerator(width: Int(Constants.screenSize.width / Constants.cellSize.width), height: Int(Constants.screenSize.height / Constants.cellSize.height), difficulty: difficulty)
        level = levelGenerator.build()

        drawLevel()

        physicsWorld.contactDelegate = self
    }

    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case Constants.upArrow: 
            if !player.isMoving {
                player.direction = .up
                player.isCommandedToMove = true
            }
        case Constants.downArrow:
            if !player.isMoving {
                player.direction = .down
                player.isCommandedToMove = true
            }
        case Constants.leftArrow:
            if !player.isMoving {
                player.direction = .left
                player.isCommandedToMove = true
            }
        case Constants.rightArrow:
            if !player.isMoving {
                player.direction = .right
                player.isCommandedToMove = true
            }
        case Constants.space: player.shoot()
        default: break
        }
    }

    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case Constants.upArrow, Constants.downArrow, Constants.leftArrow, Constants.rightArrow:
            player.isCommandedToMove = false
        default: break
        }
    }

    override func update(_ currentTime: TimeInterval) {
        if abs(prevTime - currentTime) > 0.01 {
            enemyAction(currentTime: currentTime)
            player.move()
            prevTime = currentTime
        }
    }

    private func enemyAction(currentTime: TimeInterval) {
        for enemy in enemies {
            let pos = gameZoneToLevelPosition(coordinate: enemy.position)
            let playerPos = gameZoneToLevelPosition(coordinate: player.position)
            let playerPath = level.difficulty.pathFindingAlgorithm.findPath(from: pos, to: playerPos, in: level.grid)
            var basePath: [Point]?
            var nextPoint: Point?

            if level.difficulty == .hard {
                var levelCopy = level!
                levelCopy.grid[0][levelCopy.width / 2 - 1] = .space
                levelCopy.grid[0][levelCopy.width / 2 + 1] = .space
                levelCopy.grid[1][levelCopy.width / 2 + 1] = .space
                levelCopy.grid[1][levelCopy.width / 2 - 1] = .space
                levelCopy.grid[1][levelCopy.width / 2] = .space
                basePath = BFS().findPath(from: pos, to: levelCopy.basePosition, in: levelCopy.grid)
            }

            if playerPath.count > 1 && playerPath.count < (basePath?.count ?? 100000) {
                nextPoint = playerPath[1]
            } else if let base = basePath, base.count > 1 {
                nextPoint = base[1]
            }

            if let nextPoint {
                if !enemy.isMoving {
                    if nextPoint.x > pos.x {
                        enemy.direction = .right
                    } else if nextPoint.x < pos.x {
                        enemy.direction = .left
                    } else if nextPoint.y < pos.y {
                        enemy.direction = .down
                    } else if nextPoint.y > pos.y {
                        enemy.direction = .up
                    }
                }

                enemy.move()
            }

            if level.difficulty.shootingStrategy.shouldShoot(
                enemyPos: pos,
                enemyDir: enemy.direction,
                playerPosition: playerPos,
                basePosition: level.basePosition,
                grid: level.grid
            ) {
                enemy.shoot(currentTime: currentTime)
            }
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

        for (index, point) in level.enemySpawnPoints.enumerated() {
            let enemy = level.difficulty.enemyTypes[index].create(gameZone: gameZone)
            enemy.position = CGPoint(x: CGFloat(point.x) * Constants.cellSize.width + Constants.cellSize.width / 2, y: CGFloat(point.y) * Constants.cellSize.height + Constants.cellSize.height / 2)
            gameZone.addChild(enemy)
            enemies.append(enemy)
        }

        player.position = CGPoint(x: CGFloat(level.playerPosition.x) * Constants.cellSize.width + Constants.cellSize.width / 2, y: CGFloat(level.playerPosition.y) * Constants.cellSize.height + Constants.cellSize.height / 2)
        gameZone.addChild(player)

        let base = Base()
        base.position = CGPoint(x: CGFloat(basePosition.x) * Constants.cellSize.width + Constants.cellSize.width / 2, y: CGFloat(basePosition.y) * Constants.cellSize.height + Constants.cellSize.height / 2)
        gameZone.addChild(base)
    }

    private func stopGame() {
        UserDefaults.standard.setValue(max(UserDefaults.standard.integer(forKey: "highScore"), score), forKey: "highScore")
        let scene = GameOverScene(size: Constants.screenSize, score: score)
        scene.scaleMode = .aspectFill
        view?.presentScene(scene)
    }

    private func enemyKilled() {
        if enemies.isEmpty {
            for (index, point) in levelGenerator.generateEnemySpawnPoints(grid: level.grid, playerPosition: gameZoneToLevelPosition(coordinate: player.position)).enumerated() {
                let enemy = level.difficulty.enemyTypes[index].create(gameZone: gameZone)
                enemy.position = CGPoint(x: CGFloat(point.x) * Constants.cellSize.width + Constants.cellSize.width / 2, y: CGFloat(point.y) * Constants.cellSize.height + Constants.cellSize.height / 2)
                gameZone.addChild(enemy)
                enemies.append(enemy)
            }
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
            guard let enemy = contact.bodyB.node as? Enemy, enemy.shouldDie() else { return }
            if let index = enemies.firstIndex(of: enemy) {
                enemies.remove(at: index)
            }

            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            score += level.difficulty.scoreForEnemy
            scoreText.text = "Score: \(score)"
            enemyKilled()
        }
        if (contact.bodyA.node?.name == "enemy" && contact.bodyB.node?.name == "bulletPlayer") {
            guard let enemy = contact.bodyA.node as? Enemy, enemy.shouldDie() else { return }

            if let index = enemies.firstIndex(of: enemy) {
                enemies.remove(at: index)
            }

            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            score += level.difficulty.scoreForEnemy
            scoreText.text = "Score: \(score)"
            enemyKilled()
        }

        if (contact.bodyA.node?.name == "bulletEnemy" && contact.bodyB.node?.name == "player") {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            stopGame()
        }
        if (contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "bulletEnemy") {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            stopGame()
        }

        if (contact.bodyA.node?.name == "bulletEnemy" && contact.bodyB.node?.name == "base") {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            stopGame()
        }
        if (contact.bodyA.node?.name == "base" && contact.bodyB.node?.name == "bulletEnemy") {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            stopGame()
        }
    }
}
