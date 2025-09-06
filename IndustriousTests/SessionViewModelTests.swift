import Testing
@testable import Industrious
@_implementationOnly import CoreData
struct SessionViewModelTests {
    @MainActor
    @Test func timerIncrements() async throws {
        let vm = SessionViewModel()
        vm.start()
        try await Task.sleep(nanoseconds: 1_000_000_000)
        vm.reset()
        #expect(vm.elapsed >= 1)
    }

    @Test func counterUpdates() async throws {
        let vm = SessionViewModel()
        vm.counter = 0
        vm.counter += 1
        #expect(vm.counter == 1)
    }
}

