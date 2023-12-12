import Foundation

enum EnemyType {
    case small, big

    func create(gameZone: GameZone) -> Enemy {
        switch self {
        case .small: return EnemySmall(gameZone: gameZone)
        case .big: return EnemyBig(gameZone: gameZone)
        }
    }
}
