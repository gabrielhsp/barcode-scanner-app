//
//  AlertItem.swift
//  BarcodeScanner
//
//  Created by Gabriel Pereira on 09/01/24.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dismissButton: Alert.Button
}
