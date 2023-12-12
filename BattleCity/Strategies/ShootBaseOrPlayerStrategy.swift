import Foundation

final class ShootBaseOrPlayerStrategy: ShootingStrategy {
    func shouldShoot(enemyPos: Point, enemyDir: Direction, playerPosition: Point, basePosition: Point, grid: [[Cell]]) -> Bool {
        if enemyPos.x == basePosition.x && enemyDir == .down && enemyPos.y > basePosition.y {
            return true
        } else if enemyPos.x == basePosition.x && enemyDir == .up && enemyPos.y < basePosition.y {
            return true
        } else if enemyPos.y == basePosition.y && enemyDir == .right && enemyPos.x < basePosition.x {
            return true
        } else if enemyPos.y == basePosition.y && enemyDir == .left && enemyPos.x > basePosition.x {
            return true
        } else if enemyPos.x == playerPosition.x && enemyDir == .down && enemyPos.y > playerPosition.y {
            return true
        } else if enemyPos.x == playerPosition.x && enemyDir == .up && enemyPos.y < playerPosition.y {
            return true
        } else if enemyPos.y == playerPosition.y && enemyDir == .right && enemyPos.x < playerPosition.x {
            return true
        } else if enemyPos.y == playerPosition.y && enemyDir == .left && enemyPos.x > playerPosition.x {
            return true
        }

        return false
    }
}
