# Take Home Exercise

This is a take home exercise where we'll build an iOS App.

Your job is to take the following API and build an app that matches as **closely** as possible the
provided design spec.

The app will display a collection of birds along with some information, and when clicking on a bird,
a detail modal will appear, where users will be able to zoom in on the bird's image and also
register a note on that particular bird.

## Design Specs

As part of the assignment, you'll get a link to a Figma document that shows the spec for the
project. A big consideration of the assignment is to recreate the design spec as **closely** as
possible. This aspect of the exercise will be looked at in special detail. Certain aspects of the
UX will be left to the candidate, such as animations (it's ok to use the default UIKit animations).
In case you have any questions, you are encouraged to ask them.

## API and data model

The API will be [GraphQL](https://graphql.org) based and is hosted in
`https://takehome.graphql.copilot.money`. As part of the assignment, you'll get an access
token that you'll need to pass into the `Authorization` header as such:

- `"Authorization": "Bearer <accessToken>"`

The schema for the API is the following:

```graphql
type Query {
  birds: [Bird!]!
  bird(id: ID!): Bird
}

type Mutation {
  addNote(birdId: ID!, comment: String!, timestamp: Int!): ID
}

type Bird {
  id: ID!
  thumb_url: String!
  image_url: String!
  latin_name: String!
  english_name: String!
  notes: [Note!]!
}

type Note {
  id: ID!
  comment: String!
  timestamp: Int! # Milliseconds from epoch.
}
```

As a starting point, the code already provides a client that you can use to query and mutate data.
You are not required to keep the client as is, feel free to move the client creation code around
for organization purposes, or any other changes you might want to add. It is only provided for
convenience.

Be aware, that some data might be missing from the GraphQL queries, and you might need to modify
some of the `TakeHome/API/*.graphql` files to get the proper data needed to implement the UIs. To
regenerate the generated files, just run `./apollo-ios-cli generate generate`. (If you'd like to
avoid running the repo cli tool for good measure, you can delete it and follow the instructions
[here](https://www.apollographql.com/docs/ios/get-started) to redo the installation yourself).

## Image Watermarks

All images that will be shown on screen shall be watermarked. In order to watermark, you need to
invoke the following HTTP function:

`POST https://us-central1-copilot-take-home.cloudfunctions.net/watermark`

The body should contain the bytes of the image (should be jpeg, the original format of the bird
URLs), and the headers should contain the `application/octet-stream` Content-Type header, and the
number of bytes in the Content-Length header. The response will have the Content-Length header, the
Content-Type header with `image/jpeg`, and the body will be the bytes of a JPEG image.

Again, if you have any questions or issues, you are encouraged to ask the interviewer.

## Project dependencies

If you need them, feel free to use Swift Package Manager or Cocoapods dependencies. Any
dependency is also allowed (as long as they don't abstract large portions of the assignment).

## Delivery

Please clone this repository and create a new private Github repository under your account, giving
read access to the interviewer (or create a public repository if you want to, this is up to you).

Please also send an email to the interviewer letting them know that you've finished the exercise.

## Evaluation points

* UI matches the design spec as closely as possible.
* Handle slow and failed downloads gracefully.
* App responsiveness (handle background tasks efficiently).

## Questions

Feel free to ask any questions to the interviewer throughout the process!