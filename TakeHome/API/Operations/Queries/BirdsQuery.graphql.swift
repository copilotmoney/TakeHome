// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GraphQL {
  class BirdsQuery: GraphQLQuery {
    static let operationName: String = "birds"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query birds { birds { __typename id } }"#
      ))

    public init() {}

    struct Data: GraphQL.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GraphQL.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("birds", [Bird].self),
      ] }

      var birds: [Bird] { __data["birds"] }

      /// Bird
      ///
      /// Parent Type: `Bird`
      struct Bird: GraphQL.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GraphQL.Objects.Bird }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", GraphQL.ID.self),
        ] }

        var id: GraphQL.ID { __data["id"] }
      }
    }
  }

}