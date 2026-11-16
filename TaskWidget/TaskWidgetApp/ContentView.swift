import SwiftUI

struct ContentView: View {
    @State private var tasks: [TaskItem] = []
    @State private var newTitle = ""
    @State private var showCompleted = true

    private var completed: Int { tasks.filter(\.isDone).count }
    private var visibleTasks: [TaskItem] { tasks.filter { showCompleted || !$0.isDone } }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Organiza tu día").font(.largeTitle.bold())
                    Text("\(completed) de \(tasks.count) tareas completadas")
                        .foregroundStyle(.secondary)
                    ProgressView(value: Double(completed), total: Double(max(tasks.count, 1)))
                        .tint(.indigo)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.indigo.opacity(0.08), in: RoundedRectangle(cornerRadius: 18))

                HStack {
                    TextField("Nueva tarea...", text: $newTitle)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.done)
                        .onSubmit(addTask)
                    Button(action: addTask) {
                        Image(systemName: "plus.circle.fill").font(.title2)
                    }
                    .disabled(newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .accessibilityLabel("Agregar tarea")
                }
                Toggle("Mostrar completadas", isOn: $showCompleted)
                    .font(.subheadline)

                if visibleTasks.isEmpty {
                    ContentUnavailableView("Sin tareas", systemImage: "checkmark.circle",
                        description: Text("Agrega una tarea para comenzar."))
                } else {
                    List {
                        ForEach(visibleTasks) { task in
                            HStack(spacing: 12) {
                                Button { toggle(task.id) } label: {
                                    Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(task.isDone ? .green : .indigo)
                                        .font(.title2)
                                }
                                .buttonStyle(.plain)
                                Text(task.title)
                                    .strikethrough(task.isDone)
                                    .foregroundStyle(task.isDone ? .secondary : .primary)
                                Spacer()
                            }
                            .padding(.vertical, 5)
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(.plain)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .navigationTitle("TaskWidget")
            .toolbar { EditButton() }
            .onAppear(perform: refresh)
            .scenePhaseRefresh(refresh)
        }
    }

    private func refresh() { tasks = TaskStore.load() }
    private func addTask() {
        let title = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        tasks.insert(TaskItem(title: title), at: 0)
        TaskStore.save(tasks)
        newTitle = ""
    }
    private func toggle(_ id: UUID) {
        TaskStore.toggle(id)
        refresh()
    }
    private func delete(at offsets: IndexSet) {
        let ids = offsets.map { visibleTasks[$0].id }
        tasks.removeAll { ids.contains($0.id) }
        TaskStore.save(tasks)
    }
}

private struct ScenePhaseRefresh: ViewModifier {
    @Environment(\.scenePhase) private var phase
    let refresh: () -> Void
    func body(content: Content) -> some View {
        content.onChange(of: phase) { _, newPhase in
            if newPhase == .active { refresh() }
        }
    }
}
private extension View {
    func scenePhaseRefresh(_ refresh: @escaping () -> Void) -> some View {
        modifier(ScenePhaseRefresh(refresh: refresh))
    }
}
