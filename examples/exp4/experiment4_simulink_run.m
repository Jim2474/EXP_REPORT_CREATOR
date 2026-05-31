clc;
clear;
close all;
format compact;

outDir = fileparts(mfilename("fullpath"));
figDir = fullfile(outDir, "figures");
if ~exist(figDir, "dir")
    mkdir(figDir);
end

diary(fullfile(outDir, "experiment4_simulink_output.txt"));
disp("MATLAB Experiment 4: SIMULINK 仿真 (命令行方式)");
disp("Run time:");
disp(datetime("now"));

%% Exercise 4-1: T1, T2, T3 系统的阶跃响应 (SIMULINK)
disp("===== Exercise 4-1 =====");
disp("使用 SIMULINK 仿真 T1, T2, T3 系统的阶跃响应");

modelName = 'exp4_step';
if bdIsLoaded(modelName)
    close_system(modelName, 0);
end
new_system(modelName);
open_system(modelName);

% === 模块布局参数 (整齐排列) ===
stepX = 50;   stepY = 150;
tfX = 250;    tfGapY = 100;   % T1,T2,T3 垂直间距
muxX = 500;   muxY = 150;
scopeX = 700; scopeY = 100;
wsX = 700;    wsY = 250;
blockW = 100; blockH = 40;

% 添加 Step 模块
add_block('simulink/Sources/Step', [modelName '/Step'], ...
    'Position', [stepX, stepY, stepX+blockW, stepY+blockH]);
set_param([modelName '/Step'], 'Time', '0', 'Before', '0', 'After', '1');

% 添加 T1 = 1/(s^2+2s+1)
add_block('simulink/Continuous/Transfer Fcn', [modelName '/T1'], ...
    'Position', [tfX, stepY-tfGapY, tfX+blockW, stepY-tfGapY+blockH]);
set_param([modelName '/T1'], 'Numerator', '[1]', 'Denominator', '[1 2 1]');

% 添加 T2 = 1/(s^2+2s+2)
add_block('simulink/Continuous/Transfer Fcn', [modelName '/T2'], ...
    'Position', [tfX, stepY, tfX+blockW, stepY+blockH]);
set_param([modelName '/T2'], 'Numerator', '[1]', 'Denominator', '[1 2 2]');

% 添加 T3 = 1/(s^2+2s+3)
add_block('simulink/Continuous/Transfer Fcn', [modelName '/T3'], ...
    'Position', [tfX, stepY+tfGapY, tfX+blockW, stepY+tfGapY+blockH]);
set_param([modelName '/T3'], 'Numerator', '[1]', 'Denominator', '[1 2 3]');

% 添加 Mux (3输入)
add_block('simulink/Signal Routing/Mux', [modelName '/Mux'], ...
    'Position', [muxX, muxY, muxX+10, muxY+60], 'Orientation', 'right');
set_param([modelName '/Mux'], 'Inputs', '3');

% 添加 Scope
add_block('simulink/Sinks/Scope', [modelName '/Scope'], ...
    'Position', [scopeX, scopeY, scopeX+blockW, scopeY+blockH]);

% 添加 To Workspace
add_block('simulink/Sinks/To Workspace', [modelName '/ToWS'], ...
    'Position', [wsX, wsY, wsX+blockW, wsY+blockH]);
set_param([modelName '/ToWS'], 'VariableName', 'y41', 'SaveFormat', 'Timeseries');

% === 连线 (整齐的直线) ===
add_line(modelName, 'Step/1', 'T1/1', 'autorouting', 'on');
add_line(modelName, 'Step/1', 'T2/1', 'autorouting', 'on');
add_line(modelName, 'Step/1', 'T3/1', 'autorouting', 'on');
add_line(modelName, 'T1/1', 'Mux/1', 'autorouting', 'on');
add_line(modelName, 'T2/1', 'Mux/2', 'autorouting', 'on');
add_line(modelName, 'T3/1', 'Mux/3', 'autorouting', 'on');
add_line(modelName, 'Mux/1', 'Scope/1', 'autorouting', 'on');
add_line(modelName, 'Mux/1', 'ToWS/1', 'autorouting', 'on');

% 设置仿真参数
set_param(modelName, 'StopTime', '10');
set_param(modelName, 'Solver', 'ode45');
set_param(modelName, 'MaxStep', '0.01');

% 运行仿真
disp("运行 SIMULINK 仿真...");
simOut = sim(modelName);

% 提取数据并绘图
t41 = simOut.tout;
y41_data = simOut.y41.Data;
figure("Visible", "off");
plot(t41, squeeze(y41_data(:,1)), 'b-', 'LineWidth', 1.2); hold on;
plot(t41, squeeze(y41_data(:,2)), 'r--', 'LineWidth', 1.2);
plot(t41, squeeze(y41_data(:,3)), 'g:', 'LineWidth', 1.2);
hold off;
grid on;
xlabel('t/s');
ylabel('y(t)');
legend('T1', 'T2', 'T3', 'Location', 'best');
title('练习4-1 SIMULINK仿真: T1、T2、T3 阶跃响应');
saveas(gcf, fullfile(figDir, 'exercise_4_1_simulink.png'));
disp("图形已保存：exercise_4_1_simulink.png");

save_system(modelName, fullfile(outDir, [modelName '.slx']));
close_system(modelName, 0);

%% Exercise 4-2-①: sigma 变化 (SIMULINK)
disp("===== Exercise 4-2-① =====");
disp("使用 SIMULINK 仿真 sigma=0.5,1,5 的阶跃响应");

modelName2 = 'exp4_sigma';
if bdIsLoaded(modelName2)
    close_system(modelName2, 0);
end
new_system(modelName2);
open_system(modelName2);

% Step 输入 (幅值为2)
add_block('simulink/Sources/Step', [modelName2 '/Step'], ...
    'Position', [50, 150, 150, 190]);
set_param([modelName2 '/Step'], 'Time', '0', 'Before', '0', 'After', '2');

sigma_vals = [0.5, 1, 5];
wa = 1;
colors = {'b', 'r', 'g'};
lineStyles = {'-', '--', ':'};

for i = 1:length(sigma_vals)
    sigma = sigma_vals(i);
    wn = sqrt(sigma^2 + wa^2);
    zeta = sigma / wn;
    num = [wn^2];
    den = [1 2*zeta*wn wn^2];

    yPos = 50 + (i-1)*100;
    blockName = sprintf('G%d', i);
    add_block('simulink/Continuous/Transfer Fcn', [modelName2 '/' blockName], ...
        'Position', [300, yPos, 450, yPos+40]);
    set_param([modelName2 '/' blockName], 'Numerator', mat2str(num), 'Denominator', mat2str(den));

    wsName = sprintf('WS%d', i);
    add_block('simulink/Sinks/To Workspace', [modelName2 '/' wsName], ...
        'Position', [550, yPos, 680, yPos+40]);
    set_param([modelName2 '/' wsName], 'VariableName', sprintf('y42_%d', i), 'SaveFormat', 'Timeseries');

    add_line(modelName2, 'Step/1', [blockName '/1'], 'autorouting', 'on');
    add_line(modelName2, [blockName '/1'], [wsName '/1'], 'autorouting', 'on');

    fprintf("sigma=%.1f: wn=%.4f, zeta=%.4f, G(s)=%.4f/(s^2+%.4fs+%.4f)\n", sigma, wn, zeta, wn^2, 2*zeta*wn, wn^2);
end

set_param(modelName2, 'StopTime', '10');
set_param(modelName2, 'Solver', 'ode45');
set_param(modelName2, 'MaxStep', '0.01');

disp("运行 SIMULINK 仿真...");
simOut2 = sim(modelName2);
t42 = simOut2.tout;

figure("Visible", "off");
hold on;
for i = 1:length(sigma_vals)
    y_data = simOut2.(sprintf('y42_%d', i)).Data;
    plot(t42, squeeze(y_data), [colors{i} lineStyles{i}], 'LineWidth', 1.2);
end
hold off;
grid on;
xlabel('t/s');
ylabel('y(t)');
legend('\sigma=0.5', '\sigma=1', '\sigma=5', 'Location', 'best');
title('练习4-2-① SIMULINK仿真: sigma变化阶跃响应');
saveas(gcf, fullfile(figDir, 'exercise_4_2_1_simulink.png'));
disp("图形已保存：exercise_4_2_1_simulink.png");

save_system(modelName2, fullfile(outDir, [modelName2 '.slx']));
close_system(modelName2, 0);

%% Exercise 4-2-②: theta 变化 (SIMULINK)
disp("===== Exercise 4-2-② =====");
disp("使用 SIMULINK 仿真 theta=30,45,60度的阶跃响应");

modelName3 = 'exp4_theta';
if bdIsLoaded(modelName3)
    close_system(modelName3, 0);
end
new_system(modelName3);
open_system(modelName3);

add_block('simulink/Sources/Step', [modelName3 '/Step'], ...
    'Position', [50, 150, 150, 190]);
set_param([modelName3 '/Step'], 'Time', '0', 'Before', '0', 'After', '2');

theta_vals = [30, 45, 60];
wn = 2;

for i = 1:length(theta_vals)
    theta = theta_vals(i);
    zeta = cosd(theta);
    num = [wn^2];
    den = [1 2*zeta*wn wn^2];

    yPos = 50 + (i-1)*100;
    blockName = sprintf('G%d', i);
    add_block('simulink/Continuous/Transfer Fcn', [modelName3 '/' blockName], ...
        'Position', [300, yPos, 450, yPos+40]);
    set_param([modelName3 '/' blockName], 'Numerator', mat2str(num), 'Denominator', mat2str(den));

    wsName = sprintf('WS%d', i);
    add_block('simulink/Sinks/To Workspace', [modelName3 '/' wsName], ...
        'Position', [550, yPos, 680, yPos+40]);
    set_param([modelName3 '/' wsName], 'VariableName', sprintf('y43_%d', i), 'SaveFormat', 'Timeseries');

    add_line(modelName3, 'Step/1', [blockName '/1'], 'autorouting', 'on');
    add_line(modelName3, [blockName '/1'], [wsName '/1'], 'autorouting', 'on');

    fprintf("theta=%d°: zeta=%.4f, G(s)=%.4f/(s^2+%.4fs+%.4f)\n", theta, zeta, wn^2, 2*zeta*wn, wn^2);
end

set_param(modelName3, 'StopTime', '10');
set_param(modelName3, 'Solver', 'ode45');
set_param(modelName3, 'MaxStep', '0.01');

disp("运行 SIMULINK 仿真...");
simOut3 = sim(modelName3);
t43 = simOut3.tout;

figure("Visible", "off");
hold on;
for i = 1:length(theta_vals)
    y_data = simOut3.(sprintf('y43_%d', i)).Data;
    plot(t43, squeeze(y_data), [colors{i} lineStyles{i}], 'LineWidth', 1.2);
end
hold off;
grid on;
xlabel('t/s');
ylabel('y(t)');
legend('\theta=30°', '\theta=45°', '\theta=60°', 'Location', 'best');
title('练习4-2-② SIMULINK仿真: theta变化阶跃响应');
saveas(gcf, fullfile(figDir, 'exercise_4_2_2_simulink.png'));
disp("图形已保存：exercise_4_2_2_simulink.png");

save_system(modelName3, fullfile(outDir, [modelName3 '.slx']));
close_system(modelName3, 0);

%% Exercise 4-3: 非最小相位系统 (SIMULINK)
disp("===== Exercise 4-3 =====");
disp("使用 SIMULINK 仿真非最小相位系统");

modelName4 = 'exp4_nonmin';
if bdIsLoaded(modelName4)
    close_system(modelName4, 0);
end
new_system(modelName4);
open_system(modelName4);

add_block('simulink/Sources/Step', [modelName4 '/Step'], ...
    'Position', [50, 350, 150, 390]);
set_param([modelName4 '/Step'], 'Time', '0', 'Before', '0', 'After', '1');

% ① n(s)=1.5, G(s)=1.5/(s^2+s+1)
add_block('simulink/Continuous/Transfer Fcn', [modelName4 '/G1'], ...
    'Position', [300, 350, 450, 390]);
set_param([modelName4 '/G1'], 'Numerator', '[1.5]', 'Denominator', '[1 1 1]');

add_block('simulink/Sinks/To Workspace', [modelName4 '/WS1'], ...
    'Position', [550, 350, 680, 390]);
set_param([modelName4 '/WS1'], 'VariableName', 'y43_1', 'SaveFormat', 'Timeseries');

add_line(modelName4, 'Step/1', 'G1/1', 'autorouting', 'on');
add_line(modelName4, 'G1/1', 'WS1/1', 'autorouting', 'on');

% ② n(s)=(-s+a)/a, a={1,3,6}
a_vals = [1, 3, 6];
for i = 1:length(a_vals)
    a = a_vals(i);
    num_rhp = [-1/a, 1];
    yPos = 100 + (i-1)*80;
    blockName = sprintf('RHP%d', i);
    add_block('simulink/Continuous/Transfer Fcn', [modelName4 '/' blockName], ...
        'Position', [300, yPos, 450, yPos+40]);
    set_param([modelName4 '/' blockName], 'Numerator', mat2str(num_rhp), 'Denominator', '[1 1 1]');

    wsName = sprintf('WR%d', i);
    add_block('simulink/Sinks/To Workspace', [modelName4 '/' wsName], ...
        'Position', [550, yPos, 680, yPos+40]);
    set_param([modelName4 '/' wsName], 'VariableName', sprintf('y43_rhp_%d', i), 'SaveFormat', 'Timeseries');

    add_line(modelName4, 'Step/1', [blockName '/1'], 'autorouting', 'on');
    add_line(modelName4, [blockName '/1'], [wsName '/1'], 'autorouting', 'on');
end

% ③ n(s)=(s+a)/a, a={1,3,6}
for i = 1:length(a_vals)
    a = a_vals(i);
    num_lhp = [1/a, 1];
    yPos = 450 + (i-1)*80;
    blockName = sprintf('LHP%d', i);
    add_block('simulink/Continuous/Transfer Fcn', [modelName4 '/' blockName], ...
        'Position', [300, yPos, 450, yPos+40]);
    set_param([modelName4 '/' blockName], 'Numerator', mat2str(num_lhp), 'Denominator', '[1 1 1]');

    wsName = sprintf('WL%d', i);
    add_block('simulink/Sinks/To Workspace', [modelName4 '/' wsName], ...
        'Position', [550, yPos, 680, yPos+40]);
    set_param([modelName4 '/' wsName], 'VariableName', sprintf('y43_lhp_%d', i), 'SaveFormat', 'Timeseries');

    add_line(modelName4, 'Step/1', [blockName '/1'], 'autorouting', 'on');
    add_line(modelName4, [blockName '/1'], [wsName '/1'], 'autorouting', 'on');
end

set_param(modelName4, 'StopTime', '15');
set_param(modelName4, 'Solver', 'ode45');
set_param(modelName4, 'MaxStep', '0.01');

disp("运行 SIMULINK 仿真...");
simOut4 = sim(modelName4);
t43_all = simOut4.tout;

% 绘制 4-3-② 右平面零点
figure("Visible", "off");
hold on;
y_ref = squeeze(simOut4.y43_1.Data);
plot(t43_all, y_ref, 'k--', 'LineWidth', 1.0);
for i = 1:length(a_vals)
    y_data = squeeze(simOut4.(sprintf('y43_rhp_%d', i)).Data);
    plot(t43_all, y_data, 'LineWidth', 1.1);
end
hold off;
grid on;
xlabel('t/s');
ylabel('y(t)');
legend('n=1.5 (参考)', 'a=1', 'a=3', 'a=6', 'Location', 'best');
title('练习4-3-② SIMULINK仿真: 右平面零点响应');
saveas(gcf, fullfile(figDir, 'exercise_4_3_2_simulink.png'));
disp("图形已保存：exercise_4_3_2_simulink.png");

% 绘制 4-3-③ 左平面零点
figure("Visible", "off");
hold on;
plot(t43_all, y_ref, 'k--', 'LineWidth', 1.0);
for i = 1:length(a_vals)
    y_data = squeeze(simOut4.(sprintf('y43_lhp_%d', i)).Data);
    plot(t43_all, y_data, 'LineWidth', 1.1);
end
hold off;
grid on;
xlabel('t/s');
ylabel('y(t)');
legend('n=1.5 (参考)', 'a=1', 'a=3', 'a=6', 'Location', 'best');
title('练习4-3-③ SIMULINK仿真: 左平面零点响应');
saveas(gcf, fullfile(figDir, 'exercise_4_3_3_simulink.png'));
disp("图形已保存：exercise_4_3_3_simulink.png");

% 计算动态指标
disp("--- 4-3-④: 结果汇总 ---");
disp("右平面零点 n(s)=(-s+a)/a:");
for i = 1:length(a_vals)
    y_data = squeeze(simOut4.(sprintf('y43_rhp_%d', i)).Data);
    [mp, ind] = max(y_data);
    yss = y_data(end);
    overshoot = 100 * (mp - yss) / yss;
    tp = t43_all(ind);
    fprintf("  a=%d: 超调量=%.2f%%, 峰值时间=%.4f s, 稳态值=%.4f\n", a_vals(i), overshoot, tp, yss);
end

disp("左平面零点 n(s)=(s+a)/a:");
for i = 1:length(a_vals)
    y_data = squeeze(simOut4.(sprintf('y43_lhp_%d', i)).Data);
    [mp, ind] = max(y_data);
    yss = y_data(end);
    overshoot = 100 * (mp - yss) / yss;
    tp = t43_all(ind);
    fprintf("  a=%d: 超调量=%.2f%%, 峰值时间=%.4f s, 稳态值=%.4f\n", a_vals(i), overshoot, tp, yss);
end

save_system(modelName4, fullfile(outDir, [modelName4 '.slx']));
close_system(modelName4, 0);

disp("===== 所有仿真完成 =====");
diary off;
