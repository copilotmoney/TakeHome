// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GraphQL {
  class AddNoteMutation: GraphQLMutation {
    static let operationName: String = "addNote"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation addNote($birdId: ID!, $comment: String!, $timestamp: Int!) { addNote(birdId: $birdId, comment: $comment, timestamp: $timestamp) }"#
      ))

    public var birdId: ID
    public var comment: String
    public var timestamp: Int

    public init(
      birdId: ID,
      comment: String,
      timestamp: Int
    ) {
      self.birdId = birdId
      self.comment = comment
      self.timestamp = timestamp
    }

    public var __variables: Variables? { [
      "birdId": birdId,
      "comment": comment,
      "timestamp": timestamp
    ] }

    struct Data: GraphQL.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GraphQL.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("addNote", GraphQL.ID?.self, arguments: [
          "birdId": .variable("birdId"),
          "comment": .variable("comment"),
          "timestamp": .variable("timestamp")
        ]),
      ] }

      var addNote: GraphQL.ID? { __data["addNote"] }
    }
  }

}