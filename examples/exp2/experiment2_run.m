clc;
clear;
close all;
format compact;

outDir = fileparts(mfilename("fullpath"));
figDir = fullfile(outDir, "figures");
if ~exist(figDir, "dir")
    mkdir(figDir);
end

diary(fullfile(outDir, "experiment2_output.txt"));
disp("MATLAB Experiment 2: 控制系统的数学模型及时域分析");
disp("Run time:");
disp(datetime("now"));

%% Exercise 2-1
disp("===== Exercise 2-1 =====");
disp("求多项式 s^2 + 3s + 2 的根");
p21 = [1 3 2];
r21 = roots(p21)

%% Exercise 2-2
disp("===== Exercise 2-2 =====");
disp("已知根为 -1, -2, -3+j4, -3-j4，求多项式系数");
r22 = [-1 -2 -3+4i -3-4i];
p22 = poly(r22)

%% Exercise 2-3
disp("===== Exercise 2-3 =====");
disp("对 F(s) = (2s^3 + 9s + 1)/(s^3 + s^2 + 4s + 4) 进行部分分式展开");
b23 = [2 0 9 1];
a23 = [1 1 4 4];
[r23, p23, k23] = residue(b23, a23);
r23
p23
k23

%% Exercise 2-4
disp("===== Exercise 2-4 =====");
disp("求 H(s) = (s^3 + 11s^2 + 30s)/(s^4 + 9s^3 + 45s^2 + 87s + 50) 的零点、极点和增益");
num24 = [1 11 30 0];
den24 = [1 9 45 87 50];
[z24, p24, k24] = tf2zp(num24, den24);
z24
p24
k24

%% Exercise 2-5
disp("===== Exercise 2-5 =====");
disp("已知 G1(s)=(2s^2+5s+1)/(s^2+2s+3), G2(s)=5(s+2)/(s+10)，求负反馈闭环传递函数");
num1 = [2 5 1];
den1 = [1 2 3];
num2 = [5 10];
den2 = [1 10];
G1 = tf(num1, den1);
G2 = tf(num2, den2);
Gclosed = feedback(G1, G2);
[num25, den25] = tfdata(Gclosed, "v");
Gclosed
num25
den25

%% Exercise 2-6
disp("===== Exercise 2-6 =====");
disp("绘制 V=120sin(wt)、I=100sin(wt-pi/4) 以及 P=V*I 曲线");
wt = 0:pi/50:2*pi;
V = 120 * sin(wt);
I = 100 * sin(wt - pi/4);
P = V .* I;
figure("Visible", "off");
subplot(1,2,1);
plot(wt, V, "b-", wt, I, "r--", "LineWidth", 1.2);
grid on;
xlabel("\omega t");
ylabel("V, I");
legend("V=120sin(\omega t)", "I=100sin(\omega t-\pi/4)", "Location", "best");
title("电压与电流曲线");
subplot(1,2,2);
plot(wt, P, "k*", "MarkerSize", 4);
grid on;
xlabel("\omega t");
ylabel("P");
title("功率曲线 P=V\cdot I");
saveas(gcf, fullfile(figDir, "exercise_2_6.png"));
disp("图形已保存：exercise_2_6.png");

%% Exercise 2-7
disp("===== Exercise 2-7 =====");
disp("绘制 y1, y2, y3，并求 y1 的最小值与最大值");
t = 0:0.05:20;
y1 = 2.62 * exp(-0.25*t) .* cos(2.22*t + deg2rad(174)) + 0.6;
y2 = 2.62 * exp(-0.25*t) + 0.6;
y3 = 0.6 * ones(size(t));
y1_min = min(y1)
y1_max = max(y1)
figure("Visible", "off");
plot(t, y1, "b-", t, y2, "r--", t, y3, "k:", "LineWidth", 1.2);
grid on;
xlabel("t");
ylabel("y");
legend("y1(t)", "y2(t)", "y3(t)", "Location", "best");
title("练习2-7 函数曲线");
saveas(gcf, fullfile(figDir, "exercise_2_7.png"));
disp("图形已保存：exercise_2_7.png");

%% Exercise 2-8
disp("===== Exercise 2-8 =====");
disp("调用 stepchar 函数计算示例系统 G(s)=25/(s^2+4s+25) 的阶跃响应特征参数");
num28 = [25];
den28 = [1 4 25];
t28 = 0:0.01:5;
[y28, t28] = step(tf(num28, den28), t28);
[pos28, tr28, ts28, tp28] = local_stepchar(t28, y28);
pos28
tr28
tp28
ts28

%% Exercise 2-9
disp("===== Exercise 2-9 =====");
disp("计算 G1, G2, G3 的阶跃响应特征参数");
systems29 = {
    "G1(s)=2/(s^2+2s+2)", tf([2], [1 2 2]);
    "G2(s)=(4s+2)/(s^2+2s+2)", tf([4 2], [1 2 2]);
    "G3(s)=1/(2s^3+3s^2+3s+1)", tf([1], [2 3 3 1])
};
t29 = 0:0.01:12;
figure("Visible", "off");
hold on;
for idx = 1:size(systems29, 1)
    name = systems29{idx, 1};
    sys = systems29{idx, 2};
    [y, ttmp] = step(sys, t29);
    [pos, tr, ts, tp] = local_stepchar(ttmp, y);
    fprintf("%s\n", name);
    fprintf("  Overshoot = %.4f %%\n", pos);
    fprintf("  RiseTime  = %.4f s\n", tr);
    fprintf("  PeakTime  = %.4f s\n", tp);
    fprintf("  SettlingTime = %.4f s\n", ts);
    plot(ttmp, y, "LineWidth", 1.1);
end
hold off;
grid on;
xlabel("t/s");
ylabel("响应值");
legend("G1", "G2", "G3", "Location", "best");
title("练习2-9 阶跃响应曲线");
saveas(gcf, fullfile(figDir, "exercise_2_9.png"));
disp("图形已保存：exercise_2_9.png");

%% Exercise 2-10
disp("===== Exercise 2-10 =====");
disp("给定 C(s)/R(s)=25/(s^2+4s+25)，求阶跃响应曲线及动态指标");
sys210 = tf([25], [1 4 25]);
t210 = 0:0.01:5;
[y210, t210] = step(sys210, t210);
[pos210, tr210, ts210, tp210] = local_stepchar(t210, y210);
pos210
tr210
tp210
ts210
figure("Visible", "off");
plot(t210, y210, "b-", "LineWidth", 1.2);
grid on;
xlabel("t/s");
ylabel("c(t)");
title("练习2-10 单位阶跃响应");
saveas(gcf, fullfile(figDir, "exercise_2_10.png"));
disp("图形已保存：exercise_2_10.png");

diary off;

function [pos, tr, ts2, tp] = local_stepchar(t, y)
    y = y(:);
    t = t(:);
    [mp, ind] = max(y);
    dimt = length(t);
    yss = y(dimt);
    pos = 100 * (mp - yss) / yss;
    tp = t(ind);

    i = find(y >= 0.1 * yss, 1, "first");
    j = find(y >= 0.9 * yss, 1, "first");
    if isempty(i) || isempty(j)
        tr = NaN;
    else
        tr = t(j) - t(i);
    end

    band = 0.02 * abs(yss);
    idx = find(abs(y - yss) > band, 1, "last");
    if isempty(idx)
        ts2 = 0;
    elseif idx < dimt
        ts2 = t(idx + 1);
    else
        ts2 = t(end);
    end
end
