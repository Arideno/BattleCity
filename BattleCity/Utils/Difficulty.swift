import Foundation

enum Difficulty {
    case easy
    case normal
    case hard

    var scoreForEnemy: Int {
        switch self {
        case .easy: 5
        case .normal: 10
        case .hard: 20
        }
    }

    var pathFindingAlgorithm: PathAlgorithm {
        switch self {
        case .easy, .normal: BFS()
        case .hard: AStar()
        }
    }

    var shootingStrategy: ShootingStrategy {
        switch self {
        case .easy: ShootPlayerOnlyIfNoObstaclesShootingStrategy()
        case .normal: ShootPlayerStrategy()
        case .hard: ShootBaseOrPlayerStrategy()
        }
    }

    var enemyTypes: [EnemyType] {
        switch self {
        case .easy: Array(repeating: .small, count: 3)
        case .normal: Array(repeating: .small, count: 3) + Array(repeating: .big, count: 2)
        case .hard: Array(repeating: .small, count: 2) + Array(repeating: .big, count: 5)
        }
    }
}
