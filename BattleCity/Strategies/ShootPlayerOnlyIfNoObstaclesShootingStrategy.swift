import Foundation

final class ShootPlayerOnlyIfNoObstaclesShootingStrategy: ShootingStrategy {
    func shouldShoot(enemyPos: Point, enemyDir: Direction, playerPosition: Point, basePosition: Point, grid: [[Cell]]) -> Bool {
        if enemyPos.x == playerPosition.x && enemyDir == .down && enemyPos.y > playerPosition.y {
            for y in (playerPosition.y + 1)..<enemyPos.y {
                if grid[y][enemyPos.x] == .wall {
                    return false
                }
            }
            return true
        } else if enemyPos.x == playerPosition.x && enemyDir == .up && enemyPos.y < playerPosition.y {
            for y in (enemyPos.y + 1)..<playerPosition.y {
                if grid[y][enemyPos.x] == .wall {
                    return false
                }
            }
            return true
        } else if enemyPos.y == playerPosition.y && enemyDir == .right && enemyPos.x < playerPosition.x {
            for x in (enemyPos.x + 1)..<playerPosition.x {
                if grid[enemyPos.y][x] == .wall {
                    return false
                }
            }
            return true
        } else if enemyPos.y == playerPosition.y && enemyDir == .left && enemyPos.x > playerPosition.x {
            for x in (playerPosition.x + 1)..<enemyPos.x {
                if grid[enemyPos.y][x] == .wall {
                    return false
                }
            }
            return true
        }

        return false
    }
}
