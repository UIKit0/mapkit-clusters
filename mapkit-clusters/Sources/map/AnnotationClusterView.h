
// BSD License. <jano@jano.com.es>

#import <MapKit/MapKit.h>
#import "AppDelegate.h"

@interface AnnotationClusterView : MKAnnotationView {
@private
    UIFont *badgeFont;
    UIImage *badgeImage;
}

@property (nonatomic, assign) int badgeNumber;

@property (nonatomic, strong) UIFont *badgeFont;
@property (nonatomic, strong) UIImage *badgeImage;

@end
