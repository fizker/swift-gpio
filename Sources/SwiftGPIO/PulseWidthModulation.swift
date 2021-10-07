import Foundation
import SwiftyGPIO

public protocol PulseWidthModulation {
	var duty: Float { get set }
}

class SoftwarePulseWidthModulation: PulseWidthModulation {
	public var duty: Float

	let gpio: GPIO
	let range: UInt32
	var thread: Thread?

	fileprivate convenience init(gpio: GPIO, duty: Float = 0, hz: UInt32) {
		self.init(gpio: gpio, duty: duty, range: hz * 4)
	}

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

public extension GPIOs {
	func softwarePulseWidthModulation(for pin: GPIO.Pin, duty: Float = 0, range: UInt32 = 100) throws -> PulseWidthModulation {
		let gpio = try self.gpio(pin: pin, direction: .out)
		return SoftwarePulseWidthModulation(gpio: gpio, duty: duty, range: range)
	}

	func softwarePulseWidthModulation(for pin: GPIO.Pin, duty: Float = 0, hz: UInt32) throws -> PulseWidthModulation {
		let gpio = try self.gpio(pin: pin, direction: .out)
		return SoftwarePulseWidthModulation(gpio: gpio, duty: duty, hz: hz)
	}
}
