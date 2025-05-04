import WiringPi

private typealias PWM = WiringPi.HardwarePulseWidthModulation

public enum PulseWidthModulationError: Error {
	case notFound
	case inUse
}

private enum HardwarePin: CaseIterable {
	case gpio12, gpio18
	case gpio13, gpio19

	var pin: GPIO.Pin {
		switch self {
		case .gpio12: .p12
		case .gpio13: .p13
		case .gpio18: .p18
		case .gpio19: .p19
		}
	}

	var channel: Channel {
		switch self {
		case .gpio12, .gpio18: .one
		case .gpio13, .gpio19: .two
		}
	}

	enum Channel {
		case one, two
	}
}

public class HardwarePulseWidthModulationController {
	private var channelsInUse: [HardwarePin.Channel: Weak<HardwarePulseWidthModulation>] = [:]

	init() {
	}

	public func pwm(named pin: GPIO.Pin) throws(PulseWidthModulationError) -> PulseWidthModulation {
		guard let hardwarePin = HardwarePin.allCases.first(where: { $0.pin == pin })
		else { throw .notFound }

		if let current = channelsInUse[hardwarePin.channel] {
			if current.value == nil {
				channelsInUse[hardwarePin.channel] = nil
			} else {
				throw .inUse
			}
		}

		let pwm = HardwarePulseWidthModulation(pin: hardwarePin)
		channelsInUse[hardwarePin.channel] = .init(pwm)

		return pwm
	}
}

public class HardwarePulseWidthModulation: PulseWidthModulation {
	private let pin: HardwarePin

	var address: Pin.Address { pin.pin.gpioAddress }

	public var duty: Float = 0 {
		didSet {
			PWM.write(value: Int32(1024 * duty / 100), to: address)
		}
	}

	fileprivate init(pin: HardwarePin) {
		self.pin = pin
		PWM.write(value: 0, to: address)
		PWM.set(range: 1024)
		change(mode: .pwmOutput, for: address)
	}

	deinit {
		PWM.write(value: 0, to: address)
		PWM.write(toneFrequency: 0, to: address)
		change(mode: .off, for: address)
	}
}
