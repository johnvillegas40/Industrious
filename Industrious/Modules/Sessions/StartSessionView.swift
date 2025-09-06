import SwiftUI
import CoreData
import UIKit

struct StartSessionView: View {
    @StateObject private var viewModel: SessionViewModel
    @Environment(\.managedObjectContext) private var context
    @Environment(\.undoManager) private var undoManager
    @State private var showingStudyPicker = false

    init(study: Study? = nil) {
        let initialStudies = study.map { Set([$0]) } ?? []
        _viewModel = StateObject(wrappedValue: SessionViewModel(studies: initialStudies))
    }

    private func undoBinding<T>(_ keyPath: ReferenceWritableKeyPath<SessionViewModel, T>) -> Binding<T> {
        Binding(
            get: { viewModel[keyPath: keyPath] },
            set: { newValue in
                let oldValue = viewModel[keyPath: keyPath]
                viewModel[keyPath: keyPath] = newValue
                undoManager?.registerUndo(withTarget: viewModel) { vm in
                    vm[keyPath: keyPath] = oldValue
                }
            }
        )
    }

    private func incrementCounter() {
        let oldValue = viewModel.counter
        viewModel.counter += 1
        undoManager?.registerUndo(withTarget: viewModel) { vm in
            vm.counter = oldValue
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    private func decrementCounter() {
        guard viewModel.counter > 0 else { return }
        let oldValue = viewModel.counter
        viewModel.counter -= 1
        undoManager?.registerUndo(withTarget: viewModel) { vm in
            vm.counter = oldValue
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    var body: some View {
        VStack(spacing: Spacing.l) {
            Picker("Role", selection: undoBinding(\.selectedRole)) {
                ForEach(Role.allCases, id: \.self) { role in
                    Text(role.displayName).tag(role)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, Spacing.m)

            if viewModel.selectedRole.allowsCredit {
                Toggle("Credit Hour", isOn: undoBinding(\.isCreditHour))
                    .padding(.horizontal, Spacing.m)

                if viewModel.isCreditHour {
                    HStack(spacing: Spacing.l) {
                        Button(action: decrementCounter) {
                            Image(systemName: "minus.circle.fill")
                                .font(.largeTitle)
                                .frame(width: 44, height: 44)
                                .accessibilityLabel("Decrease credit minutes")
                        }
                        Text("\(viewModel.counter)")
                            .font(Typography.heading(36))
                        Button(action: incrementCounter) {
                            Image(systemName: "plus.circle.fill")
                                .font(.largeTitle)
                                .frame(width: 44, height: 44)
                                .accessibilityLabel("Increase credit minutes")
                        }
                    }
                    .padding(Spacing.m)

                    if viewModel.counter > viewModel.selectedRole.creditAllowance {
                        Text("Credit minutes exceed allowance")
                            .font(Typography.caption())
                            .foregroundColor(.orange)
                            .padding(.horizontal, Spacing.m)
                    }

                    TextField("Assignment Tag", text: undoBinding(\.assignmentTag))
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, Spacing.m)
                }
            }

            HStack {
                ForEach(ActivityType.allCases, id: \.self) { type in
                    Button(action: {
                        let oldValue = viewModel.selectedActivity
                        viewModel.selectedActivity = type
                        undoManager?.registerUndo(withTarget: viewModel) { vm in
                            vm.selectedActivity = oldValue
                        }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }) {
                        Text(label(for: type))
                            .font(Typography.caption())
                            .padding(.horizontal, Spacing.m)
                            .padding(.vertical, Spacing.s)
                            .frame(minWidth: 44, minHeight: 44)
                            .background(viewModel.selectedActivity == type ? AppColor.primary : AppColor.secondary.opacity(0.3))
                            .foregroundStyle(viewModel.selectedActivity == type ? Color.white : AppColor.textPrimary)
                            .clipShape(Capsule())
                    }
                    .accessibilityLabel(label(for: type))
                }
            }

            Picker("Companion", selection: undoBinding(\.selectedCompanion)) {
                ForEach(CompanionType.allCases, id: \.self) { companion in
                    Text(label(for: companion)).tag(companion)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, Spacing.m)

            Button(action: { showingStudyPicker = true }) {
                HStack {
                    Text(viewModel.selectedStudies.isEmpty ? "Select Studies" : viewModel.selectedStudies.map { $0.title }.sorted().joined(separator: ", "))
                        .foregroundStyle(AppColor.textPrimary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(AppColor.secondary)
                }
                .padding(.horizontal, Spacing.m)
                .frame(minHeight: 44)
            }
            .sheet(isPresented: $showingStudyPicker) {
                StudyPicker(selection: undoBinding(\.selectedStudies))
                    .environment(\.managedObjectContext, context)
            }

            TextField("Notes", text: undoBinding(\.notes), axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, Spacing.m)

            Text(viewModel.timeString)
                .font(Typography.heading(36))
                .padding(.top, Spacing.l)

            Button(viewModel.isRunning ? "Stop" : "Start") {
                if viewModel.isRunning {
                    viewModel.stop(context: context)
                } else {
                    viewModel.start()
                }
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
            .frame(maxWidth: .infinity, minHeight: 44)
            .padding()
            .background(AppColor.primary)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.horizontal, Spacing.m)
            .accessibilityLabel(viewModel.isRunning ? "Stop session" : "Start session")
        }
        .padding(.vertical, Spacing.l)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
    }

    private func label(for type: ActivityType) -> String {
        switch type {
        case .study: return "Study"
        case .breakTime: return "Break"
        case .meeting: return "Meeting"
        case .other: return "Other"
        }
    }

    private func label(for companion: CompanionType) -> String {
        switch companion {
        case .solo: return "Solo"
        case .friend: return "Friend"
        case .group: return "Group"
        }
    }
}

#Preview {
    StartSessionView()
}

