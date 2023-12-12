import Foundation

final class ShootPlayerStrategy: ShootingStrategy {
    func shouldShoot(enemyPos: Point, enemyDir: Direction, playerPosition: Point, basePosition: Point, grid: [[Cell]]) -> Bool {
        if enemyPos.x == playerPosition.x && enemyDir == .down && enemyPos.y > playerPosition.y {
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
