?ChickWeight
data<-ChickWeight
head(data)
dim(data)
unique(data$Chick)
unique(data$Diet)
unique(data$Time)
library(ggplot2)
ggplot(data=data,aes(x=Time,y=weight,group=Chick,
                     colour=Chick))+geom_line()+geom_point()
#aggregate(x,by,fun,...) x为数据(x为待折叠的数据)，by是一个由
#变量名组成的列表，必须是列表形式，会根据列表中的变量为基准，用fun
#来计算x中的数据，以形成新的整合数据，比如mean，median等
#根据饮食等级diet不同，计算小鸡平均重量
aggregate(data$weight,list(diet=data$Diet),mean)
##或者
aggregate(data$weight~data$Diet,data=data,mean)
#aggregate on time
aggregate(data$weight,list(time=data$Time),mean)
#aggregate use a different function
aggregate(data$weight,list(time=data$Time),sd)
#同时按照time和diet来折叠
aggregate(data$weight,list(time=data$Time,diet=data$Diet),mean)
##或者
aggregate(data$weight~data$Time+data$Diet,data=data,mean)
#按照diet分别求weight和time的均值
aggregate(data[,1:2],list(diet=data$Diet),mean)
or
aggregate(list(ave_weight=data$weight,ave_time=data$Time),list(diet=data$Diet),mean)#如果变量较多，这种方法要list很多，就不如上面的
or
aggregate(cbind(data$weight,data$Time)~data$Diet,data=data,mean)
#观察不同饮食习惯下，体重weight随时间的变化
ggplot(data)+geom_line(aes(x=Time,y=weight,colour=Chick))+
  facet_wrap(~Diet)+guides(col=guide_legend(ncol = 3))


##明天对比aggregate和apply函数的不同

args(median)
median(airquality$Wind)
View(airquality)
apply(airquality,2,median,na.rm=T)
#by month 计算各变量均值
aggregate(airquality,list(month=airquality$Month),mean,na.rm=T)
#找到所有apply函数
apropos("^[a-z]?apply$")

#The apply function allows us to apply a function over dimensions of a data object.
#Acceptable inputs to apply include any object that has a “dimension”—for example,
#matrices, data frames, and arrays. The arguments to the apply function are as follows:
apply(X,margin,fun,...,na.rm=T)
#x 为数据，margin可以确定对哪一个维度（1=row,2=column,3=,4=,...）使用fun函数
#创建有维度的数据集，比如matrix
myMat<-matrix(rpois(20,3),nrow = 4)
myMat
dim(myMat)
apply(myMat,2,mean)#按列分组by > mean 等价于colMeans(myMat)
apply(myMat,c(1,2),median) #按行和列计算
#使用quantile计算分位数，这需要多一点的数据量
biggerMat<-matrix(rpois(300,3),ncol = 3)
head(biggerMat)
apply(biggerMat,2,quantile)
apply(biggerMat,2,quantile,probs=c(0,0.05,0.5,0.95,1))

tapply(X,index,fun,...)
#The tapply function allows us to apply a function to elements of a vector, grouped by
#evels of one or more other variables. 
#比如我们要按照月份来计算wind的中位数median
tapply(airquality$Wind,airquality$Month,median)
or
aggregate(airquality$Wind,list(month=airquality$Month),median,na.rm=T)
or
aggregate(Wind~Month,data=airquality,FUN=median) aggregate有两种用法，一种是写公式,需要写数据data=''，一种是用list,不需要data=''
or
sapply(split(airquality$Wind,airquality$Month),median)


#按照多个变量来分组计算
tapply(airquality$Wind,list(airquality$Month,cut(airquality$Temp,3)),median)
#or结果输出有点不太一样
aggregate(airquality$Wind,list(airquality$Month,cut(airquality$Temp,3)),median)
等价于
aggregate(Wind~Month+cut(Temp,3),data=airquality,FUN=median)

#当需要对两个或以上变量进行操作时可用cbind
aggregate(cbind(Wind,Ozone)~Month,data=airquality,FUN=median,na.rm=TRUE)
等价于
aggregate(list(aveWind	=	airquality$Wind,	aveOzone	=	airquality$Ozone),
          list(Month	=	airquality$Month),	median,	na.rm	=	TRUE)#比起上面略复杂，其实也可以这样，aggregate(airquality[,c(“Wind”,	“Ozone”)],
+											list(Month	=	airquality$Month),	median,	na.rm	=	TRUE)


#同时，FUN也可以是自己定义的fun
aggregate(Wind	~	Month,	data	=	airquality,
          +			FUN	=	function(X)	{
            +					c(MIN	=	min(X),	MAX	=	max(X))
            +			})
#计算出每天风速与当月风速均值之差使用dplyr
airquality %>% group_by(Month) %>% mutate(medwind=median(Wind)) %>% mutate(diff=medwind-Wind)

