#import "CAS.h"

@implementation CAS

static CAS *casClient;

# pragma mark Setup Methods

// 确保只有一个单例
+ (id)alloc {
	@synchronized(self) {
		NSAssert(casClient == nil, @"Attempted to allocate a second instance of CAS.");
		casClient = [super alloc];
		return casClient;
	}
	return nil;
}

// 支持异步调用
+ (CAS *)client {
	@synchronized(self) {
		if (!casClient)
			casClient = [[CAS alloc] init];
		return casClient;
	}
	return nil;
}

#pragma mark CAS Methods

// 初始化cas服务
- (void)initWithCasServer:(NSString *)casServer
              restletPath:(NSString *)restletPath
                 username:(NSString *)username
                 password:(NSString *)password
        authCallbackBlock:(CASAuthCallbackBlock)authCallbackBlock {

	_casServer = casServer;
	_restletPath = restletPath;
	_username = username;
	_password = password;
	_authCallbackBlock = authCallbackBlock;

	// 用户认证并获取TGT
	[self requestTGTWithUsername:username password:password];
}


// 用户认证，通过用户名密码获取TGT
- (void)requestTGTWithUsername:(NSString *)user
                      password:(NSString *)pass {
	@synchronized(self) {
		// 创建request
		NSLog(@"请求获取TGT，URL地址: %@", [self.casServer stringByAppendingString:self.restletPath]);
		NSString *credentials = [NSString stringWithFormat:@"%@%@%@%@", @"username=", user, @"&password=", pass];
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:[self.casServer stringByAppendingString:self.restletPath]]];
		[request setHTTPMethod:@"POST"];
		[request setHTTPBody: [[NSString stringWithString:credentials] dataUsingEncoding: NSUTF8StringEncoding]];

		// 发送请求
		NSHTTPURLResponse *response;
		NSError *error;
		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

		// 从response头信息中获取tgt
		NSString *location;
		if ((location = [[response allHeaderFields] valueForKey:@"tgt"])) {
			NSString *ticket = [[location componentsSeparatedByString:@"/"] lastObject];
			NSLog(@"获取TGT: %@", ticket);
			[self setTgt:ticket];
		} else {
			NSLog(@"无法从response头中获取TGT");
		}

		// 回调authenticationCallback
		self.authCallbackBlock(@([response statusCode]));
	}
}

/*
 向cas服务请求获取ST
 */
- (NSString *)requestSTForService:(NSURL *)serviceURL {
    // 若tgt为空，报错
	if (!self.tgt) {
		NSString *err = @"错误: 无法获取ST, 无TGT!";
		NSLog(@"%@", err);
		return err;
	}

	// 创建request请求
	NSLog(@"请求获取ST: %@ CASURL为: %@", serviceURL, [self.casServer stringByAppendingString:self.restletPath]);
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:
                                                                        [[self.casServer stringByAppendingString:self.restletPath] stringByAppendingString:self.tgt]]];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[[@"service=" stringByAppendingString:[serviceURL description]] dataUsingEncoding:NSUTF8StringEncoding]];

	// 发送请求
	NSURLResponse *response;
	NSError *error;
	NSData *responseBody = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	//NSLog(@"ST Response Headers: %@", [(NSHTTPURLResponse *)response allHeaderFields]);


    // 校验请求是否成功
	if ([(NSHTTPURLResponse *)response statusCode] != 200) {
		NSLog(@"错误，无法获取ST");
        
        // TODO 再次请求TGT防止已获取得TGT已经过期，然后再请求ST（只操作一次）
        
		return @"error";
	}


    // 从response中获取ST
	NSString *st = [[NSString alloc] initWithData:responseBody encoding: NSUTF8StringEncoding];
	NSLog(@"ST: %@", st);

	return st;
}

/*
 Creates a connection and sets up objects for the data to be stored in when
 a response returns.
 */
- (void)sendAsyncRequest:(NSURLRequest *)request
       authCallbackBlock:(CASAuthCallbackBlock)authCallbackBlock {

	// Connection objects
    // 链接对象
	NSURLResponse *response = [[NSURLResponse alloc] init];
	NSMutableData *data = [[NSMutableData alloc] init];
    
	// Create a detail dictionary for this connection
    // 创建一个明细链接字典
	NSMutableDictionary *connDetails = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        response, @"response",
                                        data, @"data",
                                        authCallbackBlock, @"authCallbackBlock", nil];
    
	// Create the connection
    // 创建链接
	NSLog(@"创建异步请求");
	NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];

	// Store the connection dictionary
    // 将链接字典存储起来
	if (self.connectionStorage == nil) {
		self.connectionStorage = [[NSMutableDictionary alloc] init];
	}
	[[self connectionStorage] setValue:connDetails forKey:[conn description]];
}



# pragma mark NSURLConnection Delegate Methods

/*
 Sends a request to a given connection and handles CAS redirects
 向一个地址发送请求并操作cas重定向
 */
- (NSURLRequest *)connection:(NSURLConnection *)connection
			  willSendRequest:(NSURLRequest *)request
			 redirectResponse:(NSURLResponse *)redirectResponse {
    NSLog(@"重定向");
	NSURLRequest *newRequest = request;
    if (redirectResponse) {
		// Catch redirects to the CAS server
        // 获取向CAS服务的重定向
		NSString *redirectLocation = [[(NSHTTPURLResponse *)redirectResponse allHeaderFields] valueForKey:@"Location"];
		if ([[redirectLocation substringToIndex:[self.casServer length]] isEqualToString:self.casServer]) {
			NSLog(@"捕获CAS重定向");
			// Get a service ticket and form a new request to return with it
            // 获取ST，组装一个新的request对象
			NSString *st = [self requestSTForService:[redirectResponse URL]];
			newRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[[[redirectResponse URL] description] stringByAppendingString:@"?ticket="] stringByAppendingString:st]]];
		}

    }
    return newRequest;
}


/*
 Connection loads data incrementally - This should concatenate the contents
 of each data object delivered to build up the complete data for a URL load.
 */
- (void)connection:(NSURLConnection *)connection
	 didReceiveData:(NSData *)data {

	NSLog(@"链接:didReceiveData:");
	NSMutableData *storedData = self.connectionStorage[[connection description]][@"data"];
	[storedData appendData:data];
}

/*
 Stores the connection response in the connection's storage dictionary
 将response对象保存至链接字典存储中
 */
- (void)connection:(NSURLConnection *)connection
 didReceiveResponse:(NSURLResponse *)response {

	NSLog(@"链接:didReceiveResponse:");
	self.connectionStorage[[connection description]][@"response"] = response;
}

/*
 Sends the final connection details to the callback object & selector. Removes
 connection details from storage.
 
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"链接DidFinishLoading:");
	NSDictionary *storedConnDetails = self.connectionStorage[[connection description]];

	// Get callback details
	CASAuthCallbackBlock authCallbackBlock = storedConnDetails[@"authCallbackBlock"];

	// Call the callback block with the results
	NSLog(@"Calling the callback block with the connection details");
	authCallbackBlock(storedConnDetails);

	// Cleanup
	[self.connectionStorage removeObjectForKey:[connection description]];
}

@end
