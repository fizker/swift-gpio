import Foundation

/// Configures a pin to oscillate between `on` and `off`. This is generally used to have a pin be represented at values between `0` and `1`.
///
/// Since pins are binary in nature, they are always either ``GPIO/Value-swift.enum/on`` or ``GPIO/Value-swift.enum/off``.
/// But sometimes it is desirable to represent the output in values between `0` and `1`, for example to have
/// a lamp at 50% brightness or control the speed of a motor.
///
/// The PWM supports this by oscillating the output between `0` and `1`. This is done by defining the size of
/// a cycle of `on` and `off`, and then informing the PWM how long the `on` state should be.
///
/// If the PWM has been configured with a cycle of `10ms` (`range: 100` or `100hz`), then a `duty` of `10`
/// would mean that the PWM is on for `1ms` and then off for `9ms`.
///
/// That effectively means that the pin would be `on` for `10%`, so an attached lamp would be at `10%` of
/// max brightness or a motor would run at `10%` max speed.
///
/// To create a software-implemention of a PWM, see
/// ``GPIOController/softwarePulseWidthModulation(for:duty:range:)`` or
/// ``GPIOController/softwarePulseWidthModulation(for:duty:hz:)``.
public protocol PulseWidthModulation {
	/// The amount of time that the pulse is ``GPIO/Value-swift.enum/on``.
	///
	/// This value maps to `duty * 100µs` and interacts with the cycle of the PWM.
	///
	/// If the PWM has been configured with a cycle of `10ms` (`range: 100`), then a `duty` of `10`
	/// would mean that the PWM is on for `1ms` and then off for `9ms`.
	var duty: Float { get set }
}

class SoftwarePulseWidthModulation: PulseWidthModulation {
	public var duty: Float {
		didSet {
			if duty < 0 {
				duty = 0
			} else if duty > Float(range) {
				duty = Float(range)
			}
		}
	}

	let gpio: GPIO
	let range: UInt32
	var thread: Thread?

	fileprivate init(gpio: GPIO, duty: Float = 0, range: UInt32 = 100) {
		self.gpio = gpio

		self.duty = duty
		self.range = range

		self.thread = nil

		thread = .init(block: run)
		thread?.start()
	}

	func run() {
		while(true) {
			let mark = UInt32(duty)
			let space = range - mark

			if mark != 0 {
				gpio.value = .on
				sleep(µs: mark * 100)
			}

			if space != 0 {
				gpio.value = .off
				sleep(µs: space * 100)
			}
		}
	}
}

public extension GPIOController {
	/// Configures a pin for a software-implemented ``PulseWidthModulation``.
	///
	/// Some boards support a few number of hardware PWMs on certain pins. This allows any pin to be
	/// used as a PWM, which also allows more PWMs that are available as dedicated hardware.
	///
	/// The range and duty interacts so that if the `range` is `100` and the `duty` is `30`, then the pin
	/// will be ``GPIO/Value-swift.enum/on`` 30% of the time.
	///
	/// - parameter pin: The pin to configure.
	/// - parameter duty: The initial value. See ``PulseWidthModulation/duty`` for a detailed
	///   rundown of what the value represents.
	/// - parameter range: The cycle-time of the PWM. This is the amount of time that passes between
	///   each ``GPIO/Value-swift.enum/on`` cycle. The cycle is `range * 100µs` long, so a
	///   value of `10` is `1ms`, the default value of `100` is `10ms` and a value of `200` is `20ms`.
	///   See ``PulseWidthModulation`` for more details.
	/// - throws: This can throw the same errors as ``gpio(pin:direction:value:)``.
	///   See that function for more details.
	func softwarePulseWidthModulation(for pin: GPIO.Pin, duty: Float = 0, range: UInt32 = 100) throws -> PulseWidthModulation {
		let gpio = try self.gpio(pin: pin, direction: .out)
		return SoftwarePulseWidthModulation(gpio: gpio, duty: duty, range: range)
	}

	/// Configures a pin for a software-implemented ``PulseWidthModulation``.
	///
	/// Some boards support a few number of hardware PWMs on certain pins. This allows any pin to be
	/// used as a PWM, which also allows more PWMs that are available as dedicated hardware.
	///
	/// - parameter pin: The pin to configure.
	/// - parameter duty: The initial value. See ``PulseWidthModulation/duty`` for a detailed
	///   rundown of what the value represents.
	/// - parameter hz: The frequency of the PWM. This represents how many times a second that
	///   the PWM cycles between ``GPIO/Value-swift.enum/on`` and ``GPIO/Value-swift.enum/off``.
	///   See ``PulseWidthModulation`` for more details.
	/// - throws: This can throw the same errors as ``gpio(pin:direction:value:)``.
	///   See that function for more details.
	func softwarePulseWidthModulation(for pin: GPIO.Pin, duty: Float = 0, hz: UInt32) throws -> PulseWidthModulation {
		let gpio = try self.gpio(pin: pin, direction: .out)
		return SoftwarePulseWidthModulation(gpio: gpio, duty: duty, range: 10_000 / hz)
	}
}
