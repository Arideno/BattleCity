import Foundation

final class ShootBaseOrPlayerStrategy: ShootingStrategy {
    func shouldShoot(enemyPos: Point, enemyDir: Direction, level: Level) -> Bool {
        if enemyPos.x == level.basePosition.x && enemyDir == .down && enemyPos.y > level.basePosition.y {
            return true
        } else if enemyPos.x == level.basePosition.x && enemyDir == .up && enemyPos.y < level.basePosition.y {
            return true
        } else if enemyPos.y == level.basePosition.y && enemyDir == .right && enemyPos.x < level.basePosition.x {
            return true
        } else if enemyPos.y == level.basePosition.y && enemyDir == .left && enemyPos.x > level.basePosition.x {
            return true
        } else if enemyPos.x == level.playerPosition.x && enemyDir == .down && enemyPos.y > level.playerPosition.y {
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
