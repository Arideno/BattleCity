import Foundation

struct Level {
    let width: Int
    let height: Int
    var grid: [[Cell]]
    var playerPosition: Point
    let enemySpawnPoints: [Point]
    let basePosition: Point
    let difficulty: Difficulty
}
