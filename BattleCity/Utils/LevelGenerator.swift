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
    case enemySpawn
}

final class LevelGenerator {
    let width: Int
    let height: Int
    let difficulty: Difficulty

    init(width: Int, height: Int, difficulty: Difficulty) {
        self.width = width
        self.height = height
        self.difficulty = difficulty
    }

    func build() -> Level {
        var grid = Array(repeating: Array(repeating: Cell.wall, count: width), count: height)
        let startX = Int.random(in: 0..<width)
        let startY = Int.random(in: 0..<height)

        func isSafe(x: Int, y: Int) -> Bool {
            return x >= 0 && x < width && y >= 0 && y < height
        }

        func dfs(x: Int, y: Int) {
            if !isSafe(x: x, y: y) || grid[y][x] == .space {
                return
            }

            grid[y][x] = .space

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

                if isSafe(x: newX, y: newY) && grid[newY][newX] == .wall {
                    if isSafe(x: x + point.x / 2, y: y + point.y / 2) {
                        grid[y + point.y / 2][x + point.x / 2] = .space
                    }
                    dfs(x: newX, y: newY)
                }
            }
        }

        dfs(x: startX, y: startY)

        for _ in 0..<(width * height / 4) {
            let x = Int.random(in: 1..<width - 1)
            let y = Int.random(in: 1..<height - 1)

            if grid[y][x] == .wall {
                grid[y][x] = .space
            }
        }

        for i in 0..<width {
            grid[0][i] = .space
            grid[height - 1][i] = .space
        }

        for i in 0..<height {
            grid[i][0] = .space
            grid[i][width - 1] = .space
        }

        for x in width / 2 - 1...width / 2 + 1 {
            grid[0][x] = .wall
            grid[1][x] = .wall
        }
        grid[0][width / 2] = .base

        var playerPosition = Point(x: 0, y: 0)
        while grid[playerPosition.y][playerPosition.x] != .space {
            playerPosition = Point(x: Int.random(in: 0..<width), y: Int.random(in: 0..<height))
        }

        grid[playerPosition.y][playerPosition.x] = .player

        var enemySpawnPosition = Point(x: 0, y: 0)
        while grid[enemySpawnPosition.y][enemySpawnPosition.x] != .space && manhattanDistance(a: enemySpawnPosition, b: playerPosition) <= 15 {
            enemySpawnPosition = Point(x: Int.random(in: 0..<width), y: Int.random(in: 0..<height))
        }

        grid[enemySpawnPosition.y][enemySpawnPosition.x] = .enemySpawn

        return Level(width: width, height: height, grid: grid, difficulty: difficulty)
    }
}

func gameZoneToLevelPosition(coordinate: CGPoint) -> Point {
    Point(
        x: Int(((coordinate.x - Constants.cellSize.width / 2) / Constants.cellSize.width).rounded(.toNearestOrEven)),
        y: Int(((coordinate.y - Constants.cellSize.height / 2) / Constants.cellSize.height).rounded(.toNearestOrEven))
    )
}

func manhattanDistance(a: Point, b: Point) -> Int {
    abs(a.x - b.x) + abs(a.y - b.y)
}
