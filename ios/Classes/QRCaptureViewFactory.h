//
//  QRCaptureViewFactory.h
//  Runner
//
//  Created by xzp 2020/5/15
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRCaptureViewFactory : NSObject<FlutterPlatformViewFactory>

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar;
    
@end

NS_ASSUME_NONNULL_END
