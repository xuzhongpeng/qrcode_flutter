//
//  QRCapturePlatformView.m
//  Pods-Runner
//
//  Created by xzp on 2020/5/15.
//

#import "QRCapturePlatformView.h"
#import "QRCaptureView.h"

@interface QRCapturePlatformView ()

@property(nonatomic, strong) QRCaptureView *captureView;

@end

@implementation QRCapturePlatformView

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    if (self = [super init]) {
        self.captureView = [[QRCaptureView alloc] initWithFrame:frame viewIdentifier:viewId arguments:args registrar:registrar];
        self.captureView.frame = frame;
        self.captureView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (nonnull UIView *)view {
    return self.captureView;
}
//stop camera
- (void)dealloc{
    [self.captureView pause];
}

@end
