//
//  NSString+crypt.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/12.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "NSString+crypt.h"
#import <CommonCrypto/CommonCrypto.h>

static NSString *const kPrivateKeyPool = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+=/*+.,.;'?<>`~^%";

@implementation NSString (crypt)

- (NSString *)cryptedStringWithPassword:(NSString *)password withOperation:(CCOperation)op {
    
    NSData *cryptedData;
    if (op == kCCEncrypt) {
        cryptedData = [self dataUsingEncoding:NSUTF8StringEncoding];
    } else {
        NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
        unsigned char whole_byte;
        char byte_chars[3] = {'\0','\0','\0'};
        int i;
        for (i=0; i < [self length] / 2; i++) {
            byte_chars[0] = [self characterAtIndex:i*2];
            byte_chars[1] = [self characterAtIndex:i*2+1];
            whole_byte = strtol(byte_chars, NULL, 16);
            [data appendBytes:&whole_byte length:1];
        }
        cryptedData = data;
    }
    
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [password getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [cryptedData length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    bzero(buffer, bufferSize);
    
    NSString *resultString;
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(op, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES128,
                                          NULL /* initialization vector (optional) */,
                                          [cryptedData bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        //NSData *data = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        //return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        if (op == kCCEncrypt) {
            resultString = [NSString hexStringFromBuffer:buffer length:numBytesEncrypted];
        } else {
            resultString = [[NSString alloc] initWithBytes:buffer length:numBytesEncrypted encoding:NSUTF8StringEncoding];
        }
    }
    
    free(buffer); //free the buffer;
    return resultString;
}

- (NSString *)encryptedStringWithPassword:(NSString *)password {
    return [self cryptedStringWithPassword:password withOperation:kCCEncrypt]; 
}

- (NSString *)decryptedStringWithPassword:(NSString *)password; {
    return [self cryptedStringWithPassword:password withOperation:kCCDecrypt];
}

- (NSString *)decryptedStringWithKeys:(NSArray *)keys {
    NSMutableString *password = [NSMutableString string];
    for (NSNumber *key in keys) {
        [password appendString:[kPrivateKeyPool substringWithRange:NSMakeRange(key.unsignedIntegerValue-1, 1)]];
    }
    
    return [self decryptedStringWithPassword:[password.md5 substringToIndex:16]];
}

+ (NSString *)hexStringFromBuffer:(void *)buffer length:(NSUInteger)length {
    Byte *bytes = buffer;
    
    NSMutableString *hexString = [NSMutableString string];
    for (NSUInteger i = 0; i < length; ++i) {
        [hexString appendString:[NSString stringWithFormat:@"%02x", bytes[i]]];
    }
    
    return hexString.length > 0 ? hexString : nil;
}

- (NSString *)md5 {
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    CC_MD5_Update (&md5, [self UTF8String], (unsigned int)[self length]);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    // return s
    return s;
}
@end
