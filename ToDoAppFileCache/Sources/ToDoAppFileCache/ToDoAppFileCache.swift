import Foundation

public final class FileCache<T: FileCachable> {
    // MARK: - Public Properties
    public private(set) var todoItems = [String: T]()

    public enum FileType {
        case json
        case csv
    }
    
    // MARK: - Public Methods
    public func addItem(_ todoItem: T) {
        todoItems[todoItem.id] = todoItem
    }
    
    public func removeItem(by id: String) {
        todoItems.removeValue(forKey: id)
    }
    
    public func saveFile(_ fileName: String, as type: FileType) throws {
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: documentDirectory)
        
        do {
            switch type {
            case .json:
                let jsonArray = todoItems.values.map { $0.json }
                let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
                try jsonData.write(to: fileURL)
            case .csv:
                let csvArray = todoItems.values.compactMap { $0.csv as? String }
                let csvString = csvArray.joined(separator: "\n")
                try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            }
        } catch {
            throw FileCacheError.cantSaveFile(error)
        }
    }
    
    public func loadFile(_ fileName: String, as type: FileType) throws {
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: documentDirectory)
        do {
            switch type {
            case .json:
                let data = try Data(contentsOf: fileURL)
                if let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                    let todoItems = json.compactMap { T.parse(json: $0) }
                    todoItems.forEach { addItem($0) }
                }
                
            case .csv:
                let csvString = try String(contentsOf: fileURL, encoding: .utf8)
                let csvLines = csvString.split(separator: "\n")
                let todoItems = csvLines.compactMap { T.parse(csv: String($0)) }
                todoItems.forEach { addItem($0) }
            }
        } catch {
            throw FileCacheError.cantLoadFile(error)
        }
    }
    
    // MARK: - Public Initialization
    public init() { }
}

// MARK: - Private Extension
private extension FileCache {
    var documentDirectory: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}
