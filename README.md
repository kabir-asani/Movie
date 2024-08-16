# Movie

A simple Movie database application

![image](https://github.com/user-attachments/assets/bb9266e1-2d2e-4031-a37a-536c32e8fe73)

# Rough Wireframe

![IMG_1889](https://github.com/user-attachments/assets/529656b1-e99a-4f78-9203-997d7baf60e1)

# Build/Run Steps

1. Add a `Configuration.swift` file under the `Extras` folder and add a single variable called `omdbAPIKey`.

```
Movie/
    Extras/
        Configuration.swift <- Add this file
...
```

```swift
// Add this variable inside Configuration.swift and replace with your API key
let omdbAPIKey = "your-api-key"
```

2. Build/run as usual.

# Assumptions

-   BackEnd API will return correct data for the most part.
-   No detailed error handling is necessary at the moment. A catch-all would work.
-   No extensive architecture is needed for an app of this scale. Going ahead with the conventional MVC architecture as promoted by Apple.

# Screenshots

![image](https://github.com/user-attachments/assets/aea35597-b237-4365-b7c8-78ba3e250c1d)
![image](https://github.com/user-attachments/assets/465199a2-2725-40bc-b340-22c9326a635a)
