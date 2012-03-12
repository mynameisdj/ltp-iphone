#import "UINavigationBar+Custom.h"
#import <QuartzCore/QuartzCore.h>

@implementation UINavigationBar (UINavigationBar_Custom)

- (void)drawRect:(CGRect)rect {
    if (self.tag == 1) return;
//    NSLog(@"%@",self);
//    self.frame = CGRectMake(0, 0, 320, 40);
//    UIView *view = (UIView*)[[self.superview subviews] objectAtIndex:0];
//    NSLog(@"%s %@",__FUNCTION__,view);
//    int newY = ( (view.frame.origin.y == 0 || view.frame.origin.y == -8 ) ? -8 : 36 );
//    view.frame = CGRectMake(0, newY, 320, 416 + newY);
    [[UIImage imageNamed:@"title.png"] drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    NSLog(@"height %f", self.frame.size.height);
}

@end
