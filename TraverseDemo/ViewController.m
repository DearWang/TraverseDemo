//
//  ViewController.m
//  TraverseDemo
//
//  Created by WLin on 2018/5/10.
//  Copyright © 2018年 WLin. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveObjC/ReactiveObjC.h"
@interface ViewController ()

@property (nonatomic,strong)NSMutableArray *traverseArray;

@property (nonatomic,strong)NSDictionary *traverseDictionary;

@property (nonatomic,strong)UIAlertController *alearController;

@end

@implementation ViewController

- (NSMutableArray*)traverseArray {
    
    if (!_traverseArray) {
        
        _traverseArray = [NSMutableArray array];
        
        for (int i = 0 ; i < 100; i++) {
            
            [_traverseArray addObject:[NSString stringWithFormat:@"traverseNum%d",i]];
            
        }
    }
    
    return _traverseArray;
}
- (NSDictionary*)traverseDictionary {
    
    if (!_traverseDictionary) {
        
        NSMutableArray *keys  = [NSMutableArray array];
        NSMutableArray *valus = [NSMutableArray array];
        for (int i = 0; i < 100; i++) {
            
            [keys  addObject:[NSString stringWithFormat:@"key%d",i]];
            [valus addObject:[NSString stringWithFormat:@"value%d",i]];
            
        }
        
        _traverseDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithArray:valus] forKeys:[NSArray arrayWithArray:keys]];
    }
    
    return _traverseDictionary;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%ld---%@",self.traverseArray.count,self.traverseDictionary);
    
   
    _alearController = [UIAlertController alertControllerWithTitle:@"循环选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"for循环" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self forTraverse];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"forin遍历" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self forinTraverse];
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"enumerate" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self enumerateTraverse];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"GCD" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        [self gcdTraverse];
    }];
    
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"reactiveCocoa" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self reactiveCocoaTraverse];
    }];
    UIAlertAction *action6 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [_alearController addAction:action1];
    [_alearController addAction:action2];
    [_alearController addAction:action3];
    [_alearController addAction:action4];
    [_alearController addAction:action5];
    [_alearController addAction:action6];
    
    
    [self presentViewController:self.alearController animated:YES completion:^{
        
    }];
}
#pragma mark for循环遍历
- (void)forTraverse {
    
    //for循环遍历
    NSLog(@"start");
    for (int i = 0; i < self.traverseArray.count; i++) {
        
        NSLog(@"%@",self.traverseArray[i]);
        
    }
    NSLog(@"end");
    //for--字典遍历
    NSArray *dictionaryArray = [self.traverseDictionary allKeys];

    for (int i = 0 ; i < dictionaryArray.count; i++) {

        NSLog(@"key = %@",dictionaryArray[i]);
    }
    
    
}
#pragma mark forin遍历
- (void)forinTraverse {
    
    //for循环遍历
    NSLog(@"start");
  
   
    for (NSString *str in self.traverseArray) {
        
        NSLog(@"%@",str);
        
    }
    
    NSLog(@"end");
    
}

#pragma mark 枚举器
- (void)enumerateTraverse {
     NSLog(@"start");
    //正序遍历数组
    [self.traverseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        NSLog(@"正序%@",obj);

    }];
    
    //逆序遍历数组
    [self.traverseArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

         NSLog(@"逆序%@",obj);
    }];
    
    //遍历字典
#warning 字典是无序的不存在正序逆序
    [self.traverseDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {

        NSLog(@"key:%@->value%@",key,value);

    }];

    
      NSLog(@"end");
}
#pragma mark GCD遍历方法
- (void)gcdTraverse {
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    NSLog(@"start");
    dispatch_apply(self.traverseArray.count, queue, ^(size_t insex) {
      
         NSLog(@"%@",self.traverseArray[insex]);
      
        
    });
      NSLog(@"end");
}
#pragma mark ReactiveCocoa
- (void)reactiveCocoaTraverse {
      NSLog(@"start");
    //数组遍历
    [self.traverseArray.rac_sequence.signal subscribeNext:^(id x) {

        NSLog(@"%@",x);
    }];
      NSLog(@"end");
    
    //字典遍历 相当于元组数据
    [self.traverseDictionary.rac_sequence.signal subscribeNext:^(id x) {
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString*value) = x;

        NSLog(@"key=%@ value=%@",key,value);

    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
