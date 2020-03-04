
dua_y_plot <- function(data,xlab,y_prim,y_sec){
  y_left_max <- max(data[,y_prim])
  y_right_max <- max(data[,y_sec])
  ylim.prim <- c(0, y_left_max)   # in this example, precipitation
  ylim.sec <- c(0, y_right_max)
  b <- diff(ylim.prim)/diff(ylim.sec)
  a <- b*(ylim.prim[1] - ylim.sec[1])
  Month <- data[,xlab]
  Precip <- data[,y_prim]
  Temp <- data[,y_sec]
  p1<-  ggplot(data, aes(Month, Precip)) +
    geom_col() +
    geom_text(data=data, aes(x = Month, y = Precip, label = paste0(round(Precip, 1)) ,colour = 'pink'),show.legend = F, vjust = -0.1) +
    geom_line(data=data,aes(y = Temp/y_right_max*y_left_max,group = xlab), color = "red") +
    scale_y_continuous("Precipitation",limits = c(0, y_left_max), sec.axis = sec_axis(~ (. - a)/b, name = "Temperature"))+
    geom_point(data=data, aes(x = Month, y = Temp/y_right_max*y_left_max), colour = 'red', shape=21, fill="white")+
    geom_text(data=data, aes(x = Month, y = Temp/y_right_max*y_left_max, label = Temp), colour = 'red', vjust = 1)+
    theme(axis.line.y.right = element_line(color = "red"), 
          axis.ticks.y.right = element_line(color = "red"),
          axis.text.y.right = element_text(color = "red"), 
          axis.title.y.right = element_text(color = "red")
    ) +labs(x = xlab,title = xlab)
  return(p1)
}
dua_y_plot(data = test_data,xlab = 'var1',y_prim = 'num',y_sec = 'rato')

test_data1 <- economics[1:10,c(1,2,5)]
test_data1 <- data.frame(test_data1)
dua_y_plot(data = test_data1,xlab = 'date',y_prim = 'pce',y_sec = 'uempmed')
