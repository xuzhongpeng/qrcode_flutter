#import "QrcodeFlutterPlugin.h"
#import "QRCaptureViewFactory.h"

@implementation QrcodeFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    QRCaptureViewFactory *factory = [[QRCaptureViewFactory alloc] initWithRegistrar:registrar];
    [registrar registerViewFactory:factory withId:@"plugins/qr_capture_view"];
    FlutterMethodChannel* channel = [FlutterMethodChannel
               methodChannelWithName:@"plugins/qr_capture/method"
               binaryMessenger:[registrar messenger]];
    QrcodeFlutterPlugin *plugin = [[QrcodeFlutterPlugin alloc] init];
    [registrar addMethodCallDelegate:plugin channel:channel];
}
- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
        if ([@"getQrCodeByImagePath" isEqualToString:call.method]) {
            NSString *path = call.arguments;
            UIImage *image=[[UIImage alloc]initWithContentsOfFile:path];
            NSArray *array=[QrcodeFlutterPlugin readQRCodeFromImage:image];
            NSMutableString *str = [[NSMutableString alloc] init];
            NSMutableArray *res = [[NSMutableArray alloc] init];
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CIQRCodeFeature *temp = (CIQRCodeFeature *)obj;
                    [res addObject:temp.messageString];
                }];
            result(res);
        }
}
+ (NSArray *)readQRCodeFromImage:(UIImage *)image{ 
    // 创建一个CIImage对象
    CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage options:nil];
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}]; // 软件渲染
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];// 二维码识别
    
    [VNImageRequestHandler];
    
    // 注意这里的CIDetectorTypeQRCode
    NSArray *features = [detector featuresInImage:ciImage];
    for (CIQRCodeFeature *feature in features) {
        NSLog(@"msg = %@",feature.messageString); // 打印二维码中的信息
    }
    return features;
}
@end
