//
//  QRCaptureView.m
//  Pods-Runner
//
//  Created by xzp on 2020/5/15.
//

#import "QRCaptureView.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCaptureView () <AVCaptureMetadataOutputObjectsDelegate, FlutterPlugin>

@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) FlutterMethodChannel *channel;
@property(nonatomic, weak) AVCaptureVideoPreviewLayer *captureLayer;

@end

@implementation QRCaptureView

- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}
// init capture frame
- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    if (self = [super initWithFrame:frame]) {
        NSString *name = [NSString stringWithFormat:@"plugins/qr_capture/method_%lld", viewId];
        FlutterMethodChannel *channel = [FlutterMethodChannel
                                         methodChannelWithName:name
                                         binaryMessenger:registrar.messenger];
        self.channel = channel;
        [registrar addMethodCallDelegate:self channel:channel];
        
        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.captureLayer = layer;
        
        layer.backgroundColor = [UIColor yellowColor].CGColor;
        [self.layer addSublayer:layer];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        if ([self.session canAddInput: input])
        {
            [self.session addInput: input];
        }
        if ([self.session canAddOutput: output])
        {
            [self.session addOutput: output];
        }
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
       
        output.metadataObjectTypes = output.availableMetadataObjectTypes;
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [output setMetadataObjectTypes:@[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
        AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
        AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode]];
        
        [self.session startRunning];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.captureLayer.frame = self.bounds;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    // stop camera
    if ([call.method isEqualToString:@"pause"]) {
        [self pause];
    }
    // resume camera from state 'pause'
    else if ([call.method isEqualToString:@"resume"]) {
        [self resume];
    }
    //Set your phone's flash
    else if ([call.method isEqualToString:@"setTorchMode"]) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (!device.hasTorch) {
            return;
        }
        NSNumber *isOn = call.arguments;
        [device lockForConfiguration:nil];
        if (isOn.boolValue) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
    }
}

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {}


- (void)resume {
    [self.session startRunning];
}
     
- (void)pause {
    [self.session stopRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
        NSString *value = metadataObject.stringValue;
        if (value.length && self.channel) {
            [self.channel invokeMethod:@"onCaptured" arguments:value];
        }
    }
}

- (void)dealloc {
    [self.session stopRunning];
}

@end
