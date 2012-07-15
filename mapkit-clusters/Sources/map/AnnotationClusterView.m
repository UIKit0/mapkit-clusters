
// BSD License. <jano@jano.com.es>

#import "AnnotationClusterView.h"

/* 
Annotation that displays a badge with whatever number is set in badgeNumber.
 
Little problem: The number can be set at any time, but not the view frame. 
Therefore I set a frame big enough for 3 digits in the initWithAnnotation method.
There is an unfortunate consequence: when there is only one digit, the blank space 
at the right of the badge still belongs to the frame and registers touches.
This can also be seen in the offset of the callout (which can be adjusted).
A solution would be to use three "reuseIdentifier" for one, two, and three digits.
*/

@implementation AnnotationClusterView

@synthesize badgeNumber, badgeImage, badgeFont;


- (id)initWithAnnotation:(id <MKAnnotation>)annotation 
         reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        
        // show title and subtitle, and make the background transparent
        self.opaque = NO;
        self.canShowCallout = TRUE;
        
        // Badge is an image with 14+1+14 pixels width and 15+1+15 pixels height.
        // Setting the caps to 14 and 15 preserves the original size of the sides, so only the pixel in the middle is stretched.
        UIImage *image = [UIImage imageNamed:@"badge"];
        self.badgeImage = [image stretchableImageWithLeftCapWidth:(image.size.width-1)/2 topCapHeight:(image.size.height-1)/2];
        
        // what size do we need to show 3 digits using the given font?
        self.badgeFont = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
        CGSize maxStringSize = [@"999" sizeWithFont:self.badgeFont];
        
        // set the annotation frame to the max needed size
        self.frame = CGRectMake(0,0, 
                                self.badgeImage.size.width + maxStringSize.width, 
                                self.badgeImage.size.height + maxStringSize.height);
    }
    return self;
}


- (void)setAnnotation:(id <MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    
    // TODO: fix the frame is too big as shown when drawing this
    //UIImage *image = [UIImage imageNamed:@"emoji-ghost"];
    //[image drawInRect:rect];
    
    // note: if there is only one element, it should paing an icon but not a badge
    
    // get the string to show and calculate its size
    NSString *string = [NSString stringWithFormat:@"%d",self.badgeNumber];
    CGSize stringSize = [string sizeWithFont:self.badgeFont];
    
    // paint the image after stretching it enough to acommodate the string 
    CGSize stretchedSize = CGSizeMake(self.badgeImage.size.width + stringSize.width, 
                                      self.badgeImage.size.height);
    
    // -20% lets the text go into the arc of the bubble. There is a weird visual effect without abs.
    stretchedSize.width -= abs(stretchedSize.width *.20);
    
    [self.badgeImage drawInRect:CGRectMake(0, 0, 
                                           stretchedSize.width, 
                                           stretchedSize.height)];
    
    [[UIColor yellowColor] set];
    
    // x is the center of the image minus half the width of the string.
    // Same thing for y, but 3 pixels less because the image is a bubble plus a 6px shadow underneath.
    float height = stretchedSize.height/2 - stringSize.height/2 - 3;
    height -= abs(height*.1);
    CGRect stringRect = CGRectMake(stretchedSize.width/2 - stringSize.width/2,
                                   height,
                                   stringSize.width, 
                                   stringSize.height);
    [string drawInRect:stringRect withFont:badgeFont];
}

@end
