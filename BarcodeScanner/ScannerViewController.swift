//
//  ScannerViewController.swift
//  BarcodeScanner
//
//  Created by Gabriel Pereira on 06/12/23.
//

import Foundation
import AVFoundation
import UIKit

protocol ScannerViewControllerDelegate: AnyObject {
    func scannerViewController(didFindBarcode barcode: String)
}

final class ScannerViewController: UIViewController {
    // MARK: - Properties
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var scannerDelegate: ScannerViewControllerDelegate?
    
    // MARK: - Initializer Methods
    init(scannerDelegate: ScannerViewControllerDelegate) {
        self.scannerDelegate = scannerDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            // TODO: - Add an error treatment here
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            // TODO: - Add an error treatment here
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            // TODO: - Add an error treatment here
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13]
        } else {
            // TODO: - Add an error treatment here
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else {
            // TODO: - Add an error treatment here
            return
        }
        
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            // TODO: - Add an error treatment here
            return
        }
        
        guard let barcode = machineReadableObject.stringValue else {
            // TODO: - Add an error treatment here
            return
        }
        
        scannerDelegate?.scannerViewController(didFindBarcode: barcode)
    }
}
