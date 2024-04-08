import XCTest

final class DrawTests: XCTestCase {
    var value: Bool = false

    override func setUpWithError() throws {
        value = true
    }

    override func tearDownWithError() throws {
        value = false
    }

    func testExample() throws {
        XCTAssertTrue(value)
    }
}
