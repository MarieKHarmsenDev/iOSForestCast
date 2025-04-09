# iOSForestCast
iOS Application to display the weather, forecast, save locations to favourites and display on a map, show nearby parks.

CICD:
[![Build Status](https://app.bitrise.io/app/964b12ce-4fb9-4734-8c39-48df53b128a3/status.svg?token=BWvOaWgsR4sy6xth76GoJg&branch=main)](https://app.bitrise.io/app/964b12ce-4fb9-4734-8c39-48df53b128a3) <br />
Code coverage:
![Codecov](https://codecov.io/gh/user/repo/branch/main/graph/badge.svg) <br />
Static code analysis:
![Danger](https://img.shields.io/badge/danger-passing-brightgreen) <br />
iOS version: 
![iOS Version](https://img.shields.io/badge/iOS-16.2%2B-blue.svg) <br />

iPhone16 | Home | Favourites | Nearby |
--- | --- | --- | --- |
Images | <img width="435" alt="Screenshot 2025-04-09 at 13 11 37" src="https://github.com/user-attachments/assets/eb7e3a0f-7fe3-412c-859f-bd7c3ad081ce" /> | <img width="419" alt="Screenshot 2025-04-09 at 13 11 46" src="https://github.com/user-attachments/assets/61da76ea-f60c-4a9f-9d52-ad3e995f61ac" /> | <img width="426" alt="Screenshot 2025-04-09 at 13 11 52" src="https://github.com/user-attachments/assets/f8848f2f-7182-4e2f-9338-72e864c6b8b2" /> |

iPhoneSE | Home | Favourites | Nearby |
--- | --- | --- | --- |
Images | <img width="409" alt="Screenshot 2025-04-09 at 13 30 51" src="https://github.com/user-attachments/assets/93163815-76a8-47d1-9878-7e787df22f4a" /> | <img width="409" alt="Screenshot 2025-04-09 at 13 31 01" src="https://github.com/user-attachments/assets/d4e1edb6-e129-4ab2-98d5-5d87ac491d88" /> | <img width="417" alt="Screenshot 2025-04-09 at 13 31 05" src="https://github.com/user-attachments/assets/e7f7e7ad-a2c6-46ba-9b2f-d65736a90701" /> |

iPad | Home | Favourites | Nearby |
--- | --- | --- | --- |
Images | <img width="633" alt="Screenshot 2025-04-09 at 13 09 32" src="https://github.com/user-attachments/assets/6ddb36fa-094b-41f5-a228-a0ddf549bb48" /> | <img width="628" alt="Screenshot 2025-04-09 at 13 09 22" src="https://github.com/user-attachments/assets/5601ac58-9970-4e7f-8f50-2c4d47fa850a" /> | <img width="635" alt="Screenshot 2025-04-09 at 13 09 27" src="https://github.com/user-attachments/assets/e6973bf0-194f-47a7-82b7-d712655587a5" /> |


Accessibility
<img width="810" alt="Screenshot 2025-04-09 at 13 39 40" src="https://github.com/user-attachments/assets/94ce6097-2ebb-43f3-a71e-739908a9288d" />

API:
Open weather and Google places

Third party dependencies:
Firbase - used to retrieve API key

How to build the project: 
To run this project either install Firebase through Swift package manager, or insert an API key into the URL in KeyManager and the application will work.

Conventions, architecture, and general considerations:
Using MVVM for clear separation between logic and UI. Separating the network layers for readability. Injecting the FavouritesManagerProtocol, HomeNetworkManagerProtocol and CLLocationManager so we can mock the response and use it for unit testing. Mocked out the CLLocationManager to ensure we are moving the state of the project from loading to showing content when the location is fetched.
Used user defaults for favourites for persistent data storing as the struct to be stored is lightweight and reading from user defaults is fast.
WeatherView being reused in the favourites section, so designed with reusability in mind

Any additional notes that can demonstrate your knowledge:
Used Firebase to not store the API on the client side, there could be additional hashing and better salting algorithms here to keep that safe. 
The Network logger only prints the network issue, but this could be connected to New relic or similar to monitor issues arising in the app.

