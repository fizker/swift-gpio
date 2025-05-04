/// Wraps an instance of a class as a weak reference
final class Weak<T: AnyObject> {
	weak var value: T?

	init(_ value: T) {
		self.value = value
	}
}
