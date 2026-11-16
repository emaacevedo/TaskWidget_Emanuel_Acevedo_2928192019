import Foundation
import WidgetKit

struct TaskItem: Identifiable, Codable, Hashable {
    var id: UUID
    var title: String
    var isDone: Bool
    var createdAt: Date

    init(id: UUID = UUID(), title: String, isDone: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.createdAt = createdAt
    }
}

enum TaskStore {
    // Debe coincidir con el App Group de ambos targets en Signing & Capabilities.
    static let groupID = "group.com.example.taskwidget"
    private static let key = "savedTasksV1"

    static func load() -> [TaskItem] {
        guard let defaults = UserDefaults(suiteName: groupID),
              let data = defaults.data(forKey: key),
              let tasks = try? JSONDecoder().decode([TaskItem].self, from: data) else { return [] }
        return tasks
    }

    static func save(_ tasks: [TaskItem]) {
        guard let defaults = UserDefaults(suiteName: groupID),
              let data = try? JSONEncoder().encode(tasks) else { return }
        defaults.set(data, forKey: key)
        WidgetCenter.shared.reloadAllTimelines()
    }

    static func toggle(_ id: UUID) {
        var tasks = load()
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        tasks[index].isDone.toggle()
        save(tasks)
    }
}
