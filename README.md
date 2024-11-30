# CoreTransferableBackport

## Usage

```swift
let object = DataObject(text: "Hello, World!")
let textData = try await object.backport.exported(as: .text)        
let importedObject = try await DataObject.backport.`init`(
    importing: textData,
    contentType: .text
)
```