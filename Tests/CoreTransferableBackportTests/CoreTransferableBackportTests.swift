import CoreTransferable
import Testing
import UniformTypeIdentifiers

@testable import CoreTransferableBackport

@Suite
struct TransferableTests {

    @available(iOS 18.2, *)
    @Test
    func dataRepresentation() async throws {
        let object = DataObject(text: "Hello, World!")
        let textData = try await object.exported(as: .text)
        #expect(String(data: textData, encoding: .utf8)! == object.text)
        let importedObject = try await DataObject(
            importing: textData,
            contentType: .text
        )
        #expect(importedObject.text == object.text)
    }

    @Test
    func backportDataRepresentation() async throws {
        let object = DataObject(text: "Hello, World!")
        let textData = try await object.backport.exported(as: .text)
        #expect(String(data: textData, encoding: .utf8)! == object.text)

        let importedObject = try await DataObject.backport.`init`(
            importing: textData,
            contentType: .text
        )
        #expect(importedObject.text == object.text)
    }

    @available(iOS 18.2, *)
    @Test
    func codableRepresentation() async throws {
        let object = CodableObject(text: "Hello, World!")
        let textData = try await object.exported(as: .text)
        #expect(String(data: textData, encoding: .utf8)! == #"{"text":"Hello, World!"}"#)
        let importedObject = try await CodableObject(
            importing: textData,
            contentType: .text
        )
        #expect(importedObject.text == object.text)
    }

    @Test
    func backportCodableRepresentation() async throws {
        let object = CodableObject(text: "Hello, World!")
        let textData = try await object.backport.exported(as: .text)
        #expect(String(data: textData, encoding: .utf8)! == #"{"text":"Hello, World!"}"#)

        let importedObject = try await CodableObject.backport.`init`(
            importing: textData,
            contentType: .text
        )
        #expect(importedObject.text == object.text)
    }

    @available(iOS 18.2, *)
    @Test
    func proxyRepresentation() async throws {
        let object = ProxyObject(text: "Hello, World!")
        let textData = try await object.exported(as: .utf8PlainText)
        #expect(String(data: textData, encoding: .utf8)! == "Hello, World!")
        let importedObject = try await ProxyObject(
            importing: textData,
            contentType: .utf8PlainText
        )
        #expect(importedObject.text == object.text)
    }

    @Test
    func backportProxyRepresentation() async throws {
        let object = ProxyObject(text: "Hello, World!")
        let textData = try await object.backport.exported(as: .utf8PlainText)
        #expect(String(data: textData, encoding: .utf8)! == "Hello, World!")
        let importedObject = try await ProxyObject.backport.`init`(
            importing: textData,
            contentType: .utf8PlainText
        )
        #expect(importedObject.text == object.text)
    }

    @available(iOS 18.2, *)
    @Test
    func fileRepresentation() async throws {
        let object = FileObject(text: "Hello, World!")
        let url = try await object.export(
            to: URL.cachesDirectory,
            contentType: .text
        )
        print(url)
        let importedObject = try await FileObject(
            importing: url,
            contentType: .text
        )
        #expect(importedObject.text == object.text)
    }

    @Test
    func backportFileRepresentation() async throws {
        let object = FileObject(text: "Hello, World!")
        let url = try await object.backport.export(
            to: URL.cachesDirectory,
            contentType: .text
        )
        print(url)
        let importedObject = try await FileObject.backport.`init`(
            importing: url,
            contentType: .text
        )
        #expect(importedObject.text == object.text)
    }

    @available(iOS 18.2, *)
    @Test
    func contentTypes() async throws {
        let dataObject = DataObject(text: "Hello, World!")
        #expect(dataObject.importedContentTypes().count == 1)
        #expect(dataObject.importedContentTypes().contains(.text))
        #expect(dataObject.exportedContentTypes().count == 1)
        #expect(dataObject.exportedContentTypes().contains(.text))

        let codableObject = CodableObject(text: "Hello, World!")
        #expect(codableObject.importedContentTypes().count == 1)
        #expect(codableObject.importedContentTypes().contains(.text))
        #expect(codableObject.exportedContentTypes().count == 1)
        #expect(codableObject.exportedContentTypes().contains(.text))

        let proxyObject = ProxyObject(text: "Hello, World!")
        #expect(proxyObject.importedContentTypes().count == 1)
        #expect(proxyObject.importedContentTypes().contains(.utf8PlainText))
        #expect(proxyObject.exportedContentTypes().count == 1)
        #expect(proxyObject.exportedContentTypes().contains(.utf8PlainText))

        let fileObject = FileObject(text: "Hello, World!")
        #expect(fileObject.importedContentTypes().count == 1)
        #expect(fileObject.importedContentTypes().contains(.text))
        #expect(fileObject.exportedContentTypes().count == 1)
        #expect(fileObject.exportedContentTypes().contains(.text))

        let mixedObject = MixedObject(text: "Hello, World!")
        #expect(mixedObject.importedContentTypes().count == 2)
        #expect(mixedObject.importedContentTypes().contains(.text))
        #expect(mixedObject.importedContentTypes().contains(.png))
        #expect(mixedObject.exportedContentTypes().count == 3)
        #expect(mixedObject.exportedContentTypes().contains(.text))
        #expect(mixedObject.exportedContentTypes().contains(.png))
        #expect(mixedObject.exportedContentTypes().contains(.mpeg4Movie))
    }

    @Test
    func backportContentTypes() async throws {
        let dataObject = DataObject(text: "Hello, World!")
        #expect(dataObject.backport.importedContentTypes().count == 1)
        #expect(dataObject.backport.importedContentTypes().contains(.text))
        #expect(dataObject.backport.exportedContentTypes().count == 1)
        #expect(dataObject.backport.exportedContentTypes().contains(.text))

        let codableObject = CodableObject(text: "Hello, World!")
        #expect(codableObject.backport.importedContentTypes().count == 1)
        #expect(codableObject.backport.importedContentTypes().contains(.text))
        #expect(codableObject.backport.exportedContentTypes().count == 1)
        #expect(codableObject.backport.exportedContentTypes().contains(.text))

        let proxyObject = ProxyObject(text: "Hello, World!")
        #expect(proxyObject.backport.importedContentTypes().count == 1)
        #expect(proxyObject.backport.importedContentTypes().contains(.utf8PlainText))
        #expect(proxyObject.backport.exportedContentTypes().count == 1)
        #expect(proxyObject.backport.exportedContentTypes().contains(.utf8PlainText))

        let fileObject = FileObject(text: "Hello, World!")
        #expect(fileObject.backport.importedContentTypes().count == 1)
        #expect(fileObject.backport.importedContentTypes().contains(.text))
        #expect(fileObject.backport.exportedContentTypes().count == 1)
        #expect(fileObject.backport.exportedContentTypes().contains(.text))

        let mixedObject = MixedObject(text: "Hello, World!")
        #expect(mixedObject.backport.importedContentTypes().count == 2)
        #expect(mixedObject.backport.importedContentTypes().contains(.text))
        #expect(mixedObject.backport.importedContentTypes().contains(.png))
        #expect(mixedObject.backport.exportedContentTypes().count == 3)
        #expect(mixedObject.backport.exportedContentTypes().contains(.text))
        #expect(mixedObject.backport.exportedContentTypes().contains(.png))
        #expect(mixedObject.backport.exportedContentTypes().contains(.mpeg4Movie))
    }

    @available(iOS 18.2, *)
    @Test
    func staticContentTypes() async throws {
        #expect(DataObject.importedContentTypes().count == 1)
        #expect(DataObject.importedContentTypes().contains(.text))
        #expect(DataObject.exportedContentTypes().count == 1)
        #expect(DataObject.exportedContentTypes().contains(.text))

        #expect(CodableObject.importedContentTypes().count == 1)
        #expect(CodableObject.importedContentTypes().contains(.text))
        #expect(CodableObject.exportedContentTypes().count == 1)
        #expect(CodableObject.exportedContentTypes().contains(.text))

        #expect(ProxyObject.importedContentTypes().count == 1)
        #expect(ProxyObject.importedContentTypes().contains(.utf8PlainText))
        #expect(ProxyObject.exportedContentTypes().count == 1)
        #expect(ProxyObject.exportedContentTypes().contains(.utf8PlainText))

        #expect(FileObject.importedContentTypes().count == 1)
        #expect(FileObject.importedContentTypes().contains(.text))
        #expect(FileObject.exportedContentTypes().count == 1)
        #expect(FileObject.exportedContentTypes().contains(.text))

        #expect(MixedObject.importedContentTypes().count == 2)
        #expect(MixedObject.importedContentTypes().contains(.text))
        #expect(MixedObject.importedContentTypes().contains(.png))
        #expect(MixedObject.exportedContentTypes().count == 3)
        #expect(MixedObject.exportedContentTypes().contains(.text))
        #expect(MixedObject.exportedContentTypes().contains(.png))
        #expect(MixedObject.exportedContentTypes().contains(.mpeg4Movie))
    }

    @Test
    func backportStaticContentTypes() async throws {
        #expect(DataObject.backport.importedContentTypes().count == 1)
        #expect(DataObject.backport.importedContentTypes().contains(.text))
        #expect(DataObject.backport.exportedContentTypes().count == 1)
        #expect(DataObject.backport.exportedContentTypes().contains(.text))

        #expect(CodableObject.backport.importedContentTypes().count == 1)
        #expect(CodableObject.backport.importedContentTypes().contains(.text))
        #expect(CodableObject.backport.exportedContentTypes().count == 1)
        #expect(CodableObject.backport.exportedContentTypes().contains(.text))

        #expect(ProxyObject.backport.importedContentTypes().count == 1)
        #expect(ProxyObject.backport.importedContentTypes().contains(.utf8PlainText))
        #expect(ProxyObject.backport.exportedContentTypes().count == 1)
        #expect(ProxyObject.backport.exportedContentTypes().contains(.utf8PlainText))

        #expect(FileObject.backport.importedContentTypes().count == 1)
        #expect(FileObject.backport.importedContentTypes().contains(.text))
        #expect(FileObject.backport.exportedContentTypes().count == 1)
        #expect(FileObject.backport.exportedContentTypes().contains(.text))

        #expect(MixedObject.backport.importedContentTypes().count == 2)
        #expect(MixedObject.backport.importedContentTypes().contains(.text))
        #expect(MixedObject.backport.importedContentTypes().contains(.png))
        #expect(MixedObject.backport.exportedContentTypes().count == 3)
        #expect(MixedObject.backport.exportedContentTypes().contains(.text))
        #expect(MixedObject.backport.exportedContentTypes().contains(.png))
        #expect(MixedObject.backport.exportedContentTypes().contains(.mpeg4Movie))
    }

    @available(iOS 18.2, *)
    @Test
    func suggestedFilename() async throws {
        let dataObject = DataObject(text: "Hello, World!")
        #expect(dataObject.suggestedFilename == "data.txt")

        let codableObject = CodableObject(text: "Hello, World!")
        #expect(codableObject.suggestedFilename == "codable.txt")

        let proxyObject = ProxyObject(text: "Hello, World!")
        #expect(proxyObject.suggestedFilename == "proxy.txt")

        let fileObject = FileObject(text: "Hello, World!")
        #expect(fileObject.suggestedFilename == "file.txt")
    }

    @Test
    func backportSuggestedFilename() async throws {
        let dataObject = DataObject(text: "Hello, World!")
        #expect(dataObject.backport.suggestedFilename == "data.txt")

        let codableObject = CodableObject(text: "Hello, World!")
        #expect(codableObject.backport.suggestedFilename == "codable.txt")

        let proxyObject = ProxyObject(text: "Hello, World!")
        #expect(proxyObject.backport.suggestedFilename == "proxy.txt")

        let fileObject = FileObject(text: "Hello, World!")
        #expect(fileObject.backport.suggestedFilename == "file.txt")
    }

    @available(iOS 18.2, *)
    @Test
    func withExportedFile() async throws {
        let dataObject = DataObject(text: "Hello, World!")
        let exportedDataResult = try await dataObject.withExportedFile(
            contentType: .text,
            fileHandler: { url in
                try String(contentsOf: url, encoding: .utf8)
            }
        )
        #expect(exportedDataResult == "Hello, World!")

        let codableObject = CodableObject(text: "Hello, World!")
        let codableDataResult = try await codableObject.withExportedFile(
            contentType: .text,
            fileHandler: { url in
                try String(contentsOf: url, encoding: .utf8)
            }
        )
        #expect(codableDataResult == #"{"text":"Hello, World!"}"#)

        let proxyObject = ProxyObject(text: "Hello, World!")
        let proxyDataResult = try await proxyObject.withExportedFile(
            contentType: .utf8PlainText,
            fileHandler: { url in
                try String(contentsOf: url, encoding: .utf8)
            }
        )
        #expect(proxyDataResult == "Hello, World!")

        let fileObject = FileObject(text: "Hello, World!")
        let fileDataResult = try await fileObject.withExportedFile(
            contentType: .text,
            fileHandler: { url in
                try String(contentsOf: url, encoding: .utf8)
            }
        )
        #expect(fileDataResult == "Hello, World!")
    }

    @Test
    func backportWithExportedFile() async throws {
        let dataObject = DataObject(text: "Hello, World!")
        let exportedDataResult = try await dataObject.backport.withExportedFile(
            contentType: .text,
            fileHandler: { url in
                try String(contentsOf: url, encoding: .utf8)
            }
        )
        #expect(exportedDataResult == "Hello, World!")

        let codableObject = CodableObject(text: "Hello, World!")
        let codableDataResult = try await codableObject.backport.withExportedFile(
            contentType: .text,
            fileHandler: { url in
                try String(contentsOf: url, encoding: .utf8)
            }
        )
        #expect(codableDataResult == #"{"text":"Hello, World!"}"#)

        let proxyObject = ProxyObject(text: "Hello, World!")
        let proxyDataResult = try await proxyObject.backport.withExportedFile(
            contentType: .utf8PlainText,
            fileHandler: { url in
                try String(contentsOf: url, encoding: .utf8)
            }
        )
        #expect(proxyDataResult == "Hello, World!")

        let fileObject = FileObject(text: "Hello, World!")
        let fileDataResult = try await fileObject.backport.withExportedFile(
            contentType: .text,
            fileHandler: { url in
                try String(contentsOf: url, encoding: .utf8)
            }
        )
        #expect(fileDataResult == "Hello, World!")
    }
}

struct DataObject: Transferable {
    let text: String

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .text) { object in
            object.text.data(using: .utf8)!
        }
        .suggestedFileName("data.txt")
        DataRepresentation(importedContentType: .text) { data in
            let text = String(data: data, encoding: .utf8)!
            return DataObject(text: text)
        }
    }
}

struct CodableObject: Transferable, Codable {
    let text: String

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .text)
            .suggestedFileName("codable.txt")
    }
}

struct ProxyObject: Transferable, Codable {
    let text: String

    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(
            exporting: \.text,
            importing: { ProxyObject(text: $0) }
        )
        .suggestedFileName("proxy.txt")
    }
}

struct FileObject: Transferable {
    let text: String

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(
            contentType: .text,
            exporting: { (object: FileObject) in
                let url = URL.cachesDirectory.appendingPathComponent("file.txt")
                try? FileManager.default.removeItem(at: url)
                try object.text.data(using: .utf8)!.write(to: url)
                return SentTransferredFile(url)
            },
            importing: { receivedTransferredFile in
                let text = try String(
                    contentsOf: receivedTransferredFile.file,
                    encoding: .utf8
                )
                return FileObject(text: text)
            }
        )
        .suggestedFileName("file.txt")
    }
}

struct MixedObject: Transferable {
    let text: String

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { _ in
            Data()
        }
        DataRepresentation(exportedContentType: .text) { _ in
            Data()
        }
        DataRepresentation(exportedContentType: .mpeg4Movie) { _ in
            Data()
        }
        DataRepresentation(importedContentType: .png) { _ in
            MixedObject(text: "")
        }
        DataRepresentation(importedContentType: .text) { _ in
            MixedObject(text: "")
        }
    }
}
