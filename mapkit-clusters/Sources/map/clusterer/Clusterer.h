
// BSD License. <jano@jano.com.es>

#import <Foundation/Foundation.h>

typedef struct {
    int cols;
    int rows;
} GridSize;

@protocol Clusterer

-(NSMutableArray*) clusterAnnotations:(NSMutableArray*)annotations 
                        inNumClusters:(int)numClusters;

@end
