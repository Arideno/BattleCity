import Foundation

protocol PathAlgorithm {
    func findPath(from: Point, to: Point, in grid: [[Cell]]) -> [Point]
}
