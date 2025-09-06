//
//  IndustriousUITests.swift
//  IndustriousUITests
//
//  Created by Johnny Villegas on 9/3/25.
//

import XCTest

final class IndustriousUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testSessionFlow() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Sessions"].tap()
        app.buttons["Start Session"].tap()
        app.buttons["Start"].tap()
        app.buttons["Stop"].tap()
    }

    @MainActor
    func testPlannerNavigation() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Planner"].tap()
        XCTAssertTrue(app.navigationBars["Planner"].exists)
    }

    @MainActor
    func testExportFlow() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["History"].tap()
        app.cells.element(boundBy: 0).tap()
        app.buttons["Export CSV"].tap()
    }

    @MainActor
    func testSettingsNavigation() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.navigationBars["Settings"].exists)
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
