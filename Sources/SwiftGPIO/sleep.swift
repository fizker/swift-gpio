import Foundation

@discardableResult
public func sleep(s: UInt32) -> Int32 {
	sleep(ms: s * 1_000)
}

@discardableResult
public func sleep(ms: UInt32) -> Int32 {
	sleep(µs: ms * 1_000)
}

@discardableResult
public func sleep(µs: UInt32) -> Int32 {
	usleep(µs)
}

/// Sleeps for an amount that would have repeated calls have the designated Hz. So 5 Hz would be 1/5s.
/// - parameter Hz: The delay expressed as Hertz (x Hz === 1/x s)
@discardableResult
public func sleep(Hz: UInt32) -> Int32 {
	sleep(µs: 1_000_000/Hz)
}
