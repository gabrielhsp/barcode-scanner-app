//
//  ScannerViewController.swift
//  BarcodeScanner
//
//  Created by Gabriel Pereira on 06/12/23.
//

import AVFoundation
import UIKit

enum CameraError: String {
    case invalidDeviceInput = "Something is wrong with camera. We are unable to capture the input."
    case invalidScannedValue = "The vlaue scanned is not valid. This app scans EAN-8 and EAN-13."
}

protocol ScannerViewControllerDelegate: AnyObject {
    func scannerViewController(didFindBarcode barcode: String)
    func scannerViewController(didSurfaceError error: CameraError)
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
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        guard let previewLayer = previewLayer else {
            scannerDelegate?.scannerViewController(didSurfaceError: .invalidDeviceInput)
            return
        }
        
        previewLayer.frame = view.layer.bounds
    }
    
    // MARK: - Private Methods
    private func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            scannerDelegate?.scannerViewController(didSurfaceError: .invalidDeviceInput)
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            scannerDelegate?.scannerViewController(didSurfaceError: .invalidDeviceInput)
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            scannerDelegate?.scannerViewController(didSurfaceError: .invalidDeviceInput)
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13]
        } else {
            scannerDelegate?.scannerViewController(didSurfaceError: .invalidDeviceInput)
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
            scannerDelegate?.scannerViewController(didSurfaceError: .invalidScannedValue)
            return
        }
        
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate?.scannerViewController(didSurfaceError: .invalidScannedValue)
            return
        }
        
        guard let barcode = machineReadableObject.stringValue else {
            scannerDelegate?.scannerViewController(didSurfaceError: .invalidScannedValue)
            return
        }
        
        captureSession.stopRunning()
        scannerDelegate?.scannerViewController(didFindBarcode: barcode)
    }
}
