import CoreTransferable
import UniformTypeIdentifiers

public final class Backport<T: Transferable & Sendable>: Sendable {
    let base: T

    init(base: T) {
        self.base = base
    }

    public func exported(as contentType: UTType?) async throws -> Data {
        let itemProvider = NSItemProvider()
        itemProvider.register(self.base)
        let object = try await itemProvider.loadItem(
            forTypeIdentifier: contentType?.identifier ?? ""
        )
        if let data = object as? Data {
            return data
        } else {
            fatalError()
        }
    }

    public func export(
        to destinationDirectory: URL,
        contentType: UTType?
    ) async throws -> URL {
        let itemProvider = NSItemProvider()
        itemProvider.register(self.base)

        return try await withCheckedThrowingContinuation { continuation in
            itemProvider.loadFileRepresentation(
                forTypeIdentifier: contentType?.identifier ?? "",
                completionHandler: { (url, error) in
                    if let error {
                        continuation.resume(throwing: error)
                    } else if let url {
                        do {
                            let filename = url.lastPathComponent
                            let dstURL = destinationDirectory.appending(path: filename)
                            try? FileManager.default.removeItem(at: dstURL)
                            try FileManager.default.copyItem(at: url, to: dstURL)
                            continuation.resume(returning: dstURL)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    } else {
                        fatalError()
                    }
                }
            )
        }
    }

    public func withExportedFile<Result>(
        contentType: UTType?,
        fileHandler: (URL) async throws -> Result
    ) async throws -> Result {
        let url = try await export(to: URL.cachesDirectory, contentType: contentType)
        return try await fileHandler(url)
    }

    public static func `init`(
        importing data: Data,
        contentType: UTType?
    ) async throws -> T {
        let itemProvider = NSItemProvider(
            item: data as NSData,
            typeIdentifier: contentType?.identifier ?? ""
        )
        return try await withCheckedThrowingContinuation { continuation in
            _ = itemProvider.loadTransferable(type: T.self) { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
    }

    public static func `init`(
        importing url: URL,
        contentType: UTType?
    ) async throws -> T {
        let itemProvider = NSItemProvider(contentsOf: url, contentType: contentType)
        return try await withCheckedThrowingContinuation { continuation in
            _ = itemProvider.loadTransferable(type: T.self) { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }
    }

    // FIXME: Implement
    public func importedContentTypes() -> [UTType] {
        []
    }

    public func exportedContentTypes() -> [UTType] {
        let itemProvider = NSItemProvider()
        itemProvider.register(self.base)
        return itemProvider.registeredContentTypes
    }

    // FIXME: Implement
    public static func importedContentTypes() -> [UTType] {
        []
    }

    // FIXME: Implement
    public static func exportedContentTypes() -> [UTType] {
        []
    }

    public var suggestedFilename: String? {
        let itemProvider = NSItemProvider()
        itemProvider.register(self.base)
        return itemProvider.suggestedName
    }
}
