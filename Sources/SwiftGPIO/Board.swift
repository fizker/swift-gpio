import SwiftyGPIO

/// The boards that is supported
public enum Board {
	/// Pi A,B Revision 1
	case raspberryPiRev1
	/// Pi A,B Revision 2
	case raspberryPiRev2
	/// Pi A+,B+,Zero with 40 pin header
	case raspberryPiPlusZero
	/// Pi 2 with 40 pin header
	case raspberryPi2
	/// Pi 3 with 40 pin header
	case raspberryPi3
	/// Pi 4 with 40 pin header
	case raspberryPi4
	case chip
	case beagleBoneBlack
	case orangePi
	case orangePiZero
}

extension Board {
	var swifty: SupportedBoard {
		switch self {
		case .raspberryPiRev1: return .RaspberryPiRev1
		case .raspberryPiRev2: return .RaspberryPiRev2
		case .raspberryPiPlusZero: return .RaspberryPiPlusZero
		case .raspberryPi2: return .RaspberryPi2
		case .raspberryPi3: return .RaspberryPi3
		case .raspberryPi4: return .RaspberryPi4
		case .chip: return .CHIP
		case .beagleBoneBlack: return .BeagleBoneBlack
		case .orangePi: return .OrangePi
		case .orangePiZero: return .OrangePiZero
		}
	}
}
