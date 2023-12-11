import Foundation

final class BFS: PathAlgorithm {
    func findPath(from: Point, to: Point, in grid: [[Cell]]) -> [Point] {
        var queue = [Point]()
        var visited = Set<Point>()
        var parent = [Point: Point]()
        queue.append(from)
        visited.insert(from)

        while !queue.isEmpty {
            let current = queue.removeFirst()
            if current == to {
                return reconstructPath(from: from, to: to, parent: parent)
            }

            let neighbors = [Point(x: current.x, y: current.y - 1),
                             Point(x: current.x, y: current.y + 1),
                             Point(x: current.x - 1, y: current.y),
                             Point(x: current.x + 1, y: current.y)]

            for neighbor in neighbors {
                if neighbor.x >= 0 && neighbor.x < grid[0].count && neighbor.y >= 0 && neighbor.y < grid.count {
                    if !visited.contains(neighbor) && grid[neighbor.y][neighbor.x] != .wall {
                        queue.append(neighbor)
                        visited.insert(neighbor)
                        parent[neighbor] = current
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
}
