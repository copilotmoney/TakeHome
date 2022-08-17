import Apollo
import UIKit

class ViewController: UIViewController {
  var client: ApolloClient!

  override func viewDidLoad() {
    super.viewDidLoad()

    client = createClient(
      accessToken: "YOUR_ACCESS_TOKEN",
      url: URL(string: "https://takehome.graphql.copilot.money")!
    )
    client.fetch(query: GraphQL.BirdsQuery()) { result in
      print(result)
    }
  }
}
