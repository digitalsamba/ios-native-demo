import UIKit
import WebKit

let ROOM_URL = "https://[teamNameHere].digitalsamba.com/[roomNameHere]";


class ViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!;
    
    func sendCommand(command: String) {
        webView.evaluateJavaScript("sambaEmbedded.\(command)")
    }
    
    @objc func toggleToolbar(sender: UIButton!) {
        self.sendCommand(command: "toggleToolbar()")
    }
    
    
    @objc func endSession(sender: UIButton!) {
        self.sendCommand(command: "endSession()")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad();

        let webViewConfiguration = WKWebViewConfiguration();
        webViewConfiguration.allowsInlineMediaPlayback = true;
        
        webView = WKWebView(frame: .zero, configuration: webViewConfiguration);
        webView.translatesAutoresizingMaskIntoConstraints = false;
        
        webView.uiDelegate = self;
            
        view.addSubview(webView);
        
        
        NSLayoutConstraint.activate([
            webView.heightAnchor.constraint(equalToConstant: view.frame.size.height - 200),
            webView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor)
       ]);
        
    
        let contentController = self.webView.configuration.userContentController;
        
        contentController.add(self, name: "messageHandler")
            
        let filePath = "frame.html";
        let query = "?roomUrl=" + ROOM_URL;
        
        print("aa");
        if let url = URL(string: Bundle.main.bundleURL.absoluteString + filePath + query) {
            print("bb");
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent());
        }
    }
    
    private func addButtons() {
        let toggleToolbarButton = UIButton(frame: .zero);
        toggleToolbarButton.backgroundColor = .blue;
        toggleToolbarButton.setTitle("Toggle toolbar", for: .normal);
        toggleToolbarButton.sizeToFit();
        toggleToolbarButton.addTarget(self, action: #selector(toggleToolbar), for: .touchUpInside)
        toggleToolbarButton.translatesAutoresizingMaskIntoConstraints = false;
        
        view.addSubview(toggleToolbarButton);
        
        NSLayoutConstraint.activate([
            toggleToolbarButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            toggleToolbarButton.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            toggleToolbarButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ]);
        
        let endSessionBtn = UIButton(frame: .zero);
        endSessionBtn.backgroundColor = .blue;
        endSessionBtn.setTitle("End session", for: .normal);
        endSessionBtn.sizeToFit();
        endSessionBtn.addTarget(self, action: #selector(endSession), for: .touchUpInside)
        endSessionBtn.translatesAutoresizingMaskIntoConstraints = false;
        
        view.addSubview(endSessionBtn);
        
        NSLayoutConstraint.activate([
            endSessionBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 140),
            endSessionBtn.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            endSessionBtn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ]);
    }

    
    @available(iOS 15.0, *)
    func webView(_ webView: WKWebView,
        requestMediaCapturePermissionFor
        origin: WKSecurityOrigin,initiatedByFrame
        frame: WKFrameInfo,type: WKMediaCaptureType,
        decisionHandler: @escaping (WKPermissionDecision) -> Void){
         decisionHandler(.grant)
     }
}

extension ViewController: WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let dict = message.body as? [String : [String: String]] else {
            return
        }
            
        guard let payload: [String : String] = dict["message"] else {return};
        
        
        
        if let eventType = payload["type"] {
            if eventType == "roomJoined" {
                addButtons();
            }
        }
        
        
        print(dict)
    }
}
