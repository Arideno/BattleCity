import Foundation

struct Level {
    let width: Int
    let height: Int
    var grid: [[Cell]]
    var playerPosition: Point
    let enemySpawnPoints: [Point]
    let difficulty: Difficulty

    mutating func movePlayerPosition(direction: Direction) {
        switch direction {
        case .up:
            if playerPosition.y + 1 < height && grid[playerPosition.y + 1][playerPosition.x] == .space {
                grid[playerPosition.y][playerPosition.x] = .space
                playerPosition.y += 1
                grid[playerPosition.y][playerPosition.x] = .player
            }
        case .down:
            if playerPosition.y - 1 >= 0 && grid[playerPosition.y - 1][playerPosition.x] == .space {
                grid[playerPosition.y][playerPosition.x] = .space
                playerPosition.y -= 1
                grid[playerPosition.y][playerPosition.x] = .player
            }
        case .left:
            if playerPosition.x - 1 >= 0 && grid[playerPosition.y][playerPosition.x - 1] == .space {
                grid[playerPosition.y][playerPosition.x] = .space
                playerPosition.x -= 1
                grid[playerPosition.y][playerPosition.x] = .player
            }
        case .right:
            if playerPosition.x + 1 < width && grid[playerPosition.y][playerPosition.x + 1] == .space {
                grid[playerPosition.y][playerPosition.x] = .space
                playerPosition.x += 1
                grid[playerPosition.y][playerPosition.x] = .player
            }
        }
    }
}

extension Level: CustomStringConvertible {
    var description: String {
        var string = ""
        for row in grid.reversed() {
            for cell in row {
                switch cell {
                case .wall:
                    string += "🟫"
                case .space:
                    string += "⬜️"
                case .base:
                    string += "🟩"
                case .player:
                    string += "🟦"
                }
            }
            string += "\n"
        }
        return string
    }
}
