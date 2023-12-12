import Foundation

protocol ShootingStrategy {
    func shouldShoot(enemyPos: Point, enemyDir: Direction, playerPosition: Point, basePosition: Point, grid: [[Cell]]) -> Bool
}
