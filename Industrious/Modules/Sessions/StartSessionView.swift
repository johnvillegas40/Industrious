import SwiftUI

struct StartSessionView: View {
    @StateObject private var viewModel = SessionViewModel()
    @Environment(\.managedObjectContext) private var context

    var body: some View {
        VStack(spacing: Spacing.l) {
            HStack(spacing: Spacing.l) {
                Button(action: { if viewModel.counter > 0 { viewModel.counter -= 1 } }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.largeTitle)
                }
                Text("\(viewModel.counter)")
                    .font(Typography.heading(36))
                Button(action: { viewModel.counter += 1 }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                }
            }
            .padding(Spacing.m)

            HStack {
                ForEach(ActivityType.allCases, id: \.self) { type in
                    Text(label(for: type))
                        .font(Typography.caption())
                        .padding(.horizontal, Spacing.m)
                        .padding(.vertical, Spacing.s)
                        .background(viewModel.selectedActivity == type ? AppColor.primary : AppColor.secondary.opacity(0.3))
                        .foregroundStyle(viewModel.selectedActivity == type ? Color.white : AppColor.textPrimary)
                        .clipShape(Capsule())
                        .onTapGesture { viewModel.selectedActivity = type }
                }
            }

            Toggle("Credit Hour", isOn: $viewModel.isCreditHour)
                .padding(.horizontal, Spacing.m)

            Picker("Companion", selection: $viewModel.selectedCompanion) {
                ForEach(CompanionType.allCases, id: \.self) { companion in
                    Text(label(for: companion)).tag(companion)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, Spacing.m)

            TextField("Notes", text: $viewModel.notes, axis: .vertical)
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
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppColor.primary)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.horizontal, Spacing.m)
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

