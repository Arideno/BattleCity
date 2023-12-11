import Foundation

protocol ShootingStrategy {
    func shouldShoot(enemyPos: Point, enemyDir: Direction, level: Level) -> Bool
}
