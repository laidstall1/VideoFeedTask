# Feed Module / Video Feed iOS Project

## Setup Steps

-   Clone the repository
-   Open the project in Xcode
-   Ensure Swift concurrency is enabled (Swift 5.7+)
-   Install dependencies (if using SPM, resolve packages)
-   Configure API base URL and environment variables if required
-   Run on simulator or physical device

------------------------------------------------------------------------

## Architectural Overview

-   **Architecture Pattern:** Clean Architecture + Feature-first modular
    structure
-   **Presentation Layer:**
    -   ViewModels handle UI state and async calls
    -   UIKit / SwiftUI used depending on feature
-   **Domain Layer:**
    -   Use cases coordinate business logic
    -   Repository protocols define contracts
-   **Data Layer:**
    -   Repository implementations call API services
    -   DTOs map to Domain models
    -   APIClientService handles networking and decoding
-   **Concurrency:**
    -   Async/Await used across networking
    -   Sendable conformance considered for DTOs and models
-   **Video System:**
    -   Central VideoPlayerManager handles caching, playback, and resume
        downloads
    -   Cells receive manager via dependency injection

------------------------------------------------------------------------

## Tradeoffs and Known Limitations

-   Some DTOs may require Sendable conformance which increases
    boilerplate
-   Video caching increases storage usage on device
-   Aggressive preloading can increase memory pressure
-   Network retry strategy is basic and could be improved
-   Limited offline-first capabilities
-   Error states could be more granular for UI feedback

------------------------------------------------------------------------

## What I Would Improve With More Time

-   Implement smarter video prefetch strategy based on scroll velocity
-   Add background cache cleanup policies
-   Improve retry logic with exponential backoff
-   Add full offline feed persistence (Swift Data / Core Data)
-   Add UI performance monitoring
-   Expand automated test coverage (unit + integration + UI tests)
-   Add DI library e.g. Factory, Swinject to manage Dependency Injection
-   Add CI/CD using Fastlane and Github actions. Dependent also on a paid Apple Developer account

------------------------------------------------------------------------

## Tech Stack

-   Swift
-   SwiftUI
-   AVFoundation
-   Async/Await Concurrency
-   Clean Architecture
-   Dependency Injection

------------------------------------------------------------------------

## Notes

This project focuses on building a high-performance social-style video
feed with smooth playback, efficient caching, and scalable architecture
suitable for large feeds.
