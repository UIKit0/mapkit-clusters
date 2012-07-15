
// BSD License. <jano@jano.com.es>

#import "AnnotationView.h"

@implementation AnnotationView

@synthesize iconImage;
@synthesize spawnCoordinate;


- (id)initWithAnnotation:(id <MKAnnotation>)theAnnotation 
         reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithAnnotation:theAnnotation reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        
        // show title and subtitle, and make the background transparent
        self.opaque = NO;
        self.canShowCallout = TRUE;
        
        self.iconImage = [UIImage imageNamed:@"emoji-ghost"];
        
        // set the annotation frame to the max needed size
        self.frame = CGRectMake(0,0,self.iconImage.size.width, self.iconImage.size.height);
    }
    return self;
}


- (void)setAnnotation:(id <MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    [self.iconImage drawInRect:rect];
}


@end
