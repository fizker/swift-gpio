import WiringPi

/// The boards that is supported
public enum Board {
	/// Pi A,B Revision 1
	case raspberryPiRev1
	/// Pi A,B Revision 2
	case raspberryPiRev2
	/// Pi A+,B+,Zero with 40 pin header
	case raspberryPiPlusZero
	case raspberryPiZero2
	/// Pi 2 with 40 pin header
	case raspberryPi2
	/// Pi 3 with 40 pin header
	case raspberryPi3
	/// Pi 4 with 40 pin header
	case raspberryPi4
}
