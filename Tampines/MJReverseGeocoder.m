/*
 * MJReverseGeocoder.m
 *
 *
	 Copyright (c) 2011, Mohammed Jisrawi
	 All rights reserved.
	 
	 Redistribution and use in source and binary forms, with or without
	 modification, are permitted provided that the following conditions are met:
	 
	 * Redistributions of source code must retain the above copyright
	   notice, this list of conditions and the following disclaimer.
	 
	 * Redistributions in binary form must reproduce the above copyright
	   notice, this list of conditions and the following disclaimer in the
	   documentation and/or other materials provided with the distribution.
	 
	 * Neither the name of the Mohammed Jisrawi nor the
	   names of its contributors may be used to endorse or promote products
	   derived from this software without specific prior written permission.
	 
	 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
	 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
	 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
	 DISCLAIMED. IN NO EVENT SHALL MOHAMMED JISRAWI BE LIABLE FOR ANY
	 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
	 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
	 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
	 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */


#import "MJReverseGeocoder.h"
#import "JSON.h"

@implementation MJReverseGeocoder

@synthesize coordinate, delegate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord{	
	if(self = [[MJReverseGeocoder alloc] init]){
		coordinate = coord;
	}
	return self;
}

/*
 *	Opens a URL Connection and calls Google's JSON reverse geocoding service
 */
- (void)start{
    //build url string using coordinate
	NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true&key=AIzaSyAhFfNvSFyKZZx4pm2xjwXoAam0koNjSLE",
						   coordinate.latitude, coordinate.longitude];
    
   
    
    //build request URL
    NSURL *requestURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //build NSURLRequest
    NSURLRequest *geocodingRequest=[NSURLRequest requestWithURL:requestURL
                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                timeoutInterval:60.0];
    
    //create connection and start downloading data
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:geocodingRequest delegate:self];
    if(connection){
        //connection valid, so init data holder
        receivedData = [[NSMutableData data] retain];
    }else{
        //connection failed, tell delegate
        NSError *error = [NSError errorWithDomain:@"MJGeocoderError" code:5 userInfo:nil];
        [delegate reverseGeocoder:self didFailWithError:error];
    }
}

/*
 *  Reset data when a new response is received
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [receivedData setLength:0];
}

/*
 *  Append received data
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    [connection release];
    [receivedData release];
}

/*
 *  Called when done downloading response from Google. Builds an AddressComponents object
 *	and tells the delegate that it was successful or informs the delegate of a failure.
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//get response
	NSString *geocodingResponse = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
  
    
    NSLog(@"geocodingResponse=%@",geocodingResponse);
    
    [connection release];
    [receivedData release];
    
    @try
    {
        
        //result as dictionary dictionary
        NSDictionary *resultDict = [geocodingResponse JSONValue];
        [geocodingResponse release];
        
        NSString *status = [resultDict valueForKey:@"status"];
        if([status isEqualToString:@"OK"]){
            //if successful
            //get first element as array
            Address *resultAddress = [[[Address alloc] init] autorelease];
           
            NSString *strFullAddress= [[[resultDict objectForKey:@"results"] objectAtIndex:0] objectForKey:@"formatted_address"];
            resultAddress.fullAddress=strFullAddress;
            NSLog(@"strFullAddress=%@",strFullAddress);
            
            [delegate reverseGeocoder:self didFindAddress:resultAddress];
            
            
        }else{
            //if status code is not OK
            NSError *error = nil;
            
            if([status isEqualToString:@"ZERO_RESULTS"])
            {
                error = [NSError errorWithDomain:@"MJGeocoderError" code:1 userInfo:nil];
            }
            else if([status isEqualToString:@"OVER_QUERY_LIMIT"])
            {
                error = [NSError errorWithDomain:@"MJGeocoderError" code:2 userInfo:nil];
            }
            else if([status isEqualToString:@"REQUEST_DENIED"])
            {
                error = [NSError errorWithDomain:@"MJGeocoderError" code:3 userInfo:nil];
            }
            else if([status isEqualToString:@"INVALID_REQUEST"])
            {
                error = [NSError errorWithDomain:@"MJGeocoderError" code:4 userInfo:nil];
            }
            
            [delegate reverseGeocoder:self didFailWithError:error];
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
        // Added to show finally works as well
    }
}


@end
