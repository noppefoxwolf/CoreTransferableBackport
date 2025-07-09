import CoreTransferable
import UniformTypeIdentifiers

extension Transferable where Self: Sendable {
    public var backport: Backport<Self> {
        Backport(base: self)
    }

    public static var backport: Backport<Self>.Type { Backport<Self>.self }
}

extension Transferable where Self: Sendable {
    public var compatible: Compatible<Self> {
        Compatible(base: self)
    }

    public static var compatible: Compatible<Self>.Type { Compatible<Self>.self }
}
