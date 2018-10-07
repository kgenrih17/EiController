//
//  Helper.h
//  EiController
//
//  Created by Genrih Korenujenko on 29.01.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

#ifndef Helper_h
#define Helper_h

#define BLOCK_SAFE_RUN(block, ...) block ? block(__VA_ARGS__) : nil
#define PERFORM_IF_RESPONDS_TO_SELECTOR(x) { @try { (x); } @catch (NSException *e) { if (![e.name isEqual:NSInvalidArgumentException]) @throw e; }}

static NSString * const TRANSFER_HTTP_BODY_FILE_NAME = @"transfer_http_body.txt";

#endif /* Helper_h */
