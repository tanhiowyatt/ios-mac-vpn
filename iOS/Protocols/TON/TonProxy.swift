class TonProxyURLProtocol: URLProtocol {
    static var proxy: TonProxy?
    var task: URLSessionTask?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let proxy = TonProxyURLProtocol.proxy else { return }
        let request = self.request
        let proxyURL = URL(string: "https://tonproxy.io/api/v1/proxy")!
        var newRequest = URLRequest(url: proxyURL, cachePolicy: request.cachePolicy)
        newRequest.httpMethod = "POST"
        newRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        newRequest.setValue(proxy.apiKey, forHTTPHeaderField: "X-API-KEY")
        let payload = ["url": request.url?.absoluteString]
        newRequest.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        task = URLSession.shared.dataTask(with: newRequest) { data, response, error in
            if let error = error {
                self.client?.urlProtocol(self, didFailWithError: error)
                return
            }
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(TonProxyResponse.self, from: data)
                let url = URL(string: response.result)!
                let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
                self.client?.urlProtocol(self, didReceive: httpResponse, cacheStoragePolicy:.notCached)
                self.client?.urlProtocol(self, didLoad: data)
            } catch {
                self.client?.urlProtocol(self, didFailWithError: error)
            }
        }
        task?.resume()
    }

    override func stopLoading() {
        task?.cancel()
    }
}

class TonProxyManager {
    let tonProxy: TonProxy

    init(apiKey: String, proxyList: [String], username: String? = nil, password: String? = nil) {
        tonProxy = TonProxy(apiKey: apiKey, proxyList: proxyList, username: username, password: password)
        TonProxyURLProtocol.proxy = tonProxy
        URLProtocol.registerClass(TonProxyURLProtocol.self)
    }

    func start() {
        // Start the Ton proxy service
    }

    func stop() {
        // Stop the Ton proxy service
        URLProtocol.unregisterClass(TonProxyURLProtocol.self)
    }
}