


> Written with [StackEdit](https://stackedit.io/).
**Matlab的学习总的来说万丈高楼平地起，能有好的、较为简单的实例进行基础性实践是非常珍贵的，有幸能接触到《激光原理》书中关于平行平面腔的迭代解法的相关知识，故在此进行详细的剖析与记录。**  
## 理论公式  
详见书上章节2.4，所谓迭代法，在这个平行平面腔中，有基础公式如下：<br>  
$$ u_{j+1} =\int\int_S{Ku_j}ds'$$
形成稳定场，则在$j$足够大时，$u_j$，$u_{j+1}$，$u_{j+2}$有如下关系：<br>
$$\left\{
\begin{matrix}
u_{j+1}=\frac{1}{\gamma}u_j\\
u_{j+2}=\frac{1}{\gamma}u_{j+1}
\end{matrix}
\right.$$
式中：$\gamma$为复常数。如果直接数值计算得出了这种稳定的场分布，则可认为找到了腔的一个自再现模或横模。<br>
下面，我们以对称条状腔为例，考察镜的宽度为$2a$，腔长为$L$的对称条状腔，按照推导出的近似公式有：<br>
$$
\left\{
\begin{matrix}
u_2(x)=\sqrt{\frac{i}{\lambda L}e^{-ikL}}\displaystyle \int_{-a}^{+a}{e^{-ik\frac{(x-x')^2}{2L}}u_1(x')dx'}\\
u_3(x‘)=\sqrt{\frac{i}{\lambda L}e^{-ikL}}\displaystyle \int_{-a}^{+a}{e^{-ik\frac{(x'-x)^2}{2L}}u_2(x')dx'}
\end{matrix}
\right.
$$
以一列均匀平面波作为第一个镜面上的初始激发波，我们可以取$$u_1\equiv1$$即认为整个镜面为等相位面（$argu_1=0$），且镜面上各点波的振幅均为1。代入上述积分式之后进行数值计算求出$u_2$，然后将$u_2$归一化，即取$$|u_2|_{max}=1$$并代入积分式算出$u_3$，以此类推。<br>
下在此基础上进行对进行多次迭代后的相对振幅与相对相位进行探讨。
## MATLAB代码详解
[完整代码](https://github.com/Ye110ws4ar/matlab4paperwriting/blob/practice-in-laser/iteration.m)<br>
其中比较值得注意的是代码中定义的一个函数：<br>
```
function y=QU(x,u)
global lambda steps L k a;
x_ = linspace(-a,a,steps);
step_length = 2*a/(steps-1);
y=sqrt(1i/(lambda*L)*exp(-1i*k*L))*sum(exp(-1i*k/2/L*(-x_+x).^2).*u)*step_length;
end
```
<br>这个函数实际上就是上述的积分式，但是又有稍许不同，输入的x与输出的y只是一个数而不是一个数组，只能表示输出面其中的某一点的结果，在实际使用时就有了如下积分来表示一次完整的迭代： <br>
```
for mm=1:steps
	u0(mm)=QU(x(mm),u_);
end
```
为了归一化又用到一下语句：`u_=u0/max(abs(u0));`而后回代上式进行下一次迭代，所以总体的迭代N1次的代码为：<br>
```
k = 2*pi/lambda;
steps = 500;\\初始化的总步数
x = linspace(-a,a,steps);
u_ = ones(1,steps);\\初始化的u1
for m=1:N1
	for mm=1:steps
		u0(mm)=QU(x(mm),u_);
	end
	u_=u0/max(abs(u0));
end
```
如此我们就可以得到迭代N1次后的u0数组，下一步就是编写我们需要的相对相位，所谓相对相位是相对于中心点的相位，而求相位的操作我们可以利用MATLAB现有的`angle`函数，总体代码如下：<br>
```
angle_u0=angle(u0)/pi*180;
angle_u0=angle_u0-angle_u0(steps/2);
```
<br>至此所需数组已全部求出，进行画图即可。
