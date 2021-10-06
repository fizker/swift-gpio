import SwiftyGPIO

/// This is constructed from the factory method on `GPIOs`.
public class GPIO {
	public let pin: Pin
	public var direction: Direction {
		didSet { gpio.direction = direction.swifty }
	}
	public var value: Value {
		get { .init(swifty: gpio.value) }
		set { gpio.value = newValue.swifty }
	}
	public var pull: Pull {
		get { gpio.pull }
		set { gpio.pull = newValue }
	}
	var gpio: SwiftyGPIO_GPIO

	init(gpio: SwiftyGPIO_GPIO, pin: Pin, direction: Direction, value: Value) {
		self.gpio = gpio
		self.pin = pin
		self.direction = direction
		self.value = value
	}

	deinit {
		// We turn off the pin when we don't want to use it anymore
		if direction == .out {
			value = .off
		}
	}

	public typealias Pull = GPIOPull

	/// The value of the pin. `on` correspond to `1`, `off` corresponds to `0`.
	public enum Value {
		case on, off
	}

	/// The direction of the IO operation.
	public enum Direction {
		case `in`, out
	}

	/// A pin on the board
	public enum Pin {
		case p0, p1, p2, p3, p4, p5, p6, p7, p8, p9
		case p10, p11, p12, p13, p14, p15, p16, p17, p18, p19
		case p20, p21, p22, p23, p24, p25, p26, p27, p28, p29
		case p30, p31, p32, p33, p34, p35, p36, p37, p38, p39
		case p40, p41, p42, p43, p44, p45, p46, p47
	}
}

extension GPIO.Pin {
	var swifty: GPIOName {
		switch self {
		case .p0: return .P0
		case .p1: return .P1
		case .p2: return .P2
		case .p3: return .P3
		case .p4: return .P4
		case .p5: return .P5
		case .p6: return .P6
		case .p7: return .P7
		case .p8: return .P8
		case .p9: return .P9
		case .p10: return .P10
		case .p11: return .P11
		case .p12: return .P12
		case .p13: return .P13
		case .p14: return .P14
		case .p15: return .P15
		case .p16: return .P16
		case .p17: return .P17
		case .p18: return .P18
		case .p19: return .P19
		case .p20: return .P20
		case .p21: return .P21
		case .p22: return .P22
		case .p23: return .P23
		case .p24: return .P24
		case .p25: return .P25
		case .p26: return .P26
		case .p27: return .P27
		case .p28: return .P28
		case .p29: return .P29
		case .p30: return .P30
		case .p31: return .P31
		case .p32: return .P32
		case .p33: return .P33
		case .p34: return .P34
		case .p35: return .P35
		case .p36: return .P36
		case .p37: return .P37
		case .p38: return .P38
		case .p39: return .P39
		case .p40: return .P40
		case .p41: return .P41
		case .p42: return .P42
		case .p43: return .P43
		case .p44: return .P44
		case .p45: return .P45
		case .p46: return .P46
		case .p47: return .P47
		}
	}
}

extension GPIO.Direction {
	init(swifty: GPIODirection) {
		switch swifty {
		case .IN: self = .in
		case .OUT: self = .out
		}
	}

	var swifty: GPIODirection {
		switch self {
		case .in: return .IN
		case .out: return .OUT
		}
	}
}

extension GPIO.Value {
	init(swifty: Int) {
		switch swifty {
		case 0: self = .off
		default: self = .on
		}
	}
	var swifty: Int {
		switch self {
		case .off: return 0
		case .on: return 1
		}
	}
}
