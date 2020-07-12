//
//  QRCapturePlatformView.h
//  Pods-Runner
//
//  Created by xzp on 2020/5/15.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRCapturePlatformView : NSObject<FlutterPlatformView>

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args registrar:(NSObject<FlutterPluginRegistrar>*)registrar;

@end

NS_ASSUME_NONNULL_END
