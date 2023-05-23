import Foundation

public enum NetworkRequestError: Error {
    case noData
    case invalidURL
    case serializationError
    case unsuccessfullRequest

    public var description: String {
        switch self {
        case .noData: return "There is no response data"
        case .invalidURL: return "Something wrong with URL"
        case .serializationError: return "Something wrong with serialization process"
        case .unsuccessfullRequest: return "Check request status code"
        }
    }
}
