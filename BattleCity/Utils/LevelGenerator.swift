import Foundation

struct Point: Hashable {
    var x: Int
    var y: Int
}

enum Cell {
    case wall
    case space
    case base
    case player
    case enemy
}

final class LevelGenerator {
    let width: Int
    let height: Int
    var level: [[Cell]] = []

    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }

    func build(gameZone: GameZone, player: Player) {
        level = Array(repeating: Array(repeating: Cell.wall, count: width), count: height)
        let startX = Int.random(in: 0..<width)
        let startY = Int.random(in: 0..<height)

        func isSafe(x: Int, y: Int) -> Bool {
            return x >= 0 && x < width && y >= 0 && y < height
        }

        func dfs(x: Int, y: Int) {
            if !isSafe(x: x, y: y) || level[y][x] == .space {
                return
            }

            level[y][x] = .space

            var neighbors = [
                Point(x: 2, y: 0),
                Point(x: -2, y: 0),
                Point(x: 0, y: 2),
                Point(x: 0, y: -2)
            ]

            neighbors.shuffle()

            for point in neighbors {
                let newX = x + point.x
                let newY = y + point.y

                if isSafe(x: newX, y: newY) && level[newY][newX] == .wall {
                    if isSafe(x: x + point.x / 2, y: y + point.y / 2) {
                        level[y + point.y / 2][x + point.x / 2] = .space
                    }
                    dfs(x: newX, y: newY)
                }
            }
        }

        func addExtraPaths() {
            for _ in 0..<(width * height / 2) {
                let x = Int.random(in: 1..<width - 1)
                let y = Int.random(in: 1..<height - 1)

                if level[y][x] == .wall {
                    level[y][x] = .space
                }
            }
        }

        dfs(x: startX, y: startY)
        addExtraPaths()

        for x in width / 2 - 1...width / 2 + 1 {
            level[0][x] = .wall
            level[1][x] = .wall
        }
        level[0][width / 2] = .base

        var playerPosition = Point(x: 0, y: 0)
        while level[playerPosition.y][playerPosition.x] != .space {
            playerPosition = Point(x: Int.random(in: 0..<width), y: Int.random(in: 0..<height))
        }

        level[playerPosition.y][playerPosition.x] = .player

        for y in 0..<height {
            for x in 0..<width {
                if level[y][x] == .wall {
                    let wall = Wall()
                    wall.position = CGPoint(x: CGFloat(x) * Constants.cellSize.width + Constants.cellSize.width / 2, y: CGFloat(y) * Constants.cellSize.height + Constants.cellSize.height / 2)
                    gameZone.addChild(wall)
                }
            }
        }

        player.position = CGPoint(x: CGFloat(playerPosition.x) * Constants.cellSize.width + Constants.cellSize.width / 2, y: CGFloat(playerPosition.y) * Constants.cellSize.height + Constants.cellSize.height / 2)
        gameZone.addChild(player)

        let base = Base()
        base.position = CGPoint(x: CGFloat(width / 2) * Constants.cellSize.width + Constants.cellSize.width / 2, y: Constants.cellSize.height / 2)
        gameZone.addChild(base)
    }
}

func gameZoneToLevelPosition(coordinate: CGPoint) -> Point {
    Point(
        x: Int(((coordinate.x - Constants.cellSize.width / 2) / Constants.cellSize.width).rounded(.toNearestOrEven)),
        y: Int(((coordinate.y - Constants.cellSize.height / 2) / Constants.cellSize.height).rounded(.toNearestOrEven))
    )
}
