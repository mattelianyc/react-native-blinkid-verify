//
//  SwiftExampleViewController.swift
//  BlinkIDVerifySample
//
//  Created by Tomislav Cvetkovic on 21/04/2020.
//  Copyright © 2020 Microblink. All rights reserved.
//

import UIKit
import BlinkIDVerifyFramework

class SwiftExampleViewController: UIViewController {
    
    @IBAction func buttonAction(_ sender: UIButton) {
// Uncomment for customization to take effect
//        setupBlinkIDVerifyCustomization()
        
        showBlinkIDVerify()
    }
    
    private func setupBlinkIDVerifyCustomization() {
        // Localization
        MBVerifyLocalizationTheme.shared().localizationFileName = "BlinkIDVerify"

        // Colors
        if #available(iOS 13.0, *) {
            MBVerifyColorTheme.shared().primaryColor = UIColor { (traits) -> UIColor in
                if traits.userInterfaceStyle == .light {
                    return .orange
                } else {
                    return .magenta
                }
            }
        } else {
            MBVerifyColorTheme.shared().primaryColor = .orange
        }

        // Images
        MBVerifyImageTheme.shared().illustrationBackground = UIImage(named: "MyCustomImage")
        MBVerifyImageTheme.shared().illustrationHighlights = nil

        // Fonts
        MBVerifyFontTheme.shared().setupCustomFontFamily("Gotham")
        MBVerifyFontTheme.shared().navigationBarTitleFont = UIFont.boldSystemFont(ofSize: 22)

        // Corner radius
        MBVerifyViewTheme.shared().buttonCornerRadius = 6
    }
    
    private func showBlinkIDVerify() {
        // Valid until 2020-11-02
        let microblinkLicense = "sRwAAAEdY29tLm1pY3JvYmxpbmsuaWR2ZXJpZnlzYW1wbGUL8d7wHiSDPWXzsOjH37EBgNKbp/vtBBtEprRRkf7AFYpe7f4opZZzXBzypSVbkFQoH1rHaR4mRNBWN0akVkHzsSxpoteGF8o9vCJeXHVk863OJO+h8OpeUiTPgAQoD/ZPbS/B/2whUIdGikfR5kMdkx2GSakeeLlWU9fYU4VgWID2hjUmhQsPsNnz/BAQTzn1cyuOUw5He773McesDiz1uTnQHydk1Zz+Es7Ol8oi/8zwntlmqqW3S+1LGjI8wjAwEsx3c3WsYis="
        // Valid until 2021-01-09
        let visageLicense = "sSEAAEIGAAB42o1UTW/aQBC98ytG4lBSYdeQxiXcaFOkNEmRCk17XXsHWGHvWrtrqKX++M4YSMxXWx+9b968mXkzbXhWTiwQZpgutcnMQqGD0cdWu9WGR5WidggPWMFYZVj/nC2Vg2z3sqKXOb0A/VPOlSghqS5QdolPr0yh9KIL0w1K1EB8pZZowS8RPNrcgZmfjd9qoVgYLSxijtqHcO85sfNWpT6rmK2wZqkS5UmIN5AbqeYVkRNqK1OD0BVsRBX+pZhUaEgQSkcsRhNxUtUCd/1A0CLnSjEzG05KmaRiFUnpsYmUMCoKohdeGd2M+rd0Sr7VfaJubmxdhKFEForSFsZhlxmEluAKTNWcUmbEytAXZdw7jhMNSVsOLmFJNf+XcgKPS8txubGUVx0W0qhiL7QQ1leXUx2287iXZzpQj65pUHlQE7MNYffdy2e05IEm/PX15HtSqTVJRj6FAL6UVJOAT2jNGtNXvzTX4tX3VC3zrmvv/p7ePcBYpDizIl3B8yCMKXpSoBX1HFzlPOYdd3UkRU2mjb2bVcUFreMyywjYnNH9Xeft1Qk6NXmYvxQVKrmu2+FEXvA+w9cyT2gstHRKO0+mqcncu13P3RBuoig6AKZGp6W1tIBsUuv2OYPmQL5/e4QOG2CDyX6AtToC3QmaLGekxlEzzlQY3YZRL+xH/Yjt9vlXoWwFchfWsA6PYNjE9xg/Kr3JqY70xTkWF+ypujbGj5V1nldb6XrND2/dBXvEvTjoD26CwXUc9PpRMIivg/gmDuLoOuhH9D/uB70PveD2fbw3aKtNMzmaEuQotBtup/fGQUIHkC8TnUNPi8s91uyD8HC+hCzISnwX2eAMGmlpjZKnwLOUTyKFyRR+Mnyi4YfS0mxc91gdX0q6r7TJwjm10NuLzj1v7pjENW0r2Tls/QFEnvwQ"
        
        let baseURL = "https://blinkid-verify-ws.microblink.com"
        let verificationEndpoint = "/verification"
        
        let apiSettings = MBVerifyAPISettings(baseURL: baseURL, verificationEndpoint: verificationEndpoint)
                
        let configurator = MBBlinkIDVerifyConfigurator(microblinkLicense: microblinkLicense, visageLicense: visageLicense, apiSettings: apiSettings)
        
        // Document Filter
        
//        let documentCountries = [MBBlinkIDVerifyDocumentCountry(country: .slovenia),
//                                 MBBlinkIDVerifyDocumentCountry(country: .croatia)]
//        let documentRegions = [MBBlinkIDVerifyDocumentRegion(region: .none)]
//        let documentTypes = [MBBlinkIDVerifyDocumentType(type: .typeId)]
//        let documentFilter = MBBlinkIDVerifyDocumentFilter(documentCountries: documentCountries, documentRegions: documentRegions, documentTypes: documentTypes, allowScanning: true)
//        configurator.documentFilter = documentFilter
        
        // Generator of fields for Results screen
        
        configurator.documentFields = MBDocumentFields(idFields: [
            MBIDField(fieldType: .firstName, insertable: true, editable: true, validationBlock: nil, keyboardType: .default),
            MBIDField(fieldType: .lastName, insertable: true, editable: true, validationBlock: nil, keyboardType: .default),
            MBIDField(fieldType: .address, insertable: true, editable: true, validationBlock: nil, keyboardType: .default),
            MBIDField(fieldType: .dateOfBirth, insertable: true, editable: true, validationBlock: nil, keyboardType: .default),
            MBIDField(fieldType: .personalIdNumber, insertable: true, editable: true, validationBlock: { value -> Bool in
                return self.isIdValid(value: value)
            }, keyboardType: .numberPad)
        ], displayDocumentImagesOnResults: true)

        let verify = MBBlinkIDVerify(configurator: configurator, delegate: self)
        let viewController = verify.getInitialViewController()
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Example of validation methods
    
    private func isIdValid(value: Any) -> Bool {
        if let stringValue = value as? String, stringValue.count == 11, let _ = Int(stringValue) {
            return true
        }
        return false
    }
    
}

extension SwiftExampleViewController: MBBlinkIDVerifyDelegate {

    func verifyDidFinishSuccessfulVerification(_ verifyViewController: UIViewController, verifyItem: MBVerifyItem) {
        verifyViewController.dismiss(animated: true, completion: nil)
    }
    
    func verifyDidClose(_ verifyViewController: UIViewController) {
        verifyViewController.dismiss(animated: true, completion: nil)
    }
    
    // Optional delegate methods
    
    func verifyDidFinishScanningID(_ verifyViewController: UIViewController, combinedRecognizer: MBBlinkIdCombinedRecognizer, verifyItem: MBVerifyItem) {
        
    }
    
    func verifyDidFinishLiveness(_ verifyViewController: UIViewController, livenessRecognizer: MBLivenessRecognizer, verifyItem: MBVerifyItem) {
        
    }

}
