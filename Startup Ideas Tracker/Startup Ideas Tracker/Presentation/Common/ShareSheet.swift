// MARK: - Share Sheet

import SwiftUI
import UIKit

// MARK: - View Representable
struct ShareSheet: UIViewControllerRepresentable {
    
    // MARK: - Properties
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    // MARK: - UIViewControllerRepresentable Methods
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
