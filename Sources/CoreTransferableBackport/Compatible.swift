import CoreTransferable
import UniformTypeIdentifiers

public final class Compatible<T: Transferable & Sendable>: Sendable {
    let base: T

    init(base: T) {
        self.base = base
    }

    public func exported(as contentType: UTType?) async throws -> Data {
        if #available(iOS 18.2, visionOS 2.2, macOS 15.2, *) {
            try await base.exported(as: contentType)
        } else {
            try await base.backport.exported(as: contentType)
        }
    }

    public func export(
        to destinationDirectory: URL,
        contentType: UTType?
    ) async throws -> URL {
        if #available(iOS 18.2, visionOS 2.2, macOS 15.2, *) {
            try await base.export(to: destinationDirectory, contentType: contentType)
        } else {
            try await base.backport.export(to: destinationDirectory, contentType: contentType)
        }
    }

    public static func `init`(
        importing data: Data,
        contentType: UTType?
    ) async throws -> T {
        if #available(iOS 18.2, visionOS 2.2, macOS 15.2, *) {
            try await T.init(importing: data, contentType: contentType)
        } else {
            try await T.backport.`init`(importing: data, contentType: contentType)
        }
    }

    public static func `init`(
        importing url: URL,
        contentType: UTType?
    ) async throws -> T {
        if #available(iOS 18.2, visionOS 2.2, macOS 15.2, *) {
            try await T.init(importing: url, contentType: contentType)
        } else {
            try await T.backport.`init`(importing: url, contentType: contentType)
        }
    }

    public func importedContentTypes() -> [UTType] {
        fatalError()
    }

    public func exportedContentTypes() -> [UTType] {
        if #available(iOS 18.2, visionOS 2.2, macOS 15.2, *) {
            base.exportedContentTypes()
        } else {
            base.backport.exportedContentTypes()
        }
    }

    public static func importedContentTypes() -> [UTType] {
        fatalError()
    }

    public static func exportedContentTypes() -> [UTType] {
        fatalError()
    }

    public var suggestedFilename: String? {
        if #available(iOS 18.2, visionOS 2.2, macOS 15.2, *) {
            base.suggestedFilename
        } else {
            base.backport.suggestedFilename
        }
    }

}
