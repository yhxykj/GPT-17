
#import "NSString+Unicode.h"
#import <objc/runtime.h>

static inline void JSExchangeInstanceMethod(Class cls, SEL originalSEL, SEL newSEL) {
    Method originalMethod = class_getInstanceMethod(cls, originalSEL);
    Method newMethod = class_getInstanceMethod(cls, newSEL);
    class_addMethod(cls,
                    originalSEL,
                    class_getMethodImplementation(cls, originalSEL),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(cls,
                    newSEL,
                    class_getMethodImplementation(cls, newSEL),
                    method_getTypeEncoding(newMethod));
    method_exchangeImplementations(class_getInstanceMethod(cls, originalSEL),
                                   class_getInstanceMethod(cls, newSEL));
}

@implementation NSString (Unicode)

- (NSString *)_stringByReplaceUnicode {
    NSMutableString *convertedString = [self mutableCopy];
    [convertedString replaceOccurrencesOfString:@"\\U" withString:@"\\u" options:0 range:NSMakeRange(0, convertedString.length)];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);
    CFRelease(transform);
    return convertedString.copy;
}

@end

@implementation NSDictionary(JSUnicodeTransfomer)

+ (void)load {
    JSExchangeInstanceMethod(self,@selector(description),@selector(_description));
    JSExchangeInstanceMethod(self,@selector(descriptionWithLocale:),@selector(_descriptionWithLocale:));
    JSExchangeInstanceMethod(self,@selector(descriptionWithLocale:indent:),@selector(_descriptionWithLocale:indent:));
}

- (NSString *)_descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    return [[self _descriptionWithLocale:locale indent:level] _stringByReplaceUnicode];
}

- (NSString *)_descriptionWithLocale:(id)locale {
    return [[self _descriptionWithLocale:locale] _stringByReplaceUnicode];
}

- (NSString *)_description {
    return [[self _description] _stringByReplaceUnicode];
}

@end
