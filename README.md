# Take Home Exercise

This is a take home exercise where we'll build an iOS App.

Your job is to take the following API and build an app that matches as closely as possible the
provided design spec.

The app will display a collection of birds along with some information, and when clicking on a bird,
a detail modal will appear, where users will be able to zoom in on the bird's image and also
register a note on that particular bird.

## Design Specs

As part of the assignment, you'll get a link to a Figma document that shows the spec for the
project. A big consideration of the assignment is to recreate the design spec as closely as
possible. Certain aspects of the UX will be left to the candidate, such as animations (it's ok to
use the default UIKit animations). In case you have any questions, you are encouraged to ask them.

## API and data model

The API will be based on Firebase's Firestore. As part of the assignment, you'll get the JSON
configuration file for Firebase. The documents will exist under the `/birds` paths. These documents
are guarded to be available only to signed in users (you'll need to use Firebase Auth's anonymous
log in).

The spec for each document is as follows:

```
Document path: /birds/<Bird ID>
Data:
{
  "uid": "<Bird ID>",
  "name": {
      "spanish": "<Bird Name Spanish>",
      "english": "<Bird Name English>",
      "latin": "<Bird Name Latin>",
  },
  "images": {
      "thumb": "<Bird Thumb Image>",
      "full": "<Bird Full Image>"
  },
  "sort": <Bird Index>
}
```

There may be more data in the documents, but they won't be relevant.

The users' notes related to each bird will be stored in the same bird's document as an array
of objects that will contain at least the userID, the note's text and the time of creation. This
array should be stored in a new field named `notes`. The notes should be sorted last created
on the top.

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

External dependencies are required in order to use Firebase, feel free to use Swift Package Manager
or Cocoapods dependencies. Any other dependencies are also allowed (as long as they don't abstract
large portions of the assignment).

## Delivery

Please clone this repository and create a new private Github repository under your account, giving
read access to the interviewer (or create a public repository if you want to, this is up to you).

Please also send an email to the interviewer letting them know that you've finished the exercise.

## Evaluation points

* UI matches the design spec as closely as possible.
* Proper use of Firestore's event listeners for changed data.
* Handle slow and failed downloads gracefully.
* App responsiveness (handle background tasks efficiently)

## Questions

Feel free to ask any questions to the interviewer throughout the process!