#import <UIKit/UIKit.h>

#import "AWSCore.h"
#import "AWSCredentialsProvider.h"
#import "AWSIdentityProvider.h"
#import "AWSSignature.h"
#import "AWSBolts.h"
#import "AWSCancellationToken.h"
#import "AWSCancellationTokenRegistration.h"
#import "AWSCancellationTokenSource.h"
#import "AWSExecutor.h"
#import "AWSGeneric.h"
#import "AWSTask.h"
#import "AWSTaskCompletionSource.h"
#import "AWSCognitoIdentity.h"
#import "AWSCognitoIdentityModel.h"
#import "AWSCognitoIdentityResources.h"
#import "AWSCognitoIdentityService.h"
#import "AWSFMDatabase.h"
#import "AWSFMDatabaseAdditions.h"
#import "AWSFMDatabasePool.h"
#import "AWSFMDatabaseQueue.h"
#import "AWSFMDB.h"
#import "AWSFMResultSet.h"
#import "AWSGZIP.h"
#import "AWSKSReachability.h"
#import "AWSCocoaLumberjack.h"
#import "AWSDDAbstractDatabaseLogger.h"
#import "AWSDDASLLogCapture.h"
#import "AWSDDASLLogger.h"
#import "AWSDDAssertMacros.h"
#import "AWSDDFileLogger.h"
#import "AWSDDLegacyMacros.h"
#import "AWSDDLog+LOGV.h"
#import "AWSDDLog.h"
#import "AWSDDLogMacros.h"
#import "AWSDDOSLogger.h"
#import "AWSDDTTYLogger.h"
#import "AWSDDContextFilterLogFormatter.h"
#import "AWSDDDispatchQueueLogFormatter.h"
#import "AWSDDMultiFormatter.h"
#import "AWSMantle.h"
#import "AWSMTLJSONAdapter.h"
#import "AWSMTLManagedObjectAdapter.h"
#import "AWSMTLModel+NSCoding.h"
#import "AWSMTLModel.h"
#import "AWSMTLReflection.h"
#import "AWSMTLValueTransformer.h"
#import "NSArray+AWSMTLManipulationAdditions.h"
#import "NSDictionary+AWSMTLManipulationAdditions.h"
#import "NSError+AWSMTLModelException.h"
#import "NSObject+AWSMTLComparisonAdditions.h"
#import "NSValueTransformer+AWSMTLInversionAdditions.h"
#import "NSValueTransformer+AWSMTLPredefinedTransformerAdditions.h"
#import "AWSNetworking.h"
#import "AWSURLSessionManager.h"
#import "AWSSerialization.h"
#import "AWSURLRequestRetryHandler.h"
#import "AWSURLRequestSerialization.h"
#import "AWSURLResponseSerialization.h"
#import "AWSValidation.h"
#import "AWSClientContext.h"
#import "AWSInfo.h"
#import "AWSService.h"
#import "AWSServiceEnum.h"
#import "AWSSTS.h"
#import "AWSSTSModel.h"
#import "AWSSTSResources.h"
#import "AWSSTSService.h"
#import "AWSTMCache.h"
#import "AWSTMCacheBackgroundTaskManager.h"
#import "AWSTMDiskCache.h"
#import "AWSTMMemoryCache.h"
#import "AWSUICKeyChainStore.h"
#import "AWSCategory.h"
#import "AWSLogging.h"
#import "AWSModel.h"
#import "AWSSynchronizedMutableDictionary.h"

FOUNDATION_EXPORT double AWSCoreVersionNumber;
FOUNDATION_EXPORT const unsigned char AWSCoreVersionString[];

