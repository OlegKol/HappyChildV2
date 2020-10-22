//
//  DefaultGateway.h
//  IPEYE
//
//  Created by Roman Solodyashkin on 06.12.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#ifndef DefaultGateway_h
#define DefaultGateway_h

#ifdef __cplusplus
#define R_EXTERN        extern "C" __attribute__((visibility ("default")))
#else
#define R_EXTERN            extern __attribute__((visibility ("default")))
#endif

R_EXTERN char* gatewayIP(void);

#endif /* DefaultGateway_h */
