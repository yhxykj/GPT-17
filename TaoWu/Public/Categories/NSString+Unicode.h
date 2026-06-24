
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//解决xcode控制台以Unicode编码输出中文的问题
@interface NSString (Unicode)
/**
 替换文本中Unicode编码部分(reference:https://github.com/biggercoffee/ZXPUnicode/)

 @return 替换后的文本
 */
- (NSString *)_stringByReplaceUnicode;
@end

NS_ASSUME_NONNULL_END
