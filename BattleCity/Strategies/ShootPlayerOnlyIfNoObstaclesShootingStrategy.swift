import Foundation

final class ShootPlayerOnlyIfNoObstaclesShootingStrategy: ShootingStrategy {
    func shouldShoot(enemyPos: Point, enemyDir: Direction, level: Level) -> Bool {
        if enemyPos.x == level.playerPosition.x && enemyDir == .down && enemyPos.y > level.playerPosition.y {
            for y in (level.playerPosition.y + 1)..<enemyPos.y {
                if level.grid[y][enemyPos.x] == .wall {
                    return false
                }
            }
            return true
        } else if enemyPos.x == level.playerPosition.x && enemyDir == .up && enemyPos.y < level.playerPosition.y {
            for y in (enemyPos.y + 1)..<level.playerPosition.y {
                if level.grid[y][enemyPos.x] == .wall {
                    return false
                }
            }
            return true
        } else if enemyPos.y == level.playerPosition.y && enemyDir == .right && enemyPos.x < level.playerPosition.x {
            for x in (enemyPos.x + 1)..<level.playerPosition.x {
                if level.grid[enemyPos.y][x] == .wall {
                    return false
                }
            }
            return true
        } else if enemyPos.y == level.playerPosition.y && enemyDir == .left && enemyPos.x > level.playerPosition.x {
            for x in (level.playerPosition.x + 1)..<enemyPos.x {
                if level.grid[enemyPos.y][x] == .wall {
                    return false
                }
            }
            return true
        }

        return false
    }
}
