# 写在前面：MATLAB绘制图像主要有两个主要的部分，一个是书写函数，一个是绘制图像
## ACF图像绘制
我们先看ACF的公式：![](https://github.com/Ye110ws4ar/matlab4paperwriting/blob/ACF/ACF%E5%85%AC%E5%BC%8F.png)
<br>说实在的现在水平比较差而且处于学习阶段，我们先看学长提供的代码然后慢慢分析，我们先看函数部分：<br>
<pre>
function [D,A1]=auto_corr1(Pout)//自定义
global h
i=1;
P1=Pout(floor(length(Pout)/2):floor(0.75*length(Pout)));
for dt=-100e-9:2e-12:100e-9
P2=Pout(floor(floor(length(Pout)/2)+floor(dt/h)):floor(floor(0.75*length(Pout))+floor(dt/h)));
c12=mean((P1-mean(P1)).*(P2-mean(P1)))/(mean((P1-mean(P1)).^2));
A1(i)=c12;
i=i+1;
end
D=-100:2e-3:00;
</pre>
可以看出为了实现上面的公式，我们让P1是读取数据Pout的一部分数据，P2则是时移后的P1，c12是对P1和P2进行了类似于上述公式的计算。接下来我们来看绘制图像部分：<br>
<pre>
clc;
clear all;
global h
h=1/8e10;
Pout=importdata('C3--1226--00000.dat');
%%ACF
figure;
ACF_2=autocorr(Pout,length(Pout)-1);
plot((1:length(ACF_2))*0.125,ACF_2);
axis([0 100 -1 1.2])
%%ACF
[D,A1]=auto_corr1(Pout);
figure
plot(D,A1,'k')
axis([-100 100 -1 1.2])
</pre>
