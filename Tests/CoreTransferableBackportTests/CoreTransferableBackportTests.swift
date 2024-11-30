import Testing
@testable import CoreTransferableBackport
import CoreTransferable
import UniformTypeIdentifiers

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
}

struct DataObject: Transferable {
    let text: String
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .text) { object in
            object.text.data(using: .utf8)!
        }
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
    }
}

struct ProxyObject: Transferable, Codable {
    let text: String
    
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(
            exporting: \.text,
            importing: { ProxyObject(text: $0) }
        )
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
            }, importing: { receivedTransferredFile in
                let text = try String(
                    contentsOf: receivedTransferredFile.file,
                    encoding: .utf8
                )
                return FileObject(text: text)
            }
        )
    }
}
