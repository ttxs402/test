#201810051446

library(readxl)
library(stringr)
library(openxlsx)
X1_1 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/2019年秋季学生/2019年秋季学生/1_1.xlsx")
X1_2 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/2019年秋季学生/2019年秋季学生/1_2.xlsx")
X2_1 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/2019年秋季学生/2019年秋季学生/2_1.xlsx")
X2_2 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/2019年秋季学生/2019年秋季学生/2_2.xlsx")
X3_1 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/2019年秋季学生/2019年秋季学生/3_1.xlsx")
X3_2 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/2019年秋季学生/2019年秋季学生/3_2.xlsx")
X4_1 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/2019年秋季学生/2019年秋季学生/4_1.xlsx")
X4_2 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/2019年秋季学生/2019年秋季学生/4_2.xlsx")
X5_1 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/2019年秋季学生/2019年秋季学生/5_1.xlsx")
X5_2 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/2019年秋季学生/2019年秋季学生/5_2.xlsx")
X6_1 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/2019年秋季学生/2019年秋季学生/6_1.xlsx")
X6_2 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/2019年秋季学生/2019年秋季学生/6_2.xlsx")

data_all <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/农村低保数据库2019.7.xlsx")
##20180808
data_all$id_no<-toupper(str_trim(data_all$身份证号))
X1_1$id_no<-toupper(str_trim(X1_1$身份证件号))
X1_2$id_no<-toupper(str_trim(X1_2$身份证件号))
X2_1$id_no<-toupper(str_trim(X2_1$身份证件号))
X2_2$id_no<-toupper(str_trim(X2_2$身份证件号))
X3_1$id_no<-toupper(str_trim(X3_1$身份证件号))
X3_2$id_no<-toupper(str_trim(X3_2$身份证件号))
X4_1$id_no<-toupper(str_trim(X4_1$身份证件号))
X4_2$id_no<-toupper(str_trim(X4_2$身份证件号))
X5_1$id_no<-toupper(str_trim(X5_1$身份证件号))
X5_2$id_no<-toupper(str_trim(X5_2$身份证件号))
X6_1$id_no<-toupper(str_trim(X6_1$身份证件号))
X6_2$id_no<-toupper(str_trim(X6_2$身份证件号))
#加入年级
X1_1$年级<-'1_1'
X1_2$年级<-'1_2'
X2_1$年级<-'2_1'
X2_2$年级<-'2-2'
X3_1$年级<-'3_1'
X3_2$年级<-'3_2'
X4_1$年级<-'4_1'
X4_2$年级<-'4_2'
X5_1$年级<-'5_1'
X5_2$年级<-'5_2'
X6_1$年级<-'6_1'
X6_2$年级<-'6_2'
X1_1 <- X1_1[,c(3,4,8,9)]
X1_2 <- X1_2[,c(3,4,8,9)]
X2_1 <- X2_1[,c(2,5,13,14)]
X2_2 <- X2_2[,c(2,5,13,14)]
X3_1 <- X3_1[,c(2,5,13,14)]
X3_2 <- X3_2[,c(2,5,13,14)]
X4_1 <- X4_1[,c(2,5,13,14)]
X4_2 <- X4_2[,c(2,5,13,14)]
X5_1 <- X5_1[,c(2,5,13,14)]
X5_2 <- X5_2[,c(2,5,13,14)]
X6_1 <- X6_1[,c(2,5,13,14)]
X6_2 <- X6_2[,c(2,5,13,14)]
names(X1_1) <- names(X2_1)
names(X1_2) <- names(X2_1)
a1<-rbind( merge(X1_1,data_all,by=c('id_no')),
  merge(X1_2,data_all,by=c('id_no')),
  merge(X2_1,data_all,by=c('id_no')),
  merge(X2_2,data_all,by=c('id_no')),
  merge(X3_1,data_all,by=c('id_no')),
  merge(X3_2,data_all,by=c('id_no')),
  merge(X4_1,data_all,by=c('id_no')),
  merge(X4_2,data_all,by=c('id_no')),
  merge(X5_1,data_all,by=c('id_no')),
  merge(X6_1,data_all,by=c('id_no')),
  merge(X6_2,data_all,by=c('id_no')))

X5_2$id_no1<-str_trim(X5_2$id_no)
a<-merge(X5_2,data_all,by=c('id_no1'))
#Sys.getenv("PATH")
Sys.setenv("R_ZIPCMD"="D:/R/Rtools/bin/zip")
#Sys.setenv("R_ZIPCMD" = "path/to/zip.exe")
library(openxlsx)
openxlsx::write.xlsx(a1,file='pinkun1.xlsx')
#write_excel_csv(a,path = "C:/Users/guoliang.zhang/Desktop/贫困比对/a.xlsx")
getwd() 
#20190926
#20191106

