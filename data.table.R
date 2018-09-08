#data.table(一)
# 下面列举一下这里的[]在与基础函数中的[]的重叠功能上，有什么区别，后面括号里会标注出他们在后文中的哪里出现。
# 
# 首先，由于同样是[]，所以要想使用data.table的功能，首先数据框的类型要转换为data.table，否则使用的就是data.frame的[]功能
# dft[1,2]这样取一个值，dft中结果仍是DT数据框，而DF取出来自动降维成一个数（提取点）
# dft[2]这样只接一个数时，这里取的是第二行，基础函数取的是第二列。这样改方便对行的排序和筛选（即不需要多加一个逗号）（见提取一行）
# 使用列名可以直接用名称，不需要加引号（见按名称提取提取）
# 这里在[]中使用这个数据框里的列名，不需要加$（见根据逻辑值提取和排序）
# 增加了使用!反选的删除方法（见删除行列）
# 本文包括如下内容
# 
# data.table提取等功能总结
# data.table计算、分组计算
# data.table的merge合并

name1 <- c("Bob","Mary","Jane","Kim")
name2 <- c("Bob","Mary","Kim","Jane")
weight <- c(60,65,45,55)
height <- c(170,165,140,135)
birth <- c("1990-1","1980-2","1995-5","1996-4")
accept <- c("no","ok","ok","no")
library(data.table)
dft <- data.table(name1,weight,height,accept)
#(1)根据坐标或列名的提取

# 提取点
dft[1,2] # 这里和data.frame是有区别的，这里返回的是一个data.table，而如果是data.frame则返回一个值
dft[[1,2]] # 返回一个值,data.table中drop不能用
dft[c(1,3),3]
dft[c(1,3),weight]
dft[c(1,3),"weight"]

# 提取行
dft[1] # 注意这里和基础的不一样，只接一个数是提取行
dft[1:2,] # 也可以加一个逗号

# 提取列
dft[,2] # 这里返回的是一个DT，与基础函数中的向量不同
dft[[3]] # 这样只接一个数时提取列，返回一个向量
dft[["weight"]] #
dft$weight # 以上都是返回一个向量

dft[,"weight"]
dft[,weight] # 注意区别，配合下面例子做出解释
dft[,c("weight","height")]
dft[,weight:accept] # 返回一个数据框

dft[,c(weight,height)]
# 如果使用字符串，则会输出数据框
# 如果直接使用列名表达式（没有括号的），则会输出向量；
# 如果取多列，则会自动把多列拼接成一个向量输出。
# 使用表达式就和使用功能$是一样的，这是数据的降维

# 如果想使用expression,而数据不降维，用list(weight)
dft[,list(weight)]
dft[,.(weight)] # .是list的简写
dft[,.(weight,accept)]
#当列名字符串放在一个变量中，想要使用这个变量进行提取时，因为data.table的[]提取时，可以接受一个不加引号的对象，所以会把这个表示列名的变量直接引用，这时需要使用with参数

dft <- data.table(name1,weight,height,accept)
name1 <- "weight"
dft[,name1] # 提取出来的是name1列
dft[,(name1)] # 提取出来的是name1列
dft[,name1,with=F] # 提取出来的是weight列
k <- "weight" # 如果使用的变量名不是dft中的列名
# dft[,k] # 报错，因为此处默认寻找变量名空间为这个dft
dft[,k,with=F] # 提取出来的是weight列
dft[[name1]] # 除了使用with参数，还可以这样
# dft[[weight]] # 报错，使用双括号时，是不允许直接使用变量名不加引号的

name1 <- c("Bob","Mary","Jane","Kim") # 不要干扰到后面的代码
#这里with参数其实相当于基础的with函数，当with=T时，就相当于基础函数使用了with函数，在这里面使用列名不需要data$，直接当成变量名就可以了，也就不用加引号，如果不想这样，想让使用的变量代表一个外面定义的字符串向量，则让with=F，相当于不使用with函数。

#根据逻辑值提取

# 根据逻辑值提取
dft[weight > 40] # 不需要dft$weight
dft[weight>40&height<170]
dft[dft$weight>40&dft$height<170]
dft[c(T,F,T,T)]
dft[,c(T,F,T,F)] # 列不可以根据逻辑值提取

# 使用on参数提取某一列是某一个值的行（相当于用逻辑值）
dft["Bob",on="name1"]
dft["Bob",on=.(name1)]
dft[name1=="Bob"] # 等价于用逻辑值筛选
dft[c("Bob","Mary"),on="name1"] # 一列选择多种
dft[!"Bob",on="name1"] # 一列剔除某类
dft[.("Bob",60),on=.(name1,weight)] # 按照多列查找

dft[.("Bob",c(55,60)),on=.(name1,weight)] # 找不到这样的行则创造一个满足这两列，其他列设为NA
dft[.("Bob",c(55,60)),on=.(name1,weight),nomatch=0] # 找不到也不返回缺失值
dft[.("Mary",c(65,55)),on=.(name1,weight),roll=-Inf] # 填充

#删除行列

dft <- data.table(name1,weight,height,accept)
dft[-c(2,3)] # 删除第23行
dft[,-c(2,3)] # 删除第23列
dft[,c(2,3)] <- NULL;dft # 删除第23列

# 以下是基础函数没有的功能
dft[!2:3]
dft[,!"weight"]
dft[,-"weight"]
dft[,-c("weight","height")]
dft[,!c("weight","height")]
#后面讲到添加列的时候还会讲到一种删除列的方法，这是涉及到特殊符号的

#排序

dft <- data.table(name1,weight,height,accept)
dft[order(weight)] # 注意，不需要dft$weight
dft[order(weight),] # 加一个逗号指明排序针对行，相同效果
setcolorder(dft,rev(names(dft))) # 接受重新排列的列名将列排序
#后面讲到key的时候还会有一种排序的方法

# 计算
# 
# DT中的计算也是在[]中完成的，包括分组也只是通过加了一个参数，这样做我们可以非常简单地一步实现基础函数或者其他包的很多步才能实现的功能。下面说一下data.table在计算方面的使用思路。在[]中接三个参数
# 
# 第一个指定哪些行要加入计算
# 第二个指定要进行什么样的计算
# 第三个指定按照哪个变量来分组计算
# 普通计算
DT[ i,  j,  by ] # + extra arguments
|   |   |
  |   |   -------> grouped by what?
  |   -------> what to do?
  ---> on which rows?
  
  dft <- data.table(name1,weight,height,accept)
dft[,sum(weight)] # 在第二个参数位置指明要对那一列做什么样的操作
dft[,weight] # 这一条提取操作其实也可以看成是使用它本身输出，不进行其他计算
dft[,.(summary(weight),mean(weight))] # 计算多种用list，结果长度不相等时会循环显示
dft[,c(summary(weight),mean(weight))] # 用向量方式展示结果
dft[,.(wm=mean(weight),ws=sum(weight))] # 对同一列计算多种,并指定计算结果列名
dft[1:2,summary(weight)] # 对前两行的weight做描述性统计
dft["Bob", weight-10, on="name1"] # 筛选计算
#第二个参数提供的平台还可以给其他数据框使用

w <- dft[,c("weight","accept")]
dft[,w[,sum(weight)],by=accept]
#里面的w在计算，展示时虽然看起来按照accept分组，实际上计算结果没有按照by分组

dft[,weight%*%t(weight)] # 只返回一个时
dft[,.(weight%*%t(weight),height%*%t(height))] # 返回两个，使用list，但会每个自动转换成向量
dft[,c(weight%*%t(weight),height%*%t(height))] # 使用c，就会全部都转换成一个向量

#分组计算

dft <- data.table(name1,weight,height,accept)
dft[,sd(weight),by=accept]
dft[,sd(weight),keyby=accept] # 按照accept的顺序排列
dft[,sd(weight),by=accept][order(accept)] # 与上面等价
dft[,mean(weight),by=height>150] # 对计算之后的变量分组

#按照多列分组

DT = data.table(x=rep(c("b","a","c"),each=6), y=c(1,3,6), v=1:18)
DT[,sum(v),by=x]
DT[,sum(v),by=y]
DT[,sum(v),by=.(x,y)]
DT[,sum(v),by=c("x","y")]
DT[,sum(v),by=.(x,y)][,sum(V1),by=x]

#合并

#这里只讲述merge形式的合并，直接拼接形式的合并非常简单，只是这个包改写了一个更快的函数，我们在后面会介绍

dt1 <- dft[1:3]
dt1
dt2 <- data.table(name1=name2[1:3],birth[1:3],friend=name1[c(2,4,3)])
dt2
dt1[dt2,on="name1"] # 按照相同列名融合两个数据框,保留dt2中name1的所有值
dt2[dt1,on="name1"] # 这里保留dt1的，dt2中没有的填上NA
dt2[dt1,on="name1",nomatch=0] # 取交叉部分
dt1[!dt2,on="name1"] # 取dt2没有的部分

dt1[dt2,on=.(name1==friend)] # 当要融合的内容列名不相同时，用==匹配在一起
dt1[dt2,on="name1==friend"] # 与上等价
# 如果融合依据是数字，还可以用<= >=等连接，将满足这个不等式的匹配在一起

dt1[dt2,.(name1,w=weight),on="name1==friend"] #在第二个参数的位置选择返回哪些列,同时修改列名
dt1[dt2,on="name1",mult="first"] # 选择每组的第一个（按照on分组，这里没有体现出来）
dt1[dt2,on="name1",mult="last"] # 选择每组的最后一个
# 加by=.EACHI和计算的参数还可以同时分组计算


####data.table(2)

# 上文我们讨论到使用data.table包完成数据分析框架，遗留如下几个问题
# 
# 增添列，另外一种删除列的方法，修改数据框
# 计算或分组计算时，可不可以一次对所有列进行计算，而不需要再每一列都指定(.SD)
# DT中可不可以按照行名来提取（key）
# 普通合并数据框（改进了的函数，会在下一篇中介绍）
# 融合重铸
# 本文介绍data.table包更深入的使用方法，顺带解决上述问题，下面是本文目录
# 
# key的使用
# 融合重铸的深入使用和改进
# 特殊符号如.N .SD := 等
# 高效读写文件函数及参数解释

# (1)DT数据框的行名及key的介绍
# 
# 之前提到过提取时没有使用行名提取这个方法，这是因为data.table没有行名，如果硬要说有，那就是1234，而且不能修改，也不能根据行名来做提取等操作。

rownames(dft) # "1" "2" "3" "4"
rownames(dft) <- letters[1:4]
rownames(dft) # "a" "b" "c" "d"
dft # 虽然上面rownames改过来了，但是这样输出发现还没有变
# dft["a","weight"] # 报错，无法根据行名提取
dft[1,"weight"] # 使用行数才可以
#这不是data.table的漏洞，而是因为它有更强大的操作，根本就不需要使用行名。
#具体的使用方法是，把data.frame的行名当成一列读进去，通过设置key来指定该列为行名。
#这样做的好处是，不止可以指定这一列，任意一列都可以，还可以指定多列，我们下面来看一看。

ndt <- copy(dft) # 为了和原数据框对比，创建一个新的
setkey(ndt,name1)
ndt # 发现数据框自动按照name1这一列进行排序了
# 如果想去掉key，则setkey(ndt,NULL)

# 实现通过行名提取
ndt["Bob",weight] 
ndt["Bob","weight"]
ndt["Bob",2]
dft["Bob",2,on="name1"] # key 相当于使用了on
ndt["Bob"]

# 注意
setkey(ndt, weight)
ndt[60] # 认为是提取第60行
ndt[.(60)] # 下面两个才是提取weight为60的行
ndt[J(60)]

#检查key的函数

haskey(ndt) # 返回TF值，检查是否有Key
key(ndt) # 检查它的key是什么
#使用key来辅助计算

setkey(ndt,accept)
ndt["ok",sum(weight)] # 指定计算accept为ok的weight之和
ndt[c("ok","no"),sum(weight)] # 全部合在一起算
ndt[c("ok","no"),sum(weight),by=.EACHI] # 分类算
ndt[accept,sum(weight),by=.EACHI] # 每一类计算完，保留所有行输出
ndt[unique(accept),sum(weight),by=.EACHI] # 只显示和类数相同的行
ndt[,sum(weight),by=accept] # 上面等价于分组计算
#我们可以发现，key的作用相当于设定on参数。计算时使用key，再指定计算哪些行，by=.EACHI,可以实现和分组计算一样的功能。

#特殊符号

#添加、更新和删除 := 符号

#这个符号可以实现在本身直接更改，而无需产生一个新的数据框，再赋值给原本相同的变量名

dft <- data.table(name1,weight,height,accept)
dft[,u:=1] # 添加一个全是1的列
dft[,height:=1:4] # 更改height列
dft[,c("accept","height"):=.(1:4,2:5)] # 作用于多个列
dft[,`:=`(m=1:4,n=3:6)] # 使用:=函数的真正调用方式
dft[,weight:=NULL] # 删除weight列
dft[,c("m","n"):=NULL] # 删除多列
dft[2,height:=22][] # 只修改一个值，加一个[]返回得到的数据框

dft <- data.table(name1,weight,height,accept)
dft["Bob",accept:="yes",on="name1"] # 通过逻辑判断修改
dft[,m:=mean(height),by=accept] # 增加一个列，这个列根据分组计算得出
# 注意一点
dft[name1=="Bob"][,height:=13][] # :=作用在提取之后的数据框，所以对原数据框没有改变
dft
# 使用一个指向字符串的变量作为新名称
a <- "aa"
dft[,a:=1][] # 使用a作为列名
dft[,(a):=2][] # 使用aa作为列名


#.N 代表行的数量，用by参数分组时则是每一组的行数量

dft[.N-1] # 返回倒数第二行
dft[,.N] # 返回数据框一共有几行（放在第二个参数位置表示计算并输出结果）
dft[,.N,by=accept] # 分组计算行数


#.SD 代表整个数据框，用by参数分组时则是每一组的数据框

dft <- data.table(name1,weight,height,accept)
dft[,print(.SD),by=accept]
dft[,head(.SD,1),by=accept]
dft[,.SD[2],by=accept]
dft[,lapply(.SD[,c(-1,-4)],sum),by=accept] # 分组多列计算
#之前我们提到过，在DT中计算时输出的总是DT，但是如果我想返回多个矩阵怎么办，那就是使用嵌套list，像把矩阵压缩成一个元素一样，放在DT中。这里我们要用分组计算，返回矩阵。

#下面这个例子是要对分组之后的每个数据框求covariance，计算得到的是列与列两两对应协方差矩阵。

dft[,cov(.SD[,c(-1,-4)]),by=accept] # 矩阵被变成向量
l <- dft[,.(.(cov(.SD[,c(-1,-4)]))),by=accept]
l[[1,2]]
#这里解释一下连续嵌套两层list的理由

#第一个list是指对每一组计算出来的结果矩阵，用list压缩成为可以放在DT中的元素
#第二个list是将两个压缩了的元素整合在一起，使之成为一列。这一层中还可以加第二个元素，输出结果放在下一列展示,功能类似我们平时使用的计算多个结果l <- dft[,.(.(cov(.SD[,c(-1,-4)])),.(cor(.SD[,c(-1,-4)]))),by=accept]
l <- dft[,.(.(cov(.SD[,c(-1,-4)])),.(cor(.SD[,c(-1,-4)])),sum(weight)),by=accept]
dft[,.(m=mean(weight),s=sum(weight)),by=accept] # 外层list功能类似这里
.SDcols

.SDcols 指定.SD 代表的数据框包括哪些列

dft[,lapply(.SD[,c(-1,-4)],sum),by=accept]
# 下面4条命令和上面那条有相同的效果
dft[,lapply(.SD,sum),by=accept,.SDcols=c("weight","height")] #.SD中只包含这两列
dft[,lapply(.SD,sum),by=accept,.SDcols=weight:height] #用:指定这列到这列之间的所有列
dft[,lapply(.SD,sum),by=accept,.SDcols=2:3]
dft[,lapply(.SD,sum),by=accept,.SDcols=-c(1,4)]
.I

.I 表示（分组后）每一行在原数据框中是第几行

dft[,.I[2],by=accept]
.GRP

如果不使用by参数，则为1。使用by，则是组的计数（第一组的值是1，第二组是2）

dft[,grp:=.GRP][]
dft[,grp:=.GRP,by=accept][]
串联操作，避免多余中间变量

dft[weight>50][height>100][order(height)]
%between% 范围

# 以下6个等价
dft[weight>=50&weight<=60]
dft[weight %between%c(50,60)]
dft[weight %inrange%c(50,60)]
dft[weight %between% list(rep(50,4),rep(60,4))]
dft[between(weight,50,60)]
dft[inrange(weight,50,60)]
%like% 字符串中含有某个字符

dft[name1%like%"a"]
#集合操作函数

#增加了all参数，控制重复值。基础函数只能返回去重之后的结果

#函数变化：union intersect setdiff setequal 前面都加了一个f

#基础函数作用于两个向量，data.table中函数作用于两个data.table数据框，而且列名需要相同

x <- data.table(a=c(1,2,2,2,3,4,4))
y <- data.table(a=c(2,3,4,4,4,5))
x
y
fintersect(x, y)            # 返回相交部分并去重
fintersect(x, y, all=TRUE)  # 相交，保留重复值
fsetdiff(x, y)              # x中有y中没有的，去重
fsetdiff(x, y, all=TRUE)    # 保留重复值
funion(x, y)                # 并集，去重
funion(x, y, all=TRUE)      # 保留重复值
fsetequal(x, y)             # 返回一个F，二者不完全相等

##深复制和浅复制
DF <- data.frame(ID = c("b","b","b","a","a","c"), a = 1:6, b = 7:12, c = 13:18)

# 先测试基础函数的复制情况
tracemem(DF) # 打印出此时地址 "<0000000002F25938>"
DF$c <- 18:13 # 修改数据框，打印出三条更改信息，说明这个过程中，数据框被复制了三次
DF$c[DF$ID == "b"] <- 15:13 # 这样改变则复制了四次
untracemem(DF) # 结束检测
#接下来我们测试一下data.table

DT <- as.data.table(DF)
tracemem(DT)
DT[,c:=18:13]
DT["b",c:=15:13,on="ID"]
untracemem(DT)
#浅复制的副作用
#上面我们已经说明了data.table的处理方式是浅复制，下面我们用例子说明浅复制中相互影响带来的负面影响。

DT <- data.table(ID = c("b","b","b","a","a","c"), a = 1:6, b = 7:12, c = 13:18)
DD <- DT[,c:=18:13][]
DT;DD # 二者相同
DT["b",c:=15:13,on="ID"]
DT;DD # 二者仍相同，说明改变DT的同时也改变了DD
rm(DT,DD) # 删除变量重新试验

#使用copy函数实现复制，不影响原来数据框
DT = data.table(ID = c("b","b","b","a","a","c"), a = 1:6, b = 7:12, c = 13:18)
assign_DT <- DT 
copy_DT  <- copy(DT)
DT;assign_DT;copy_DT # 此时三者一样
#而浅复制有一个弊端，就是新数据框合旧数据框都指向同一个内容，只要在一个数据框中把这个内容改变，
#另外的数据框也会受到影响。这就是copy函数存在的意义，这样深复制一下可以让两个数据框之间互不影响。
DT[,c:=18:13] # 改变其中一个
DT;assign_DT # 通过普通赋值符号产生的数据框也跟着改变了
copy_DT # 通过copy深复制才没有被影响
rm(DT,assign_DT,copy_DT)
##end
##end
