clc;
clear;
close all;
format compact;

outDir = fileparts(mfilename("fullpath"));
figDir = fullfile(outDir, "figures");
if ~exist(figDir, "dir")
    mkdir(figDir);
end

diary(fullfile(outDir, "experiment3_output.txt"));
disp("MATLAB Experiment 3: 线性控制系统的频域响应分析");
disp("Run time:");
disp(datetime("now"));

%% Exercise 3-1: Bode图绘制
disp("===== Exercise 3-1 =====");
disp("绘制开环传递函数 G(s)=10/(s(s+1)(s+5)) 的Bode图");
num31 = [10];
den31 = [1 6 5 0];
G31 = tf(num31, den31);
[mag31, phase31, w31] = bode(G31);
disp("传递函数 G(s):");
G31
disp("幅值 mag (前5个点):");
disp(squeeze(mag31(1,1,1:5)));
disp("相角 phase (前5个点):");
disp(squeeze(phase31(1,1,1:5)));
disp("频率 w (前5个点):");
disp(w31(1:5));
figure("Visible", "off");
bode(G31);
grid on;
title("练习3-1 Bode图");
saveas(gcf, fullfile(figDir, "exercise_3_1.png"));
disp("图形已保存：exercise_3_1.png");

%% Exercise 3-2: 稳定裕度计算
disp("===== Exercise 3-2 =====");
disp("计算开环传递函数 G(s)=10/(s(s+1)(s+5)) 的稳定裕度");
[mg32, pm32, wg32, wp32] = margin(G31);
fprintf("幅值裕度 mg = %.4f\n", mg32);
fprintf("相角裕度 pm = %.4f 度\n", pm32);
fprintf("相角交接频率 wg = %.4f rad/s\n", wg32);
fprintf("截止频率 wp = %.4f rad/s\n", wp32);
figure("Visible", "off");
margin(G31);
grid on;
title("练习3-2 稳定裕度Bode图");
saveas(gcf, fullfile(figDir, "exercise_3_2.png"));
disp("图形已保存：exercise_3_2.png");

%% Exercise 3-3: Nyquist图绘制
disp("===== Exercise 3-3 =====");
disp("绘制开环传递函数 G(s)=10/(s(s+1)(s+2)) 的Nyquist图");
num33 = [10];
den33 = [1 3 2 0];
G33 = tf(num33, den33);
[re33, im33, w33] = nyquist(G33);
disp("传递函数 G(s):");
G33
disp("实部 re (前5个点):");
disp(squeeze(re33(1,1,1:5)));
disp("虚部 im (前5个点):");
disp(squeeze(im33(1,1,1:5)));
disp("频率 w (前5个点):");
disp(w33(1:5));
figure("Visible", "off");
nyquist(G33);
grid on;
title("练习3-3 Nyquist图");
saveas(gcf, fullfile(figDir, "exercise_3_3.png"));
disp("图形已保存：exercise_3_3.png");

%% Exercise 3-4: 根轨迹绘制
disp("===== Exercise 3-4 =====");
disp("绘制开环传递函数 G(s)=K/(s(s+1)(s+2)) 的根轨迹");
num34 = [1];
den34 = [1 3 2 0];
G34 = tf(num34, den34);
[r34, k34] = rlocus(G34);
disp("传递函数 G(s):");
G34
disp("增益向量 k (前10个点):");
disp(k34(1:10));
disp("根的位置 r (前5个增益值对应的根):");
disp(r34(:, 1:5));
figure("Visible", "off");
rlocus(G34);
grid on;
title("练习3-4 根轨迹");
saveas(gcf, fullfile(figDir, "exercise_3_4.png"));
disp("图形已保存：exercise_3_4.png");

%% Exercise 3-5: 不同增益下的阶跃响应
disp("===== Exercise 3-5 =====");
disp("绘制不同增益K下闭环系统的阶跃响应");
K_values = [0.5, 1, 2, 5];
figure("Visible", "off");
hold on;
for idx = 1:length(K_values)
    K = K_values(idx);
    G_open = tf(K, den34);
    G_closed = feedback(G_open, 1);
    [y, t] = step(G_closed);
    plot(t, y, "LineWidth", 1.2);
    fprintf("K = %.1f: ", K);
    [pos, tr, ts, tp] = local_stepchar(t, y);
    fprintf("超调量=%.2f%%, 上升时间=%.2fs, 调整时间=%.2fs, 峰值时间=%.2fs\n", pos, tr, ts, tp);
end
hold off;
grid on;
xlabel("t/s");
ylabel("响应值");
legend("K=0.5", "K=1", "K=2", "K=5", "Location", "best");
title("练习3-5 不同增益下的阶跃响应");
saveas(gcf, fullfile(figDir, "exercise_3_5.png"));
disp("图形已保存：exercise_3_5.png");

%% Exercise 3-6: 频率响应数据表
disp("===== Exercise 3-6 =====");
disp("绘制开环传递函数 G(s)=20/(s(s+2)(s+4)) 的Bode图并计算稳定裕度");
num36 = [20];
den36 = [1 6 8 0];
G36 = tf(num36, den36);
disp("传递函数 G(s):");
G36
[mag36, phase36, w36] = bode(G36);
[mg36, pm36, wg36, wp36] = margin(G36);
fprintf("幅值裕度 mg = %.4f\n", mg36);
fprintf("相角裕度 pm = %.4f 度\n", pm36);
fprintf("相角交接频率 wg = %.4f rad/s\n", wg36);
fprintf("截止频率 wp = %.4f rad/s\n", wp36);
figure("Visible", "off");
margin(G36);
grid on;
title("练习3-6 稳定裕度Bode图");
saveas(gcf, fullfile(figDir, "exercise_3_6.png"));
disp("图形已保存：exercise_3_6.png");

%% Exercise 3-7: Nyquist图与稳定性判断
disp("===== Exercise 3-7 =====");
disp("绘制开环传递函数 G(s)=5/(s(s+1)(s+3)) 的Nyquist图并判断闭环稳定性");
num37 = [5];
den37 = [1 4 3 0];
G37 = tf(num37, den37);
disp("传递函数 G(s):");
G37
[re37, im37, w37] = nyquist(G37);
figure("Visible", "off");
nyquist(G37);
grid on;
title("练习3-7 Nyquist图");
saveas(gcf, fullfile(figDir, "exercise_3_7.png"));
disp("图形已保存：exercise_3_7.png");
G_closed37 = feedback(G37, 1);
disp("闭环传递函数:");
G_closed37
poles37 = pole(G_closed37);
disp("闭环极点:");
poles37
if all(real(poles37) < 0)
    disp("系统稳定（所有极点实部为负）");
else
    disp("系统不稳定");
end

%% Exercise 3-8: 多系统根轨迹对比
disp("===== Exercise 3-8 =====");
disp("绘制两个系统的根轨迹并对比");
G38a = tf([1], [1 3 2 0]);
G38b = tf([1 2], [1 3 2 0]);
figure("Visible", "off");
subplot(1,2,1);
rlocus(G38a);
grid on;
title("G1(s)=1/(s(s+1)(s+2))");
subplot(1,2,2);
rlocus(G38b);
grid on;
title("G2(s)=(s+2)/(s(s+1)(s+2))");
saveas(gcf, fullfile(figDir, "exercise_3_8.png"));
disp("图形已保存：exercise_3_8.png");

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
