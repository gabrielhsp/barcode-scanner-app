//
//  BarcodeScannerViewModel.swift
//  BarcodeScanner
//
//  Created by Gabriel Pereira on 09/01/24.
//

import SwiftUI

final class BarcodeScannerViewModel: ObservableObject {
    // MARK: - Properties
    @Published var scannedCode = ""
    @Published var alertItem: AlertItem?
    
    var statusText: String {
        return scannedCode.isEmpty ? "Not Yet Scanned" : scannedCode
    }
    
    var statusTextColor: Color {
        return scannedCode.isEmpty ? .red : .green
    }
}
