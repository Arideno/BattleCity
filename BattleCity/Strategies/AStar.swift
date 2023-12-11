import Foundation

final class AStar: PathAlgorithm {
    func findPath(from: Point, to: Point, in grid: [[Cell]]) -> [Point] {
        var openSet = Set<Point>()
        var closedSet = Set<Point>()
        var parent = [Point: Point]()
        var gScore = [Point: Int]()
        var fScore = [Point: Int]()
        var current = from

        openSet.insert(from)
        gScore[from] = 0
        fScore[from] = heuristicCostEstimate(from: from, to: to)

        while !openSet.isEmpty {
            current = openSet.min(by: { fScore[$0]! < fScore[$1]! })!

            if current == to {
                return reconstructPath(from: from, to: to, parent: parent)
            }

            openSet.remove(current)
            closedSet.insert(current)

            let neighbors = [Point(x: current.x, y: current.y - 1),
                             Point(x: current.x, y: current.y + 1),
                             Point(x: current.x - 1, y: current.y),
                             Point(x: current.x + 1, y: current.y)]

            for neighbor in neighbors {
                if neighbor.x >= 0 && neighbor.x < grid[0].count && neighbor.y >= 0 && neighbor.y < grid.count && grid[neighbor.y][neighbor.x] != .wall {
                    if !closedSet.contains(neighbor) {
                        let tentativeGScore = gScore[current]! + 1
                        if !openSet.contains(neighbor) || tentativeGScore < gScore[neighbor]! {
                            parent[neighbor] = current
                            gScore[neighbor] = tentativeGScore
                            fScore[neighbor] = gScore[neighbor]! + heuristicCostEstimate(from: neighbor, to: to)
                            openSet.insert(neighbor)
                        }
                    }
                }
            }
        }

        return []
    }

    private func reconstructPath(from: Point, to: Point, parent: [Point: Point]) -> [Point] {
        var path = [Point]()
        var current = to
        while current != from {
            path.append(current)
            current = parent[current]!
        }
        path.append(from)
        return path.reversed()
    }

    private func heuristicCostEstimate(from: Point, to: Point) -> Int {
        return abs(from.x - to.x) + abs(from.y - to.y)
    }
}
