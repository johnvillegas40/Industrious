import Testing
@testable import Industrious
@_implementationOnly import CoreData
struct AggregationTests {
    @MainActor
    @Test func sessionDurationsByMonth() async throws {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext
        SampleData.insertSampleData(context: context)
        let result = try Aggregator.sessionDurationsByMonth(context: context)
        #expect(result[MonthKey(year: 2024, month: 1)] == 3600)
        #expect(result[MonthKey(year: 2024, month: 2)] == 7200)
    }

    @MainActor
    @Test func counterTotalsByMonth() async throws {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext
        SampleData.insertSampleData(context: context)
        let result = try CountersAggregator.monthlyTotals(context: context, kind: .session)
        #expect(result[MonthKey(year: 2024, month: 1)] == 3)
        #expect(result[MonthKey(year: 2024, month: 2)] == 5)
    }
}

