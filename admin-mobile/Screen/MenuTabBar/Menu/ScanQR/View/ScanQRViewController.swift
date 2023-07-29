//
//  ScanQRViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 16/02/2023.
//

import UIKit
import AVFoundation
class ScanQRViewController: UIViewController {
    let alert = AlertView.instance
    private var VM = ScanViewModel()
    @IBOutlet weak var topbar: UIView!
    @IBOutlet weak var msg: UILabel!
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // stop video capture
        captureSession.stopRunning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // start video capture
        if let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            self.captureSession.startRunning()
        }

        configNaviBar()
    }
    
    func configNaviBar() {
        navigationController?.navigationBar.tintColor = .label
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        title.text = "Soát vé QR"
        title.font = UIFont(name: "Helvetica Bold", size: 18)
        title.textAlignment = .center
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: title)]
    }
    
}

extension ScanQRViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame  = barCodeObject!.bounds
            
            if metadataObj.stringValue !=  nil {
//                let infoTicket = decodeRSA(from: metadataObj.stringValue!)
                let infoTicket = metadataObj.stringValue!
                let infoTicketArr = infoTicket.components(separatedBy: "-")
                if infoTicketArr.count == 3 {
                    let info = VadilateTicketDto(eventId: Int(infoTicketArr[0]), ownerId: Int(infoTicketArr[2]), ticketCode: infoTicketArr[1])
                    VM.checkVadilateTicket(from: info)
                    self.captureSession.stopRunning()
                } else {
                    alert.showAlert(title: "Failure", message: "Đây không phải QR vé", alertType: .failure)
                    qrCodeFrameView?.frame = CGRect.zero
                    self.captureSession.stopRunning()
                }
                

            }
        }
    }
}

extension ScanQRViewController {

    func configuration() {
        // lay camera sau
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            showToast(message: "Lỗi trong lấy camera của thiết bị", font: .systemFont(ofSize: 12))
            return
        }
        
        do {
            //
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // set input device to session
            captureSession.addInput(input)
            
            // init avcapture meta data output
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // set delegate use dispast queue to callback
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // init video preview
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            videoPreviewLayer?.frame = view.layer.frame
            view.layer.addSublayer(videoPreviewLayer!)
            
            
            // start video capture
            captureSession.startRunning()
            
            
            // init qr code frame
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor(red: 94/255, green: 135/255, blue: 240/255, alpha: 1).cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
                
            }
        } catch {
            return
        }
        
        alert.delegate = self
        
        initViewModel()
        observeEvent()
    }

    func initViewModel() {
        
    }

    // Data binding event observe - communication
    func observeEvent() {
        var loader:UIAlertController?

        VM.eventHandler = { [weak self] event in
            switch event {
            case .loading:
                loader = self?.loader()
            case .stopLoading:
                self?.stoppedLoader(loader: loader ?? UIAlertController())
            case .dataLoaded: break
            case .error(let error):
                DispatchQueue.main.async {
                    self?.qrCodeFrameView?.frame = CGRect.zero
                    self?.stoppedLoader(loader: loader ?? UIAlertController())
                    self?.alert.showAlert(title: "Failure", message: error ?? "Lỗi trong quá trình xác thực vé", alertType: .failure)
                }
            case .vadilateTicket:
                DispatchQueue.main.async {
                    self?.qrCodeFrameView?.frame = CGRect.zero
                    self?.alert.showAlert(title: "Success", message: "Đã kiểm tra vé thành công", alertType: .success)
                }
                
            }
        }
    }
    
}

extension ScanQRViewController: AlertViewDelegate{
    func alertViewDidDismiss() {
        // Trả lại quyền kiểm soát cho lớp gọi
        self.captureSession.startRunning()
    }

}
