import class SwiftyGPIO.GPIO

/// Alias to differentiate between our GPIO and the SwiftyGPIO.
/// `SwiftyGPIO.GPIO` cannot be used in a file importing class `SwiftyGPIO.SwiftyGPIO`, since the swift compiler references the class before the module when the name is the same.
typealias SwiftyGPIO_GPIO = SwiftyGPIO.GPIO
