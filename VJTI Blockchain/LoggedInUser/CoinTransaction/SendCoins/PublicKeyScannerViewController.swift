//
//  QRCodeScannerViewController.swift
//  VJTI Blockchain
//
//  Created by Ameya Daddikar on 27/05/19.
//  Copyright © 2019 Veermata Jijabai Technological Institute. All rights reserved.
//

import Foundation
import UIKit
import QRCodeReader

import AVFoundation
import UIKit

class PublicKeyScannerViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    
    var scannedPubKey : String?
    
    private func opencam (){
        guard checkScanPermissions() else { return }
        
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self
        
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                print("Completion with result: \(result.value) of type \(result.metadataType)")
                
                self.scannedPubKey = result.value;
                
                self.performSegue(withIdentifier: "qrscansuccess", sender: self);
            }
        }
        
        present(readerVC, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        
        opencam();
    }
    
    @IBOutlet weak var previewView: QRCodeReaderView! {
        didSet {
            previewView.setupComponents(with: QRCodeReaderViewControllerBuilder {
                $0.reader                 = reader
                $0.showTorchButton        = true
                $0.showSwitchCameraButton = true
                $0.showCancelButton       = false
                $0.showOverlayView        = true
                $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
            })
        }
    }
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton         = true
            $0.preferredStatusBarStyle = .lightContent
            $0.showOverlayView         = true
            $0.rectOfInterest          = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
            
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    // MARK: - Actions
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                            //UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }
    
    
   @IBAction func scanInModalAction(_ sender: AnyObject)
    {
        print("Called")
        opencam();
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "qrscansuccess":
                let receiverVC = segue.destination as! TransactionDetailsViewController;
                
                receiverVC.scannedPubKey = scannedPubKey;
                
                break;
        case .none:
            break;
        case .some(_):
            break;
        }
    }
    
//    @IBAction func scanInPreviewAction(_ sender: Any) {
//        guard checkScanPermissions(), !reader.isRunning else { return }
//
//        reader.didFindCode = { result in
//            print("Completion with result: \(result.value) of type \(result.metadataType)")
//        }
//
//        reader.startScanning()
//    }

    
    // MARK: - QRCodeReader Delegate Methods
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true) { [weak self] in
//            let alert = UIAlertController(
//                title: "QRCodeReader",
//                message: String (format:"%@ (of type %@)", result.value, result.metadataType),
//                preferredStyle: .alert
//            )
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
//            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capture to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
}
