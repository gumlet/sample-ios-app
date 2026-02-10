# Gumlet Video Player Demo App

This is a sample iOS application demonstrating the integration of the **Gumlet Video Player SDK**.

## Features Demonstrated
- Basic HLS Playback
- FairPlay DRM Integration
- Custom Player Implementation via `GumletPlayerView`

## Prerequisites
- Xcode 12.0+
- iOS 13.0+

## Setup & Installation

1.  **Clone the repository**:
    ```bash
    git clone <your-demo-app-repo-url>
    cd gumletVideoPlayerDemo
    ```

2.  **Open in Xcode**:
    Double-click `gumletVideoPlayerDemo.xcodeproj` to open the project.

3.  **Add SDK Dependency**:
    Existing dependency configuration might need a refresh.
    - Go to **File > Add Package Dependencies...**
    - Enter the URL: `https://github.com/gumlet/spm-releases`
    - Select Version: **1.0.2** (or latest)
    - Add `GumletVideoPlayer` to the `gumletVideoPlayerDemo` target.

    > **Note**: If you see package resolution errors, try **File > Packages > Reset Package Caches**.

## Usage

The main integration logic is in `ContentView.swift`.

```swift
import GumletVideoPlayer
import SwiftUI

struct ContentView: View {
    // 1. Define your Video & DRM URLs
    let videoURL = URL(string: "https://video.gumlet.io/YOUR_VIDEO_ID/main.m3u8")!
    
    // Optional: DRM Configuration
    // let drmLicenseUrl = "https://fairplay.gumlet.com/licence/..."
    // let certificateUrl = "https://fairplay.gumlet.com/certificate/..."

    var body: some View {
        // 2. Embed the Player View
        GumletPlayerViewWrapper(
            params: GumletInitParams(
                videoUrl: videoURL,
                drmLicenseUrl: nil, // Add if needed
                certificateUrl: nil // Add if needed
            )
        )
        .edgesIgnoringSafeArea(.all)
    }
}
```

## Troubleshooting

- **"No such module 'GumletVideoPlayer'"**:
    - Ensure the package is added to your target's **Frameworks, Libraries, and Embedded Content**.
    - Clean Build Folder (`Cmd + Shift + K`).

- **DRM Playback Fails**:
    - verify your `drmLicenseUrl` and `certificateUrl` are correct.
    - Check if your license token has expired.

## License
Copyright © 2026 Gumlet. All rights reserved.