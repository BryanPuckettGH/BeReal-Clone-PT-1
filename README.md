<div align="center">

# Project 2 - *BeReal Clone*

**Bryan Puckett** | COP4655 - Mobile Application Development | FIU Spring 2026

</div>

---

**BeReal Clone** is an app that allows users to share photos from their library with optional captions, view a feed of posts, and see the location and time of each photo upload — inspired by the popular BeReal app.

| | |
|---|---|
| **Time Spent** | 10 hours |
| **Platform** | iOS (UIKit) |
| **Backend** | Parse / Back4App |

---

## Demo

<div align="center">
<img src="bereal-demo.gif" width="300" alt="BeReal Clone Demo"/>
</div>

---

## Required Features

- [x] Users see an app icon in the home screen and a styled launch screen
- [x] User can register a new account
- [x] User can log in with newly created account
- [x] App has a feed of posts when user logs in
- [x] User can upload a new post which takes in a picture from photo library and an optional caption
- [x] User is able to logout

## Optional Features

- [x] Users can pull to refresh their feed and see a loading indicator
- [x] Users can infinite-scroll in their feed to see past the 10 most recent photos
- [x] Users can see location and time of photo upload in the feed
- [x] User stays logged in when app is closed and open again

## Additional Features

- [x] Session token validation on app launch with automatic logout on invalid/expired sessions
- [x] Keyboard dismissal via tap gesture and Done button for better UX
- [x] Reverse geocoding of photo metadata to display human-readable location names

---

## Notes

- Learned how to work with Parse/Back4App as a backend for user authentication and data storage
- Handled session token invalidation to automatically log out users with expired sessions
- Used `PHPickerViewController` to access photo metadata and extract GPS coordinates
- Implemented reverse geocoding to convert photo coordinates into readable location names

---

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
