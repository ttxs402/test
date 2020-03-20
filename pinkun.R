#201810051446

library(readxl)
library(stringr)
library(openxlsx)
#1、读取贫困户数据
data_all_nc <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/20200320比对/2020.03(农村低保数据库).xls")
data_all_cs <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/20200320比对/2020.03(城市低保数据库).xls")
data_all_fp <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/20200320比对/2019.12.02（扶贫数据库）.xls")
data_all_nc1 <- data_all_nc[,c('身份证号','姓名')]
data_all_cs1 <- data_all_cs[,c('身份证号','姓名')]
data_all_fp1 <- data_all_fp[,c('证件号码','姓名')]
names(data_all_fp1) <- names(data_all_cs1)
data_all_nc1[,'贫困类型'] <- '农村'
data_all_cs1[,'贫困类型'] <- '城市'
data_all_fp1[,'贫困类型'] <- '扶贫'
data_all <- rbind(data_all_nc1,data_all_cs1,data_all_fp1)

#2、读取学生数据
X1_1 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/20200320比对/2019年秋季学生/2019年秋季学生/1_1.xlsx")
X1_2 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/20200320比对/2019年秋季学生/2019年秋季学生/1_2.xlsx")
X2_1 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/20200320比对/2019年秋季学生/2019年秋季学生/二（1）.xls")
X2_2 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/20200320比对/2019年秋季学生/2019年秋季学生/二（2）.xls")
X3_1 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/20200320比对/2019年秋季学生/2019年秋季学生/三（1）.xls")
X3_2 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/20200320比对/2019年秋季学生/2019年秋季学生/三（2）.xls")
X4_1 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/20200320比对/2019年秋季学生/2019年秋季学生/四（1）.xls")
X4_2 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/20200320比对/2019年秋季学生/2019年秋季学生/四（2）.xls")
X5_1 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/20200320比对/2019年秋季学生/2019年秋季学生/五年级.xls")
#X5_2 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/20200320比对/2019年秋季学生/2019年秋季学生/二（1）.xls")
X6_1 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/20200320比对/2019年秋季学生/2019年秋季学生/六（1）.xls")
X6_2 <- read_excel("C:/Users/guoliang.zhang/Desktop/贫困比对/20200320比对/2019年秋季学生/2019年秋季学生/六（2）.xls")


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
X1_1 <- X1_1[,c(3,4,38,39)]
X1_2 <- X1_2[,c(3,4,38,39)]
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

# X5_2$id_no1<-str_trim(X5_2$id_no)
# a<-merge(X5_2,data_all,by=c('id_no1'))
#Sys.getenv("PATH")
Sys.setenv("R_ZIPCMD"="D:/R/Rtools/bin/zip")
#Sys.setenv("R_ZIPCMD" = "path/to/zip.exe")
library(openxlsx)
openxlsx::write.xlsx(a1,file='pinkun_20200320.xlsx')
#write_excel_csv(a,path = "C:/Users/guoliang.zhang/Desktop/贫困比对/a.xlsx")
getwd() 
#20190926
#20191106

