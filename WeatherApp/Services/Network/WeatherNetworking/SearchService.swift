import Foundation

protocol SearchServiceProtocol {
    func search(by query: String, completion: @escaping (([Weather.Location]) -> Void))
}

final class SearchService: SearchServiceProtocol {

    private let networkClient: Networking

    private var dataTask: URLSessionDataTask?

    init(networkClient: Networking) {
        self.networkClient = networkClient
    }

    func search(by query: String, completion: @escaping (([Weather.Location]) -> Void)) {
        dataTask?.cancel()
        let request = SearchRequest(searchPrefix: query)
        dataTask = networkClient.dataTask(for: request, completion: { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })

        dataTask?.resume()
    }
}
