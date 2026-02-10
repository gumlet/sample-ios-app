import SwiftUI
import GumletVideoPlayer

import SwiftUI
import GumletVideoPlayer

#if canImport(UIKit)
struct PlayerViewWrapper: UIViewRepresentable {
    let videoUrl: URL
    let autoPlay: Bool
    let showControls: Bool
    let drmLicenseUrl: String?
    let certificateUrl: String?
    
    init(videoUrl: URL, 
         autoPlay: Bool = true, 
         showControls: Bool = true, 
         drmLicenseUrl: String? = nil,
         certificateUrl: String? = nil) {
        self.videoUrl = videoUrl
        self.autoPlay = autoPlay
        self.showControls = showControls
        self.drmLicenseUrl = drmLicenseUrl
        self.certificateUrl = certificateUrl
    }
    
    func makeUIView(context: Context) -> GumletPlayerView {
        let playerView = GumletPlayerView(frame: .zero)
        let params = GumletInitParams(videoUrl: videoUrl, 
                                      autoPlay: autoPlay, 
                                      showControls: showControls, 
                                      drmLicenseUrl: drmLicenseUrl,
                                      certificateUrl: certificateUrl)
        playerView.load(params: params)
        return playerView
    }
    
    func updateUIView(_ uiView: GumletPlayerView, context: Context) {
        // Update controls visibility dynamically
        uiView.setControlsEnabled(showControls)
        
        // Note: For URL changes, we would typically check if context.coordinator.currentUrl != videoUrl and reload
        // But for this demo, the specific requirement is about controls toggle working.
    }
    
    static func dismantleUIView(_ uiView: GumletPlayerView, coordinator: ()) {
        uiView.onDestroy()
    }
}
#else
struct PlayerViewWrapper: View {
    let videoUrl: URL
    let autoPlay: Bool
    let showControls: Bool
    let drmLicenseUrl: String?
    let certificateUrl: String?
    
    // Add init matching the signature to avoid call site errors
    init(videoUrl: URL, 
         autoPlay: Bool = true, 
         showControls: Bool = true, 
         drmLicenseUrl: String? = nil,
         certificateUrl: String? = nil) {
        self.videoUrl = videoUrl
        self.autoPlay = autoPlay
        self.showControls = showControls
        self.drmLicenseUrl = drmLicenseUrl
        self.certificateUrl = certificateUrl
    }
    
    var body: some View {
        Text("Gumlet Video Player is only available on iOS")
            .foregroundStyle(.red)
            .padding()
    }
}
#endif
