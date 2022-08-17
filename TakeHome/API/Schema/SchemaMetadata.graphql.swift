// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

protocol GraphQL_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == GraphQL.SchemaMetadata {}

protocol GraphQL_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == GraphQL.SchemaMetadata {}

protocol GraphQL_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == GraphQL.SchemaMetadata {}

protocol GraphQL_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == GraphQL.SchemaMetadata {}

extension GraphQL {
  typealias SelectionSet = GraphQL_SelectionSet

  typealias InlineFragment = GraphQL_InlineFragment

  typealias MutableSelectionSet = GraphQL_MutableSelectionSet

  typealias MutableInlineFragment = GraphQL_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
      switch typename {
      case "Query": return GraphQL.Objects.Query
      case "Bird": return GraphQL.Objects.Bird
      case "Mutation": return GraphQL.Objects.Mutation
      default: return nil
      }
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}

}