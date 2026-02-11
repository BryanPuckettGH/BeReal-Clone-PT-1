# Project 2 - *BeReal Clone*

Submitted by: **Bryan Puckett**

**BeReal Clone** is an app that allows users to share photos from their library with optional captions, view a feed of posts, and see the location and time of each photo upload -- inspired by the popular BeReal app.

Time spent: **10** hours spent in total

## Required Features

The following **required** functionality is completed:

- [x] Users see an app icon in the home screen and a styled launch screen.
- [x] User can register a new account
- [x] User can log in with newly created account
- [x] App has a feed of posts when user logs in
- [x] User can upload a new post which takes in a picture from photo library and an optional caption
- [x] User is able to logout

The following **optional** features are implemented:

- [x] Users can pull to refresh their feed and see a loading indicator
- [ ] Users can infinite-scroll in their feed to see past the 10 most recent photos
- [x] Users can see location and time of photo upload in the feed
- [x] User stays logged in when app is closed and open again

The following **additional** features are implemented:

- [x] Session token validation on app launch with automatic logout on invalid/expired sessions
- [x] Keyboard dismissal via tap gesture and Done button for better UX
- [x] Reverse geocoding of photo metadata to display human-readable location names

## Video Walkthrough

<!-- Replace this with your actual Loom or YouTube embed/link -->
<div>
    <a href="REPLACE_WITH_YOUR_LOOM_LINK">
      <p>BeReal Clone - Video Walkthrough</p>
    </a>
</div>

## Notes

- Handled Parse session token invalidation (error code 209) by validating the session on app launch and automatically logging the user out when a stale token is detected.
- Used PHPickerViewController with PHPickerConfiguration(photoLibrary:) to access photo asset identifiers for extracting GPS metadata from selected photos.
- Implemented reverse geocoding using MapKit's MKReverseGeocodingRequest to convert photo coordinates into readable location strings.

## License

    Copyright 2026 Bryan Puckett

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
