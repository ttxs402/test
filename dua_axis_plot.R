
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

#按照数值大小排序柱子
a=data.frame(table(mtcars$cyl))
ggplot(a)+geom_bar(aes(reorder(Var1,Freq),weight=Freq))+theme(axis.text.x=element_text(angle=90,colour="black"))
ggplot(a, aes(x = reorder(Var1, Freq), y = Freq))+geom_bar(stat = "identity")
####
ggplot(diamonds,aes(x=reorder(clarity,depth),y=depth,fill=factor(cut))) + 
  geom_bar(stat='identity') + 
  coord_flip() + labs(y='depth',x='species')
#face_grid

p <- ggplot(mpg, aes(displ, cty)) + geom_point()

# Use vars() to supply variables from the dataset:
p + facet_grid(rows = vars(drv))
p + facet_grid(cols = vars(cyl))
p + facet_grid(vars(drv), vars(cyl))

# The historical formula interface is also available:

p + facet_grid(. ~ cyl)
p + facet_grid(drv ~ .)
p + facet_grid(drv ~ cyl)


# To change plot order of facet grid,
# change the order of variable levels with factor()

# If you combine a facetted dataset with a dataset that lacks those
# faceting variables, the data will be repeated across the missing
# combinations:
df <- data.frame(displ = mean(mpg$displ), cty = mean(mpg$cty))
p +
  facet_grid(cols = vars(cyl)) +
  geom_point(data = df, colour = "red", size = 2)

# Free scales -------------------------------------------------------
# You can also choose whether the scales should be constant
# across all panels (the default), or whether they should be allowed
# to vary
mt <- ggplot(mtcars, aes(mpg, wt, colour = factor(cyl))) +
  geom_point()

mt + facet_grid(. ~ cyl, scales = "free")

# If scales and space are free, then the mapping between position
# and values in the data will be the same across all panels. This
# is particularly useful for categorical axes
ggplot(mpg, aes(drv, model)) +
  geom_point() +
  facet_grid(manufacturer ~ ., scales = "free", space = "free") +
  theme(strip.text.y = element_text(angle = 0))

# Margins ----------------------------------------------------------

# Margins can be specified logically (all yes or all no) or for specific
# variables as (character) variable names
mg <- ggplot(mtcars, aes(x = mpg, y = wt)) + geom_point()
mg + facet_grid(vs + am ~ gear, margins = TRUE)
mg + facet_grid(vs + am ~ gear, margins = "am")
# when margins are made over "vs", since the facets for "am" vary
# within the values of "vs", the marginal facet for "vs" is also
# a margin over "am".
mg + facet_grid(vs + am ~ gear, margins = "vs")
