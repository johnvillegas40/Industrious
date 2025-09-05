import SwiftUI
import Charts
import CoreData

struct DailyStat: Identifiable {
    let id = UUID()
    let date: Date
    let value: Int
}

struct ProgressRingView: View {
    var progress: Double
    var body: some View {
        ZStack {
            Circle()
                .stroke(AppColor.secondary.opacity(0.3), lineWidth: 20)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(AppColor.primary, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text("\(Int(progress * 100))%")
                .font(Typography.heading())
                .foregroundStyle(AppColor.textPrimary)
        }
    }
}

struct WeeklyBarChartView: View {
    var data: [DailyStat]
    var body: some View {
        Chart(data) { item in
            BarMark(
                x: .value("Day", item.date, unit: .day),
                y: .value("Sessions", item.value)
            )
            .foregroundStyle(AppColor.primary)
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXAxis {
            AxisMarks(values: data.map { $0.date }) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel(date, format: .dateTime.weekday(.narrow))
                }
            }
        }
    }
}

struct CountersGridView: View {
    var totals: [CounterKind: Int64]
    private var items: [(CounterKind, Int64)] {
        CounterKind.allCases.map { ($0, totals[$0] ?? 0) }
    }
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        LazyVGrid(columns: columns, spacing: Spacing.m) {
            ForEach(items, id: \.0) { kind, value in
                VStack {
                    Text(kind.rawValue.capitalized)
                        .font(Typography.caption())
                        .foregroundStyle(AppColor.textSecondary)
                    Text("\(value)")
                        .font(Typography.heading())
                        .foregroundStyle(AppColor.textPrimary)
                }
                .frame(maxWidth: .infinity, minHeight: 80)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 1)
            }
        }
    }
}

struct SPFMPanel: View {
    @FetchRequest(
        entity: DayOff.entity(),
        sortDescriptors: []
    ) private var days: FetchedResults<DayOff>
    private var daysOffCount: Int { days.filter { !$0.isConvention }.count }
    private var conventionCount: Int { days.filter { $0.isConvention }.count }
    var body: some View {
        HStack {
            VStack {
                Text("Days Off")
                    .font(Typography.caption())
                    .foregroundStyle(AppColor.textSecondary)
                Text("\(daysOffCount)")
                    .font(Typography.heading())
                    .foregroundStyle(AppColor.textPrimary)
            }
            .frame(maxWidth: .infinity)
            VStack {
                Text("Convention")
                    .font(Typography.caption())
                    .foregroundStyle(AppColor.textSecondary)
                Text("\(conventionCount)")
                    .font(Typography.heading())
                    .foregroundStyle(AppColor.textPrimary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}

struct StartSessionCard: View {
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.s) {
                    Text("Start Session")
                        .font(Typography.heading())
                        .foregroundStyle(AppColor.textPrimary)
                    Text("Begin tracking now")
                        .font(Typography.caption())
                        .foregroundStyle(AppColor.textSecondary)
                }
                Spacer()
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(AppColor.primary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 2)
        }
    }
}

