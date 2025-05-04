import WiringPi

final class Weak<T: AnyObject> {
	weak var value: T?

	init(_ value: T) {
		self.value = value
	}
}

/// A controller for a board. It is responsible for creating and configuring ``GPIO`` instances.
public class GPIOController {
	/// Errors that might be thrown by the controller.
	public enum Error: Swift.Error {
		/// Thrown when requesting a pin that is already in use. See ``GPIOController/gpio(pin:direction:value:)`` for more details.
		case pinInUse(GPIO.Pin)
		/// Thrown when requesting a pin that does not exist in the current ``GPIOController/board``. See ``GPIOController/gpio(pin:direction:value:)`` for more details.
		case pinNotFound(GPIO.Pin)
	}

	/// The board that this controller is controlling.
	public let board: Board

	var gpios: [GPIO.Pin: Weak<GPIO>] = [:]

	/// Creates a controller for the given board.
	public init(board: Board) {
		self.board = board
		setupBoard(addressMode: .gpio)
	}

	/// Returns a ``GPIO`` matching the given pin and direction.
	///
	/// Note that it is considered an error to request the same pin multiple times. When the returned pin is released, it is safe to request it anew.
	///
	/// - parameter pin: The pin to configure.
	/// - parameter direction: The direction that the pin will be using.
	/// - parameter value: The initial value. This is a convenience parameter as the value can be changed later.
	/// - throws: If the requested pin is already in use, this will throw ``Error/pinInUse(_:)``. If a pin is requested that the current board does not have, it will throw ``Error/pinNotFound(_:)``.
	/// - returns: A configured ``GPIO`` instance.
	public func gpio(pin: GPIO.Pin, direction: GPIO.Direction, value: GPIO.Value = .off) throws(Error) -> GPIO {
		if let wrapper = gpios[pin] {
			guard wrapper.value == nil
			else { throw Error.pinInUse(pin) }
			gpios[pin] = nil
		}

		let gpio = GPIO(pin: pin, direction: direction, value: value)

		gpios[pin] = .init(gpio)

		return gpio
	}
}
