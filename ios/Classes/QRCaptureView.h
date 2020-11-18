//
//  QRCaptureView.h
//  Pods-Runner
//
//  Created by xzp on 2020/5/15.
//

#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRCaptureView : UIView

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args registrar:(NSObject<FlutterPluginRegistrar>*)registrar;
- (void)pause;
@end

NS_ASSUME_NONNULL_END
