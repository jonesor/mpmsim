library(showtext)
library(ggplot2)
library(reshape)
library(RColorBrewer)

myPalette <- colorRampPalette(rev(brewer.pal(10, "RdYlGn")), space="Lab")

set.seed(12)
m1<-mpmsim::random_mpm(n_stage = 6,fecundity =seq(.5,.6,length.out = 6))


m1 <- m1[nrow(m1):1, ]
m1 <- t(m1)

df<- melt(m1)
colnames(df) <- c("x", "y", "value")
df

p<-ggplot(df, aes(x = x, y = y, fill = value)) +
  geom_tile() + theme_void() +
  scale_fill_gradientn(colours = myPalette(100))+
  theme(legend.position="none")



## Loading Google fonts (http://www.google.com/fonts)
font_add_google("Montserrat", "montserrat")
## Automatically use showtext to render text for future devices
showtext_auto()

## use the ggplot2 example
sticker(p, package="mpmsim", p_size=26, s_x=1, s_y=.75, s_width=1.1, s_height=.9,
        p_family = "montserrat",h_color="#45ba9b", h_fill="#16A085",filename="man/figures/logo_mpmsim.png")

