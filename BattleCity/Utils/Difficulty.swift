import Foundation

enum Difficulty {
    case easy
    case normal
    case hard

    var enemyCount: Int {
        switch self {
        case .easy: 3
        case .normal: 5
        case .hard: 7
        }
    }

    var scoreForEnemy: Int {
        switch self {
        case .easy: 5
        case .normal: 10
        case .hard: 20
        }
    }
}
