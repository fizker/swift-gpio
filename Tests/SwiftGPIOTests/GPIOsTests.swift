import XCTest
@testable import SwiftGPIO
@testable import SwiftyGPIO

class TestGPIO: SwiftyGPIO_GPIO {
}

final class GPIOsTests: XCTestCase {
	func test__gpio__gpioIsKeptAlive_pinIsUsed__throws() throws {
		let gpios = GPIOs(board: .chip, gpios: [
			.P0: TestGPIO(name: "foo", id: 0),
		])
		let gpio = try gpios.gpio(pin: .p0, direction: .in, value: .off)
		// Silencing unused-var warning. We need to keep this var alive for the weak-thing to work
		_ = gpio

		XCTAssertThrowsError(try gpios.gpio(pin: .p0, direction: .in, value: .off)) { error in
			guard let e = error as? GPIOs.E, case let GPIOs.E.pinInUse(pin) = e
			else {
				XCTFail("Unexpected error: \(error)")
				return
			}

			XCTAssertEqual(pin, .p0)
		}
	}

	func test__gpio__gpioIsDeinit__createsAgain() throws {
		let gpios = GPIOs(board: .chip, gpios: [
			.P0: TestGPIO(name: "foo", id: 0),
		])

		var gpio: SwiftGPIO.GPIO? = try gpios.gpio(pin: .p0, direction: .in, value: .off)
		// Silencing unused-var warning
		_ = gpio

		// Setting to nil triggers deinit
		gpio = nil

		_ = try gpios.gpio(pin: .p0, direction: .in, value: .off)
	}
}
