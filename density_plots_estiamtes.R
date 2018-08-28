setwd("G:/Epidata Share/9) Tali Analyses/THESIS/propensity_scores/simulation study")
data1<-read.csv("0_output_unconfounded.csv")
data2<-read.csv("2_output_sim_yoshida.csv")
data3<-read.csv("3_output_sim_adjust.csv")
data4<-read.csv("4_output_sim_matched_pairwise.csv")
data5<-read.csv("4_output_sim_matched_pairwise_andcontrol.csv")

mean1<-mean(data1$exp.1)
mean2<-mean(data2$exp.1)
mean3<-mean(data3$exp.1)
mean4<-mean(data4$exp.1)
mean5<-mean(data5$exp.1)



plot(density(data2$exp.1),col="cyan" , lty=1,ylim=c(0,3.5), main="Distribution of Hazards Ratios, exp=2")

 abline(v=mean2, col="cyan")
lines(density(data3$exp.1), col="purple", lty=1)
abline(v=mean3, col="purple", lty=1)
lines(density(data4$exp.1), col="green", lty=1)
abline(v=mean4, col="green", lty=1)
legend("topright", c("weights","adjusting","matched", "truth"), col=c( "cyan", "purple", "green","black"), lty=c(1,1,1,2))
abline(v=1.5, lty=2)




mean1<-mean(data1$exp.2)
mean2<-mean(data2$exp.2)
mean3<-mean(data3$exp.2)
mean4<-mean(data4$exp.2)



plot(density(data2$exp.2),col="cyan" , lty=1,ylim=c(0,3.5), main="Distribution of Hazards Ratios, exp=1")

abline(v=mean2, col="cyan")
lines(density(data3$exp.2), col="purple", lty=1)
abline(v=mean3, col="purple", lty=1)
lines(density(data4$exp.2), col="green", lty=1)
abline(v=mean4, col="green", lty=1)
legend("topright", c("weights","adjusting","matched", "truth"), col=c( "cyan", "purple", "green","black"), lty=c(1,1,1,2))
abline(v=1.5, lty=2)

