
library(splitstackshape)
View(concat.test) #example data
temp <- head(concat.test)
concat.split.multiple(df,"FOO","|")
df1 <- data.frame(ID=11:13, 
                  FOO=c('a|b','b|c','x|y'), 
                  BAR = c("A*B", "B*C", "C*D"))
df1
concat.split.multiple() = cSplit()
concat.split.multiple(df1,c("FOO", "BAR"),c("|", "*"))
cSplit(temp, "Siblings", ",", direction = "long") #
View(cSplit(temp,2:ncol(temp),c(",",",",";"),type.convert=F)) #yicichaifen


#cum_sum
library(dplyr)
library(data.table)
library(readxl)
a <- read_excel("C:/Users/zhangguoliang/Desktop/a.xlsx", 
                sheet = "Sheet2")
View(a)
a<-arrange(a,desc(desc(id)))
df <- within(a, acc_sum <- cumsum(num))
df<-arrange(df,desc(id))

#dt[, acc_sum := cumsum(count)]
m#ySum = t(apply(df, 1, cumsum))

dfm <- structure(list(ID1 = structure(c(1L, 2L, 3L, 1L, 2L, 3L, 1L, 
                                        2L, 3L, 1L, 2L, 3L, 1L, 2L, 3L), .Label = c("ID1a", "ID1b", "ID1c"
                                        ), class = "factor"), ID2 = structure(c(1L, 1L, 1L, 2L, 
                                                                                2L, 2L, 3L, 3L, 3L, 4L, 4L, 4L, 5L, 5L, 5L), .Label = c("ID2a", 
                                                                                                                                        "ID2b", "ID2c", "ID2d", "ID2e"), class = "factor"), value = c(6459695L, 
                                                                                                                                                                                                      7263529L, 7740364L, 885473L, 1411355L, 1253524L, 648019L, 587785L, 
                                                                                                                                                                                                      682977L, 453613L, 612730L, 886897L, 1777308L, 2458672L, 3559283L
                                                                                                                                        )), .Names = c("ID1", "ID2", "value"), row.names = c(NA, 
                                                                                                                                                                                             -15L), class = "data.frame")
prop.table(tapply(dfm$value, dfm[1:2], sum), 1)
prop.table( xtabs(value ~., dfm), 1 )

library(reshape)
library(plyr)

df1 <- ddply(dfm, .(ID1), summarise, ID2 = ID2, pct = value / sum(value))
dfc <- cast(df1, ID1 ~ ID2)