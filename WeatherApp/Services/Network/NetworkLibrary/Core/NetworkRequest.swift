import Foundation

public protocol NetworkRequest {
    associatedtype Response

    var scheme: HTTPScheme { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [String: String] { get }
    var body: [String: String]? { get }

    func decode(_ data: Data) throws -> Response
}
