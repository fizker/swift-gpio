import SwiftyGPIO

final class Weak<T: AnyObject> {
	weak var value: T?

	init(_ value: T) {
		self.value = value
	}
}

public class GPIOs {
	enum E: Error {
		case pinInUse(GPIO.Pin)
		case pinNotFound(GPIO.Pin)
	}

	public let board: Board
	var swiftyGPIOs: [GPIOName: SwiftyGPIO_GPIO]
	var gpios: [GPIO.Pin: Weak<GPIO>] = [:]

	// Internal init used by tests
	init(board: Board, gpios: [GPIOName: SwiftyGPIO_GPIO]) {
		self.board = board
		self.swiftyGPIOs = gpios
	}

	public init(board: Board) {
		self.board = board
		self.swiftyGPIOs = SwiftyGPIO.GPIOs(for: board.swifty)
	}

	public func gpio(pin: GPIO.Pin, direction: GPIO.Direction, value: GPIO.Value = .off) throws -> GPIO {
		if let wrapper = gpios[pin] {
			guard wrapper.value == nil
			else { throw E.pinInUse(pin) }
			gpios[pin] = nil
		}

		guard let sg = swiftyGPIOs[pin.swifty]
		else { throw E.pinNotFound(pin) }

		let gpio = GPIO(gpio: sg, pin: pin, direction: direction, value: value)

		gpios[pin] = .init(gpio)

		return gpio
	}
}
