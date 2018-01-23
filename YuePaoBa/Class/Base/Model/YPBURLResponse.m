//
//  YPBURLResponse.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "YPBURLResponse.h"
#import <objc/runtime.h>

const NSUInteger kSuccessResponseCode = 100;

@implementation YPBURLResponseCode

@end

@implementation YPBURLResponse

- (Class)codeClass {
    return [YPBURLResponseCode class];
}

- (Class)paginatorClass {
    return [YPBPaginator class];
}

- (BOOL)success {
    return self.code.value.unsignedIntegerValue == kSuccessResponseCode;
}

- (NSString *)message {
    return self.code.message;
}

- (NSUInteger)nextPage {
    if ([self.paginator.page isEqualToNumber:self.paginator.pages]) {
        return NSNotFound;
    }
    
    return self.paginator.page.unsignedIntegerValue+1;
}

- (void)parseResponseWithDictionary:(NSDictionary *)dic {
    [self parseDataWithDictionary:dic inInstance:self];
}

- (void)parseDataWithDictionary:(NSDictionary *)dic inInstance:(id)instance {
    if (!dic || !instance) {
        return ;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSArray *properties = [NSObject propertiesOfClass:[instance class]];
    [properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *propertyName = (NSString *)obj;
        
        id value = [dic objectForKey:propertyName];
        if ([value isKindOfClass:[NSString class]]
            || [value isKindOfClass:[NSNumber class]]) {
            [instance setValue:value forKey:propertyName];
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            id property = [instance valueForKey:propertyName];
            Class subclass = [property class];
            if (!subclass) {
                NSString *classPropertyName = [propertyName stringByAppendingString:@"Class"];
                subclass = [instance valueForKey:classPropertyName];
            }
            id subinstance = [[subclass alloc] init];
            [instance setValue:subinstance forKey:propertyName];
            
            [self parseDataWithDictionary:(NSDictionary *)value inInstance:subinstance];
        } else if ([value isKindOfClass:[NSArray class]]) {
            Class subclass = [instance valueForKey:[propertyName stringByAppendingString:@"ElementClass"]];
            if (!subclass) {
                DLog(@"JSON Parsing Warning: cannot find element class of property: %@ in class: %@\n", propertyName, [[instance class] description])
                return;
            }
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [instance setValue:arr forKey:propertyName];
            
            for (id subobj in (NSArray *)value) {
                if ([subobj isKindOfClass:[NSDictionary class]]) {
                    id subinstance = [[subclass alloc] init];
                    [arr addObject:subinstance];
                    [self parseDataWithDictionary:(NSDictionary *)subobj inInstance:subinstance];
                } else if ([subobj isKindOfClass:[NSString class]]) {
                    [arr addObject:subobj];
                }
            }
        }
    }];
#pragma clang diagnostic pop
}

@end
