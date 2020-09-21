//
//  ObjCExampleViewController.m
//  BlinkIDVerifySample
//
//  Created by Tomislav Cvetkovic on 21/04/2020.
//  Copyright © 2020 Microblink. All rights reserved.
//

#import "ObjCExampleViewController.h"
#import <BlinkIDVerifyFramework/BlinkIDVerifyFramework.h>

@interface ObjCExampleViewController () <MBBlinkIDVerifyDelegate>

@end

@implementation ObjCExampleViewController

- (IBAction)buttonAction:(UIButton *)sender {
// Uncomment for customization to take effect
//    [self setupBlinkIDVerifyCustomization];
    
    [self showBlinkIDVerify];
}

- (void)setupBlinkIDVerifyCustomization {
    // Localization
    [MBVerifyLocalizationTheme sharedInstance].localizationFileName = @"BlinkIDVerify";

    // Colors
    if (@available(iOS 13.0, *)) {
        [MBVerifyColorTheme sharedInstance].primaryColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traits) {
            if (traits.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return [UIColor orangeColor];
            } else {
                return [UIColor magentaColor];
            }
        }];
    } else {
        [MBVerifyColorTheme sharedInstance].primaryColor = [UIColor orangeColor];
    }

    // Images
    [MBVerifyImageTheme sharedInstance].illustrationBackground = [UIImage imageNamed:@"MyCustomImage"];
    [MBVerifyImageTheme sharedInstance].illustrationHighlights = nil;

    // Fonts
    [[MBVerifyFontTheme sharedInstance] setupCustomFontFamily:@"Gotham"];
    [MBVerifyFontTheme sharedInstance].navigationBarTitleFont = [UIFont boldSystemFontOfSize:22];

    // Corner radius
    [MBVerifyViewTheme sharedInstance].buttonCornerRadius = 6;
}

- (void)showBlinkIDVerify {
    // Valid until 2020-11-02
    NSString *microblinkLicense = @"sRwAAAEdY29tLm1pY3JvYmxpbmsuaWR2ZXJpZnlzYW1wbGUL8d7wHiSDPWXzsOjH37EBgNKbp/vtBBtEprRRkf7AFYpe7f4opZZzXBzypSVbkFQoH1rHaR4mRNBWN0akVkHzsSxpoteGF8o9vCJeXHVk863OJO+h8OpeUiTPgAQoD/ZPbS/B/2whUIdGikfR5kMdkx2GSakeeLlWU9fYU4VgWID2hjUmhQsPsNnz/BAQTzn1cyuOUw5He773McesDiz1uTnQHydk1Zz+Es7Ol8oi/8zwntlmqqW3S+1LGjI8wjAwEsx3c3WsYis=";
    // Valid until 2021-01-09
    NSString *visageLicense = visageLicense = @"sSEAAEIGAAB42o1UTW/aQBC98ytG4lBSYdeQxiXcaFOkNEmRCk17XXsHWGHvWrtrqKX++M4YSMxXWx+9b968mXkzbXhWTiwQZpgutcnMQqGD0cdWu9WGR5WidggPWMFYZVj/nC2Vg2z3sqKXOb0A/VPOlSghqS5QdolPr0yh9KIL0w1K1EB8pZZowS8RPNrcgZmfjd9qoVgYLSxijtqHcO85sfNWpT6rmK2wZqkS5UmIN5AbqeYVkRNqK1OD0BVsRBX+pZhUaEgQSkcsRhNxUtUCd/1A0CLnSjEzG05KmaRiFUnpsYmUMCoKohdeGd2M+rd0Sr7VfaJubmxdhKFEForSFsZhlxmEluAKTNWcUmbEytAXZdw7jhMNSVsOLmFJNf+XcgKPS8txubGUVx0W0qhiL7QQ1leXUx2287iXZzpQj65pUHlQE7MNYffdy2e05IEm/PX15HtSqTVJRj6FAL6UVJOAT2jNGtNXvzTX4tX3VC3zrmvv/p7ePcBYpDizIl3B8yCMKXpSoBX1HFzlPOYdd3UkRU2mjb2bVcUFreMyywjYnNH9Xeft1Qk6NXmYvxQVKrmu2+FEXvA+w9cyT2gstHRKO0+mqcncu13P3RBuoig6AKZGp6W1tIBsUuv2OYPmQL5/e4QOG2CDyX6AtToC3QmaLGekxlEzzlQY3YZRL+xH/Yjt9vlXoWwFchfWsA6PYNjE9xg/Kr3JqY70xTkWF+ypujbGj5V1nldb6XrND2/dBXvEvTjoD26CwXUc9PpRMIivg/gmDuLoOuhH9D/uB70PveD2fbw3aKtNMzmaEuQotBtup/fGQUIHkC8TnUNPi8s91uyD8HC+hCzISnwX2eAMGmlpjZKnwLOUTyKFyRR+Mnyi4YfS0mxc91gdX0q6r7TJwjm10NuLzj1v7pjENW0r2Tls/QFEnvwQ";
    
    NSString *baseURL = @"https://blinkid-verify-ws.microblink.com";
    NSString *verificationEndpoint = @"/verification";
    
    MBVerifyAPISettings *apiSettings = [[MBVerifyAPISettings alloc] initWithBaseURL:baseURL verificationEndpoint:verificationEndpoint];
    
//    NSArray *documentCountries = @[
//        [[MBBlinkIDVerifyDocumentCountry alloc] initWithCountry:MBCountryCroatia],
//        [[MBBlinkIDVerifyDocumentCountry alloc] initWithCountry:MBCountrySlovenia]
//    ];
//    NSArray *documentRegions = @[
//        [[MBBlinkIDVerifyDocumentRegion alloc] initWithRegion:MBRegionNone]
//    ];
//    NSArray *documentTypes = @[
//        [[MBBlinkIDVerifyDocumentType alloc] initWithType:MBTypeId],
//        [[MBBlinkIDVerifyDocumentType alloc] initWithType:MBTypeFinCard]
//    ];
//    MBBlinkIDVerifyDocumentFilter *documentFilter = [[MBBlinkIDVerifyDocumentFilter alloc] initWithDocumentCountries:documentCountries documentRegions:documentRegions documentTypes:documentTypes allowScanning:YES];
    
    MBIDField *firstName = [[MBIDField alloc] initWithFieldType:MBIDFieldTypeFirstName insertable:YES editable:YES validationBlock:nil keyboardType:UIKeyboardTypeDefault];
    MBIDField *personalIdNumber = [[MBIDField alloc] initWithFieldType:MBIDFieldTypePersonalIdNumber insertable:YES editable:YES validationBlock:^BOOL(NSString *value) {
        return [self isPersonalIDValid:value];
    } keyboardType:UIKeyboardTypeDefault];
    
    MBDocumentFields *documentFields = [[MBDocumentFields alloc] initWithIDFields:@[firstName, personalIdNumber]];
    
    MBBlinkIDVerifyConfigurator *configurator = [[MBBlinkIDVerifyConfigurator alloc] initWithMicroblinkLicense:microblinkLicense visageLicense:visageLicense apiSettings:apiSettings];
//    configurator.documentFilter = documentFilter;
    configurator.documentFields = documentFields;

    MBBlinkIDVerify *verify = [[MBBlinkIDVerify alloc] initWithConfigurator:configurator delegate:self];
    UIViewController *viewController = [verify getInitialViewController];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (BOOL)isPersonalIDValid:(NSString *)value {
    if ([value length] == 11) {
        return YES;
    }
    return NO;
}

#pragma mark - MBBlinkIDVerifyDelegate

- (void)verifyDidFinishSuccessfulVerification:(nonnull UIViewController *)verifyViewController verifyItem:(nonnull MBVerifyItem *)verifyItem {
    [verifyViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)verifyDidClose:(UIViewController *)verifyViewController {
    [verifyViewController dismissViewControllerAnimated:YES completion:nil];
}

// Optional delegate methods

- (void)verifyDidFinishScanningID:(nonnull UIViewController *)verifyViewController combinedRecognizer:(nonnull MBBlinkIdCombinedRecognizer *)combinedRecognizer {
    NSLog(@"verifyDidFinishScanningID");
}

- (void)verifyDidFinishLiveness:(nonnull UIViewController *)verifyViewController livenessRecognizer:(nonnull MBLivenessRecognizer *)livenessRecognizer {
    NSLog(@"verifyDidFinishLiveness");
}
@end
