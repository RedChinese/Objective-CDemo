//
//  main.m
//  ReadCsv
//
//  Created by ZhenYu on 2023/4/6.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
	@autoreleasepool {
			///解析CSVFile
			///1.使用正则表达式
			///
			///1.读取文件到NSString 中
			///2.拆分字符串为数字
			///3.第一行为ItemName
			///4.从第二行开始为数据
			///5.每个项目以逗号分隔，先寻找双引号对应的字符串
			///把这一行的值找到后放到字典里。
			///所有项目
		NSMutableArray*AllTestItems=[[NSMutableArray alloc] init];
			//正则表达式
		NSString*pattern=@"[\"]{1}.*[\"]{1}";
			//TP内容字符串
		NSString*StrAllTP=[NSString stringWithContentsOfFile:@"/Users/zhenyu/Desktop/DOE/debug.csv" encoding:NSUTF8StringEncoding error:nil];
		NSLog(@"完整TP中的字符:\n%@",StrAllTP);
			//拆成一行一行
		NSArray*testPlanAllLine=[StrAllTP componentsSeparatedByString:@"\n"];
		NSLog(@"testPlanAllLine%@",testPlanAllLine);
			//项目名
		NSArray*testItemNames=[[testPlanAllLine objectAtIndex:0] componentsSeparatedByString:@","];
			//循环所有行
		for(int index=1;index<testPlanAllLine.count;index++){
			NSMutableDictionary*itemData=[[NSMutableDictionary alloc] init];
			for(id itemName in testItemNames){
				NSLog(@"item name %@",itemName);
				[itemData setValue:@"" forKey:itemName];
			}
			NSLog(@"ItemaData%@",itemData);
			NSString*lineStr=[testPlanAllLine objectAtIndex:index];
			NSLog(@"Line Str:\n%@",lineStr);
				//正则表达式处理
			NSRegularExpression*regex=[NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
				//位置返回字符串位置信息
			NSRange rangeOfFirstMatch=[regex rangeOfFirstMatchInString:lineStr options:0 range:NSMakeRange(0,lineStr.length)];
			if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
					//找到正则匹配到的字符串
				NSString *substringForFirstMatch = [lineStr substringWithRange:rangeOfFirstMatch];
					//去除字符串开头标识符
				NSString*removeHeaderString=[substringForFirstMatch stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:0 range:NSMakeRange(0, 1)];
					//去除字符串结尾标识符
				NSString*removeEndingString=[removeHeaderString stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:0 range:NSMakeRange(removeHeaderString.length-1, 1)];
					//转换成字典
				NSData*jsondata=[removeEndingString dataUsingEncoding:NSUTF8StringEncoding];
				NSDictionary*dic=[NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];
					//放入字典暂存
				[itemData setValue:dic forKey:@"Args"];
					//替换字符串后面还需呀该字符串
				lineStr=[lineStr stringByReplacingOccurrencesOfString:substringForFirstMatch withString:@""];
				NSLog(@"args \n%@",removeEndingString);
			}
			NSArray*itemValueArr=[lineStr componentsSeparatedByString:@","];
			NSLog(@">>%@",itemValueArr);
			[itemData setValue:[itemValueArr objectAtIndex:0] forKey:@"Function"];
			[itemData setValue:[itemValueArr objectAtIndex:2] forKey:@"Timeout"];
			NSLog(@">>>>%@",itemData);
				//放入测试项数组
			[AllTestItems addObject:itemData];
		}
			//打印所有测试项
		NSLog(@"AllTestItems %@",AllTestItems);

		NSLog(@"Hello, World!");
	}
	return 0;
}

