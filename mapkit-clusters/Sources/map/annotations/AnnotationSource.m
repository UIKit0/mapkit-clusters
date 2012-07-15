
// BSD License. <jano@jano.com.es>

#import "AnnotationSource.h"

@implementation AnnotationSource

/**
 * Returns an Array with 'number' annotations positioned at random inside the given region.
 *
 * @param region Region of the annotations we want.
 * @param number Number of annotations to return.
 */
+ (NSMutableArray*) annotationsForRegion:(MKCoordinateRegion)region number:(const int)number {
    
	NSMutableArray *randomAnnotations = [[NSMutableArray alloc] init];
	
	for(int i=0; i < number; i++) 
    {
        CLLocationCoordinate2D randomCoord = { 0,0 };
        
        // set the coordinate on a corner of the current region
        randomCoord.longitude = region.center.longitude - region.span.longitudeDelta/2; 
        randomCoord.latitude = region.center.latitude - region.span.latitudeDelta/2;
        
        // add the width/height of the current region * (a number between 0 and 1)
        randomCoord.longitude += region.span.longitudeDelta * (random()/(double)0x7fffffff);
        randomCoord.latitude += region.span.latitudeDelta * (random()/(double)0x7fffffff);
        
        // create the annotation object
		Annotation *anno = [[Annotation alloc] initWithCoordinate:randomCoord];
		[anno setTitle:[NSString stringWithFormat:@"Pin %i",i]];

		[randomAnnotations addObject:anno];
	}
    
	return randomAnnotations;
}


@end
