clc;
clear;
close all;
format compact;

outDir = fileparts(mfilename("fullpath"));
figDir = fullfile(outDir, "figures");
if ~exist(figDir, "dir")
    mkdir(figDir);
end

diary(fullfile(outDir, "experiment4_output.txt"));
disp("MATLAB Experiment 4: SIMULINK 基本用法");
disp("Run time:");
disp(datetime("now"));

%% Exercise 4-1: T1, T2, T3 系统的阶跃响应
disp("===== Exercise 4-1 =====");
disp("T1, T2, T3 系统的阶跃响应");
disp("T1(s) = 1/(s^2 + 2s + 1)");
disp("T2(s) = 1/(s^2 + 2s + 2)");
disp("T3(s) = 1/(s^2 + 2s + 3)");

num_common = [1];
den_T1 = [1 2 1];
den_T2 = [1 2 2];
den_T3 = [1 2 3];

T1 = tf(num_common, den_T1);
T2 = tf(num_common, den_T2);
T3 = tf(num_common, den_T3);

disp("T1 =");
T1
disp("T2 =");
T2
disp("T3 =");
T3

t41 = 0:0.01:10;
figure("Visible", "off");
step(T1, T2, T3, t41);
grid on;
legend("T1", "T2", "T3", "Location", "best");
title("练习4-1 T1、T2、T3 阶跃响应");
saveas(gcf, fullfile(figDir, "exercise_4_1.png"));
disp("图形已保存：exercise_4_1.png");

%% Exercise 4-2: 典型二阶欠阻尼系统仿真
disp("===== Exercise 4-2 =====");
disp("典型二阶欠阻尼系统的阶跃响应");
disp("G(s) = wn^2/(s^2 + 2*zeta*wn*s + wn^2)");
disp("极点: s = -sigma ± j*wa");

% ① 设 wa=1, sigma=0.5,1,5
disp("--- 4-2-①: wa=1, sigma=0.5,1,5 ---");
wa = 1;
sigma_vals = [0.5, 1, 5];

figure("Visible", "off");
hold on;
for i = 1:length(sigma_vals)
    sigma = sigma_vals(i);
    wn = sqrt(sigma^2 + wa^2);
    zeta = sigma / wn;
    num42 = [wn^2];
    den42 = [1 2*zeta*wn wn^2];
    G42 = tf(num42, den42);
    fprintf("sigma=%.1f: wn=%.4f, zeta=%.4f\n", sigma, wn, zeta);
    fprintf("  G(s) = %.4f/(s^2 + %.4fs + %.4f)\n", wn^2, 2*zeta*wn, wn^2);
    step(G42, t41);
end
hold off;
grid on;
legend("\sigma=0.5", "\sigma=1", "\sigma=5", "Location", "best");
title("练习4-2-① 阶跃响应 (wa=1, sigma变化)");
saveas(gcf, fullfile(figDir, "exercise_4_2_1.png"));
disp("图形已保存：exercise_4_2_1.png");

% ② 设 theta=30,45,60度, wn=2
disp("--- 4-2-②: theta=30,45,60度, wn=2 ---");
wn = 2;
theta_vals = [30, 45, 60];

figure("Visible", "off");
hold on;
for i = 1:length(theta_vals)
    theta = theta_vals(i);
    zeta = cosd(theta);
    sigma = zeta * wn;
    wa = wn * sqrt(1 - zeta^2);
    num42b = [wn^2];
    den42b = [1 2*zeta*wn wn^2];
    G42b = tf(num42b, den42b);
    fprintf("theta=%d°: zeta=%.4f, sigma=%.4f, wa=%.4f\n", theta, zeta, sigma, wa);
    fprintf("  G(s) = %.4f/(s^2 + %.4fs + %.4f)\n", wn^2, 2*zeta*wn, wn^2);
    step(G42b, t41);
end
hold off;
grid on;
legend("\theta=30°", "\theta=45°", "\theta=60°", "Location", "best");
title("练习4-2-② 阶跃响应 (wn=2, theta变化)");
saveas(gcf, fullfile(figDir, "exercise_4_2_2.png"));
disp("图形已保存：exercise_4_2_2.png");

%% Exercise 4-3: 非最小相位系统仿真
disp("===== Exercise 4-3 =====");
disp("非最小相位系统仿真");
disp("G(s) = 1.5/(s^2 + s + 1)");

% ① n(s)=1.5, 求阶跃响应及超调量、峰值时间、过渡过程时间
disp("--- 4-3-①: n(s)=1.5 ---");
num43_1 = [1.5];
den43 = [1 1 1];
G43_1 = tf(num43_1, den43);
disp("G(s) = 1.5/(s^2 + s + 1)");
G43_1

t43 = 0:0.01:15;
[y43_1, t43_1] = step(G43_1, t43);
[mp43, ind43] = max(y43_1);
yss43 = y43_1(end);
overshoot43 = 100 * (mp43 - yss43) / yss43;
tp43 = t43_1(ind43);
band43 = 0.02 * abs(yss43);
idx43 = find(abs(y43_1 - yss43) > band43, 1, "last");
if isempty(idx43)
    ts43 = 0;
else
    ts43 = t43_1(idx43);
end
fprintf("超调量: %.4f%%\n", overshoot43);
fprintf("峰值时间: %.4f s\n", tp43);
fprintf("过渡过程时间(2%%): %.4f s\n", ts43);
fprintf("稳态值: %.4f\n", yss43);

figure("Visible", "off");
plot(t43_1, y43_1, "b-", "LineWidth", 1.2);
grid on;
xlabel("t/s");
ylabel("y(t)");
title("练习4-3-① 阶跃响应 n(s)=1.5");
saveas(gcf, fullfile(figDir, "exercise_4_3_1.png"));
disp("图形已保存：exercise_4_3_1.png");

% ② n(s)=(-s+a)/a, a={1,3,6}
disp("--- 4-3-②: n(s)=(-s+a)/a, a={1,3,6} ---");
a_vals = [1, 3, 6];

figure("Visible", "off");
hold on;
% 先画①的响应作对比
plot(t43_1, y43_1, "k--", "LineWidth", 1.0);
for i = 1:length(a_vals)
    a = a_vals(i);
    num43_2 = [-1/a, 1];  % (-s+a)/a = -s/a + 1
    den43_2 = [1 1 1];
    G43_2 = tf(num43_2, den43_2);
    fprintf("a=%d: n(s)=(-s+%d)/%d\n", a, a, a);
    G43_2
    [y43_2, t43_2] = step(G43_2, t43);
    plot(t43_2, y43_2, "LineWidth", 1.1);
end
hold off;
grid on;
xlabel("t/s");
ylabel("y(t)");
legend("n=1.5 (参考)", "a=1", "a=3", "a=6", "Location", "best");
title("练习4-3-② 阶跃响应 n(s)=(-s+a)/a");
saveas(gcf, fullfile(figDir, "exercise_4_3_2.png"));
disp("图形已保存：exercise_4_3_2.png");

% ③ n(s)=(s+a)/a, a={1,3,6}
disp("--- 4-3-③: n(s)=(s+a)/a, a={1,3,6} ---");
figure("Visible", "off");
hold on;
% 先画①的响应作对比
plot(t43_1, y43_1, "k--", "LineWidth", 1.0);
for i = 1:length(a_vals)
    a = a_vals(i);
    num43_3 = [1/a, 1];  % (s+a)/a = s/a + 1
    den43_3 = [1 1 1];
    G43_3 = tf(num43_3, den43_3);
    fprintf("a=%d: n(s)=(s+%d)/%d\n", a, a, a);
    G43_3
    [y43_3, t43_3] = step(G43_3, t43);
    plot(t43_3, y43_3, "LineWidth", 1.1);
end
hold off;
grid on;
xlabel("t/s");
ylabel("y(t)");
legend("n=1.5 (参考)", "a=1", "a=3", "a=6", "Location", "best");
title("练习4-3-③ 阶跃响应 n(s)=(s+a)/a");
saveas(gcf, fullfile(figDir, "exercise_4_3_3.png"));
disp("图形已保存：exercise_4_3_3.png");

% ④ 列表表示结果
disp("--- 4-3-④: 结果汇总 ---");
disp("右平面零点 n(s)=(-s+a)/a:");
for i = 1:length(a_vals)
    a = a_vals(i);
    num43_2 = [-1/a, 1];
    den43_2 = [1 1 1];
    G43_2 = tf(num43_2, den43_2);
    [y43_2, t43_2] = step(G43_2, t43);
    [mp, ind] = max(y43_2);
    yss = y43_2(end);
    overshoot = 100 * (mp - yss) / yss;
    tp = t43_2(ind);
    fprintf("  a=%d: 超调量=%.2f%%, 峰值时间=%.4f s, 稳态值=%.4f\n", a, overshoot, tp, yss);
end

disp("左平面零点 n(s)=(s+a)/a:");
for i = 1:length(a_vals)
    a = a_vals(i);
    num43_3 = [1/a, 1];
    den43_3 = [1 1 1];
    G43_3 = tf(num43_3, den43_3);
    [y43_3, t43_3] = step(G43_3, t43);
    [mp, ind] = max(y43_3);
    yss = y43_3(end);
    overshoot = 100 * (mp - yss) / yss;
    tp = t43_3(ind);
    fprintf("  a=%d: 超调量=%.2f%%, 峰值时间=%.4f s, 稳态值=%.4f\n", a, overshoot, tp, yss);
end

diary off;
