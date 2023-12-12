//
//  ScannerView.swift
//  BarcodeScanner
//
//  Created by Gabriel Pereira on 11/12/23.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ScannerViewController {
        ScannerViewController(scannerDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    final class Coordinator: NSObject, ScannerViewControllerDelegate {
        func scannerViewController(didFindBarcode barcode: String) {
            print(barcode)
        }
        
        func scannerViewController(didSurfaceError error: CameraError) {
            print(error.rawValue)
        }
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}
