import Foundation

final class ShootPlayerStrategy: ShootingStrategy {
    func shouldShoot(enemyPos: Point, enemyDir: Direction, level: Level) -> Bool {
        if enemyPos.x == level.playerPosition.x && enemyDir == .down && enemyPos.y > level.playerPosition.y {
            return true
        } else if enemyPos.x == level.playerPosition.x && enemyDir == .up && enemyPos.y < level.playerPosition.y {
            return true
        } else if enemyPos.y == level.playerPosition.y && enemyDir == .right && enemyPos.x < level.playerPosition.x {
            return true
        } else if enemyPos.y == level.playerPosition.y && enemyDir == .left && enemyPos.x > level.playerPosition.x {
            return true
        }

        return false
    }
}
