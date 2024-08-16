# Movie

A simple Movie database application

# Rough Wireframe

![IMG_1889](https://github.com/user-attachments/assets/529656b1-e99a-4f78-9203-997d7baf60e1)

# Build/Run Steps

1. Add a `Config.xcconfig` file as per this [article](https://medium.com/swift-india/secure-secrets-in-ios-app-9f66085800b4). All other configurations are done, you just have to add the `Config.xcconfig` file with `OMDB_API_KEY = <your-omdb-api-key>` to this project's instance on your XCode.
2. Build/run as usual.

# Assumptions

-   BackEnd API will return correct data for the most part.
-   No detailed error handling is necessary at the moment. A catch-all would work.
-   No extensive architecture is needed for an app of this scale. Going ahead with the conventional MVC architecture as promoted by Apple.
