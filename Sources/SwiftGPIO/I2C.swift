import WiringPi

private typealias WI2C = WiringPi.I2C

public enum I2CError: Error {
	case notReachable
}

private extension Sequence {
	func firstMapped<T>(_ transform: (Iterator.Element) throws -> T?) rethrows -> T? {
		for element in self {
			if let mappedValue = try transform(element) {
				return mappedValue
			}
		}
		return nil
	}
}

public class I2C {
	public enum Device {
		case old, new

		var path: String {
			switch self {
			case .old: "/dev/i2c-0"
			case .new: "/dev/i2c-1"
			}
		}
	}

	public enum Pin {
		case a0, a1, a2, a3, a4, a5, a6, a7

		var rawValue: Int32 {
			switch self {
			case .a0: return 0
			case .a1: return 1
			case .a2: return 2
			case .a3: return 3
			case .a4: return 4
			case .a5: return 5
			case .a6: return 6
			case .a7: return 7
			}
		}
	}

	private static let addresses: [Int32] = [ 0x48, 0x4b ]

	private let fileHandle: WI2C.FileHandle

	init(device: Device? = nil) throws(I2CError) {
		func handle(for addr: Int32) -> WI2C.FileHandle? {
			if let device {
				return WI2C.setupInterface(device: device.path, deviceId: addr)
			} else {
				return WI2C.setup(deviceId: addr)
			}
		}

		guard let fileHandle = Self.addresses.firstMapped({ addr -> WI2C.FileHandle? in
			guard let fileHandle = handle(for: addr)
			else { return nil }

			guard WI2C.write(fileHandle, data: 0) >= 0
			else { return nil }

			return fileHandle
		})
		else { throw .notReachable }
		self.fileHandle = fileHandle
	}

	public func read(_ pin: Pin) -> UInt8 {
		WI2C.readReg8(fileHandle, register: pin.rawValue) ?? 0
	}
}

extension GPIOController {
	public func i2c(_ device: I2C.Device? = nil) throws(I2CError) -> I2C {
		try I2C(device: device)
	}
}
