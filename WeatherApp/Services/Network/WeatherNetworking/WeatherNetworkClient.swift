import Foundation

final class WeatherNetworkClient: Networking {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func dataTask<Request: NetworkRequest>(
        for request: Request,
        completion: @escaping (Result<Request.Response, Error>) -> Void
    ) -> URLSessionDataTask? {
        var urlComponents = URLComponents()
        urlComponents.scheme = request.scheme.rawValue
        urlComponents.host = request.host
        urlComponents.path = request.path

        urlComponents.queryItems = request.queryItems.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }

        guard let url = urlComponents.url else {
            completion(.failure(NetworkRequestError.invalidURL))
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers

        if let body = request.body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                completion(.failure(NetworkRequestError.serializationError))
            }
        }

        let dataTask = session.dataTask(with: urlRequest) { data, urlResponse, error in
            if let error = error {
                completion(.failure(error))
            }

            guard let response = urlResponse as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                return completion(.failure(NetworkRequestError.unsuccessfullRequest))
            }

            guard let data = data else {
                return completion(.failure(NetworkRequestError.noData))
            }

            do {
                try completion(.success(request.decode(data)))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }

        return dataTask
    }
}
