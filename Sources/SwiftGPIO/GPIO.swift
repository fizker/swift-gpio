import WiringPi

/// Represents and controls a pin on the board.
///
/// It is constructed from the factory method ``GPIOController/gpio(pin:direction:value:)``.
public class GPIO {
	/// The physical pin that this is representing.
	public let pin: Pin

	/// The IO direction of the pin.
	public var direction: Direction {
		didSet { change(mode: direction.wpi, for: pin.gpioAddress) }
	}

	/// The current value of the pin.
	///
	/// If ``direction-swift.property`` is ``Direction-swift.enum/in``, this is whether or not the pin is receiving current.
	///
	/// If ``direction-swift.property`` is ``Direction-swift.enum/out``, this is whether or not the pin is emitting current.
	public var value: Value {
		get { .init(wpi: digitalRead(from: pin.gpioAddress)) }
		set { digitalWrite(value: newValue.wpi, to: pin.gpioAddress) }
	}

	/// The current pull value.
	///
	/// This only makes sense if ``direction-swift.property`` is ``Direction-swift.enum/in``.
	public var pull: Pull = .neither {
		didSet { change(pull: pull.wpi, for: pin.gpioAddress) }
	}

	init(pin: Pin, direction: Direction, value: Value) {
		self.pin = pin
		self.direction = direction
		self.value = value

		change(mode: direction.wpi, for: pin.gpioAddress)
	}

	deinit {
		// We turn off the pin when we don't want to use it anymore
		if direction == .out {
			value = .off
		}
	}

	/// The resting state of the pin.
	///
	/// If set to ``Pull-swift.enum/up`` and there is no input, then ``value-swift.property`` is ``Value-swift.enum/on``.
	public enum Pull {
		case up, down, neither
	}

	/// The value of the pin. ``on`` correspond to `1`, ``off`` corresponds to `0`.
	public enum Value {
		case on, off

		/// Creates a new Value based on the value of the given `Bool`.
		///
		/// `true` corresponds to ``on``, `false` corresponds to ``off``.
		public init(_ bool: Bool) {
			self = bool ? .on : .off
		}

		/// Toggles the value to be the opposite of the current value.
		public mutating func toggle() {
			switch self {
			case .on: self = .off
			case .off: self = .on
			}
		}

		/// Returns the opposite of the current value.
		public func toggled() -> Self {
			var val = self
			val.toggle()
			return val
		}
	}

	/// The direction of the IO operation.
	public enum Direction {
		case `in`, out
	}

	/// A pin on the board
	public enum Pin: Sendable {
		case p0, p1, p2, p3, p4, p5, p6, p7, p8, p9
		case p10, p11, p12, p13, p14, p15, p16, p17, p18, p19
		case p20, p21, p22, p23, p24, p25, p26, p27, p28, p29
		case p30, p31, p32, p33, p34, p35, p36, p37, p38, p39
		case p40, p41, p42, p43, p44, p45, p46, p47
	}
}

extension GPIO.Pin {
	var gpioAddress: Int32 {
		switch self {
		case .p0: 0
		case .p1: 1
		case .p2: 2
		case .p3: 3
		case .p4: 4
		case .p5: 5
		case .p6: 6
		case .p7: 7
		case .p8: 8
		case .p9: 9
		case .p10: 10
		case .p11: 11
		case .p12: 12
		case .p13: 13
		case .p14: 14
		case .p15: 15
		case .p16: 16
		case .p17: 17
		case .p18: 18
		case .p19: 19
		case .p20: 20
		case .p21: 21
		case .p22: 22
		case .p23: 23
		case .p24: 24
		case .p25: 25
		case .p26: 26
		case .p27: 27
		case .p28: 28
		case .p29: 29
		case .p30: 30
		case .p31: 31
		case .p32: 32
		case .p33: 33
		case .p34: 34
		case .p35: 35
		case .p36: 36
		case .p37: 37
		case .p38: 38
		case .p39: 39
		case .p40: 40
		case .p41: 41
		case .p42: 42
		case .p43: 43
		case .p44: 44
		case .p45: 45
		case .p46: 46
		case .p47: 47
		}
	}
}

extension GPIO.Pull {
	init(wpi: Pin.Pull) {
		switch wpi {
		case .off: self = .neither
		case .down: self = .down
		case .up: self = .up
		}
	}

	var wpi: Pin.Pull {
		switch self {
		case .up: return .up
		case .down: return .down
		case .neither: return .off
		}
	}
}

extension GPIO.Direction {
	init?(wpi: Pin.Mode) {
		switch wpi {
		case .input: self = .in
		case .output: self = .out
		case .pwmOutput: self = .out
		case .pwmMSOutput: self = .out
		case .pwmBALOutput: self = .out
		case .gpioClock: self = .out
		case .softwarePWMOutput: self = .out
		case .softwareToneOutput: self = .out
		case .pwmToneOutput: self = .out
		case .off: return nil
		}
	}

	var wpi: Pin.Mode {
		switch self {
		case .in: return .input
		case .out: return .output
		}
	}
}

extension GPIO.Value {
	init(wpi: Pin.Value) {
		switch wpi {
		case .low: self = .off
		case .high: self = .on
		}
	}
	var wpi: Pin.Value {
		switch self {
		case .off: return .low
		case .on: return .high
		}
	}
}
