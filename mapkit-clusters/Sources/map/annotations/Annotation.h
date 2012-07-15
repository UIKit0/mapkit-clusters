
// BSD License. <jano@jano.com.es>

#import <MapKit/MapKit.h>

/** Annotation. */
@interface Annotation : NSObject <MKAnnotation> {
}

@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
//@property(nonatomic,assign) CGPoint point;
@property(nonatomic,assign) int clusterId;
@property (nonatomic, copy) NSString *title, *subtitle;
@property (nonatomic, strong) MKAnnotationView *view;

// This is to the center of the parent cluster annotation if any.
// This makes it possible to animate the annotation as if it spawned from the parent.
@property(nonatomic,assign) CGPoint spawnPoint;


//-(id) initWithPoint:(CGPoint)aPoint;
-(id) initWithCoordinate:(CLLocationCoordinate2D)aCoordinate;

-(CLLocationCoordinate2D) coordinate;
-(void) setCoordinate:(CLLocationCoordinate2D) aCoordinate;


@end
