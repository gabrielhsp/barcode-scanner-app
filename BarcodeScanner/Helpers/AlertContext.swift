//
//  AlertContext.swift
//  BarcodeScanner
//
//  Created by Gabriel Pereira on 09/01/24.
//

import SwiftUI

struct AlertContext {
    static let invalidDeviceInput = AlertItem(title: Text("Invalid Device Input"),
                                              message: Text("Something is wrong with camera. We are unable to capture the input."),
                                              dismissButton: .default(Text("Ok")))
    
    static let invalidScannedType = AlertItem(title: Text("Invalid Scan Type"),
                                              message: Text("The vlaue scanned is not valid. This app scans EAN-8 and EAN-13."),
                                              dismissButton: .default(Text("Ok")))
}
