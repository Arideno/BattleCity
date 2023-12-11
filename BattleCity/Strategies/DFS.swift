import Foundation

final class DFS: PathAlgorithm {
    func findPath(from: Point, to: Point, in grid: [[Cell]]) -> [Point] {
        var stack = [Point]()
        var visited = Set<Point>()
        var parent = [Point: Point]()
        stack.append(from)
        visited.insert(from)

        while !stack.isEmpty {
            let current = stack.removeLast()
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
                        stack.append(neighbor)
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
