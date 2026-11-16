import WidgetKit
import SwiftUI
import AppIntents

struct TaskEntry: TimelineEntry {
    let date: Date
    let tasks: [TaskItem]
}

struct TaskProvider: TimelineProvider {
    func placeholder(in context: Context) -> TaskEntry {
        TaskEntry(date: .now, tasks: [TaskItem(title: "Estudiar SwiftUI"), TaskItem(title: "Preparar exposición")])
    }
    func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> Void) {
        completion(TaskEntry(date: .now, tasks: TaskStore.load()))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<TaskEntry>) -> Void) {
        let entry = TaskEntry(date: .now, tasks: TaskStore.load())
        completion(Timeline(entries: [entry], policy: .never))
    }
}

struct ToggleTaskIntent: AppIntent {
    static var title: LocalizedStringResource = "Completar o reabrir tarea"
    static var description = IntentDescription("Cambia el estado de una tarea desde el widget")
    static var openAppWhenRun: Bool = false

    @Parameter(title: "ID de tarea") var taskID: String

    init() {}
    init(taskID: String) { self.taskID = taskID }

    func perform() async throws -> some IntentResult {
        if let id = UUID(uuidString: taskID) { TaskStore.toggle(id) }
        return .result()
    }
}

struct TaskWidgetView: View {
    let entry: TaskEntry
    private var pending: [TaskItem] { Array(entry.tasks.filter { !$0.isDone }.prefix(3)) }

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack {
                Label("Mis tareas", systemImage: "checklist")
                    .font(.headline).foregroundStyle(.indigo)
                Spacer()
                Text("\(entry.tasks.filter { !$0.isDone }.count) pendientes")
                    .font(.caption2).foregroundStyle(.secondary)
            }
            if pending.isEmpty {
                Spacer()
                Text("¡Todo al día! 🎉").font(.subheadline)
                Spacer()
            } else {
                ForEach(pending) { task in
                    HStack(spacing: 8) {
                        Button(intent: ToggleTaskIntent(taskID: task.id.uuidString)) {
                            Image(systemName: "circle").foregroundStyle(.indigo)
                        }
                        .buttonStyle(.plain)
                        Text(task.title).font(.caption).lineLimit(1)
                        Spacer(minLength: 0)
                    }
                }
                Spacer(minLength: 0)
            }
        }
        .containerBackground(.background, for: .widget)
    }
}

struct TaskWidget: Widget {
    let kind = "TaskWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TaskProvider()) { entry in
            TaskWidgetView(entry: entry)
        }
        .configurationDisplayName("Tareas pendientes")
        .description("Consulta y completa tus tareas desde la pantalla de inicio.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

@main
struct TaskWidgetBundle: WidgetBundle {
    var body: some Widget { TaskWidget() }
}
