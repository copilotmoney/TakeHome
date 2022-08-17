import Apollo
import Foundation

class AuthorizationInterceptor: ApolloInterceptor {
  let id: String = UUID().uuidString

  private let accessToken: String

  init(accessToken: String) {
    self.accessToken = accessToken
  }

  func interceptAsync<Operation: GraphQLOperation>(
    chain: RequestChain,
    request: HTTPRequest<Operation>,
    response: HTTPResponse<Operation>?,
    completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
  ) {
    request.addHeader(name: "Authorization", value: "Bearer \(accessToken)")
    chain.proceedAsync(
      request: request,
      response: response,
      interceptor: self,
      completion: completion
    )
  }
}

class NetworkInterceptorProvider: DefaultInterceptorProvider {
  private let store: ApolloStore
  private let client: URLSessionClient
  private let accessToken: String

  init(accessToken: String, store: ApolloStore, client: URLSessionClient) {
    self.store = store
    self.client = client
    self.accessToken = accessToken
    super.init(client: client, store: store)
  }

  override func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
    var interceptors = super.interceptors(for: operation)
    interceptors.insert(AuthorizationInterceptor(accessToken: accessToken), at: 0)
    return interceptors
  }
}

func createClient(accessToken: String, url: URL) -> ApolloClient {
  let cache = InMemoryNormalizedCache()
  let store = ApolloStore(cache: cache)

  let client = URLSessionClient()
  let provider = NetworkInterceptorProvider(accessToken: accessToken, store: store, client: client)
  let requestChainTransport = RequestChainNetworkTransport(
    interceptorProvider: provider,
    endpointURL: url
  )
  return ApolloClient(networkTransport: requestChainTransport, store: store)
}
