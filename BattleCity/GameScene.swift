import SpriteKit

final class GameScene: SKScene {

    private var gameZone: GameZone!
    private var player: Player!
    private var enemyPositions = [Point]()
    private var enemies = [Enemy]()
    private var level: Level!
    private var score = 0
    private var scoreText: SKLabelNode!
    private var prevTime: TimeInterval = 0

    override func didMove(to view: SKView) {
        scoreText = SKLabelNode(text: "Score: \(score)")
        scoreText.position = CGPoint(x: 70, y: 40)
        scoreText.zPosition = 1000

        gameZone = GameZone(zoneColor: .black, zoneSize: Constants.screenSize)
        player = Player(gameZone: gameZone)
        player.delegate = self

        addChild(gameZone)
        addChild(scoreText)

        let levelGenerator = LevelGenerator(width: Int(Constants.screenSize.width / Constants.cellSize.width), height: Int(Constants.screenSize.height / Constants.cellSize.height), difficulty: .hard)
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

    override func update(_ currentTime: TimeInterval) {
        if abs(prevTime - currentTime) > 0.5 {
            enemyAction(currentTime: currentTime)
            prevTime = currentTime
        }
    }

    private func enemyAction(currentTime: TimeInterval) {
        for i in enemies.indices {
            let enemy = enemies[i]
            let pos = enemyPositions[i]
            let playerPath = level.difficulty.pathFindingAlgorithm.findPath(from: pos, to: level.playerPosition, in: level.grid)
            var basePath: [Point]?
            var nextPoint: Point?

            if level.difficulty == .hard {
                var levelCopy = level!
                for y in 0..<levelCopy.height {
                    for x in 0..<levelCopy.width {
                        if levelCopy.grid[y][x] == .wall {
                            levelCopy.grid[y][x] = .space
                        }
                    }
                }
                basePath = BFS().findPath(from: pos, to: levelCopy.basePosition, in: levelCopy.grid)
            }

            if playerPath.count > 1 && playerPath.count < (basePath?.count ?? 0) {
                nextPoint = playerPath[1]
            } else if let base = basePath, base.count > 1 {
                nextPoint = base[1]
            }

            if let nextPoint {
                if nextPoint.x > pos.x {
                    enemy.moveRight {
                        self.enemyPositions[i].x += 1
                    }
                } else if nextPoint.x < pos.x {
                    enemy.moveLeft {
                        self.enemyPositions[i].x -= 1
                    }
                } else if nextPoint.y < pos.y {
                    enemy.moveDown {
                        self.enemyPositions[i].y -= 1
                    }
                } else if nextPoint.y > pos.y {
                    enemy.moveUp {
                        self.enemyPositions[i].y += 1
                    }
                }
            }

            if level.difficulty.shootingStrategy.shouldShoot(enemyPos: enemyPositions[i], enemyDir: enemy.direction, level: level) {
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

        for point in level.enemySpawnPoints {
            let enemy = Enemy(gameZone: gameZone)
            enemy.position = CGPoint(x: CGFloat(point.x) * Constants.cellSize.width + Constants.cellSize.width / 2, y: CGFloat(point.y) * Constants.cellSize.height + Constants.cellSize.height / 2)
            gameZone.addChild(enemy)
            enemyPositions = level.enemySpawnPoints
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
            if let enemy = contact.bodyB.node as? Enemy, let index = enemies.firstIndex(of: enemy) {
                enemies.remove(at: index)
                enemyPositions.remove(at: index)
            }

            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            score += level.difficulty.scoreForEnemy
            scoreText.text = "Score: \(score)"
        }
        if (contact.bodyA.node?.name == "enemy" && contact.bodyB.node?.name == "bulletPlayer") {
            if let enemy = contact.bodyB.node as? Enemy, let index = enemies.firstIndex(of: enemy) {
                enemies.remove(at: index)
                enemyPositions.remove(at: index)
            }

            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            score += level.difficulty.scoreForEnemy
            scoreText.text = "Score: \(score)"
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

extension GameScene: PlayerDelegate {
    func onPlayerMoved(direction: Direction) {
        level.movePlayerPosition(direction: direction)
        print(level!)
    }
}
