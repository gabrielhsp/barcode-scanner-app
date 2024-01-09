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
}
