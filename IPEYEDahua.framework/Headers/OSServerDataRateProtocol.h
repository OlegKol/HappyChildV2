//
//  OSServerDataRateProtocol.h
//  IPEYEDahua
//
//  Created by Roman Solodyashkin on 21.10.2020.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class OSServerDataRate;

@protocol OSServerDataRateDelegate <NSObject>
@required
- (void)dataRateDidUpdate:(OSServerDataRate*)rate;
- (void)dataRateDidEnd:(OSServerDataRate*)rate error:(NSError*)error;
@end

NS_ASSUME_NONNULL_END
