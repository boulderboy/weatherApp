import Foundation

public protocol Networking {
    @discardableResult
    func dataTask<Request: NetworkRequest>(
        for request: Request,
        completion: @escaping (Result<Request.Response, Error>) -> Void
    ) -> URLSessionDataTask?
}
