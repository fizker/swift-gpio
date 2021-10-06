import XCTest
@testable import SwiftGPIO

final class WeakTests: XCTestCase {
	class Val {
		let onDeinit: () -> Void

		init(onDeinit: @escaping () -> Void) {
			self.onDeinit = onDeinit
		}

		deinit { onDeinit() }
	}

	func test() throws {
		var isDeinit = false
		var val: Val? = .init { isDeinit = true }

		let weak = Weak(val!)

		XCTAssertFalse(isDeinit)
		XCTAssertNotNil(weak.value)
		val = nil
		XCTAssertTrue(isDeinit)
		XCTAssertNil(weak.value)
	}
}
