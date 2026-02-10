import SwiftUI
import GumletVideoPlayer

struct ContentView: View {
    @State private var videoUrlString: String = "https://video.gumlet.io/5f462c1561cf8a766464ffc4/67062bea5d11d5a0fec5d026/main.m3u8"
    @State private var drmUrlString: String = "https://fairplay.gumlet.com/licence/5f2bdde3e93619b8859d8831/67062bea5d11d5a0fec5d026?expires=1769869427248&token=d696d48059bf01593326f802e748f087d33b1635"
    @State private var certificateUrlString: String = "https://fairplay.gumlet.com/certificate/5f2bdde3e93619b8859d8831"
    @State private var showControls: Bool = true
    @State private var isPlaying: Bool = false
    @State private var showLogs: Bool = false
    
    // Material 3 Purple-ish color
    let primaryColor = Color(red: 0.4, green: 0.2, blue: 0.6)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Configuration")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Video URL")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            TextField("Enter video URL", text: $videoUrlString)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.URL)
                        }
                        .padding(12)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("DRM License URL (Optional)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            TextField("Enter license URL", text: $drmUrlString)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.URL)
                        }
                        .padding(12)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Certificate URL (Required for DRM)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            TextField("Enter certificate URL", text: $certificateUrlString)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.URL)
                        }
                        .padding(12)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                        
                        Toggle("Show Player Controls", isOn: $showControls)
                            .padding(.vertical, 8)
                            .tint(primaryColor)
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    Button(action: {
                        isPlaying = true
                    }) {
                        Text("Play Video")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(primaryColor)
                            .cornerRadius(28)
                    }
                    .disabled(videoUrlString.isEmpty)
                    
                    Spacer()
                    
                    Text("Powered by Gumlet")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                    Button("Show Debug Logs") {
                        showLogs = true
                    }
                    .foregroundColor(Color.gray)
                    .font(.footnote)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity)
                }
                .padding()
            }
            .navigationTitle("Gumlet Video Player")
            .navigationDestination(isPresented: $isPlaying) {
                if let url = URL(string: videoUrlString.trimmingCharacters(in: .whitespacesAndNewlines)) {
                    PlayerScreen(
                        url: url,
                        autoPlay: true,
                        showControls: showControls,
                        drmLicenseUrl: drmUrlString.isEmpty ? nil : drmUrlString.trimmingCharacters(in: .whitespacesAndNewlines),
                        certificateUrl: certificateUrlString.isEmpty ? nil : certificateUrlString.trimmingCharacters(in: .whitespacesAndNewlines)
                    )
                }
            }
            .sheet(isPresented: $showLogs) {
                DebugLogView()
            }
        }
    }
}

struct DebugLogView: View {
    @ObservedObject var logger = GumletLogger.shared
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(logger.logs, id: \.self) { log in
                            Text(log)
                                .font(.system(.caption, design: .monospaced))
                                .padding(4)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(4)
                        }
                    }
                    .padding()
                }
                .onChange(of: logger.logs) { oldValue, newValue in
                   // Auto scroll could go here
                }
            }
            .navigationTitle("SDK Logs")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear") {
                        logger.clear()
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

struct PlayerScreen: View {
    let url: URL
    let autoPlay: Bool
    let showControls: Bool
    let drmLicenseUrl: String?
    let certificateUrl: String?
    
    var body: some View {
        PlayerViewWrapper(
            videoUrl: url,
            autoPlay: autoPlay,
            showControls: showControls,
            drmLicenseUrl: drmLicenseUrl,
            certificateUrl: certificateUrl
        )
        .background(Color.black)
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
