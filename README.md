# EXP Report Creator

一个用于自动生成 MATLAB 实验报告的原型项目。

当前目标是把“实验指导书 + MATLAB 实验代码 + 真实运行结果”整理成可打印的 A4 Word 实验报告。项目会优先使用 MATLAB 批处理真实运行 `.m` 文件，再把命令行输出渲染成 MATLAB 风格结果图；曲线图由 MATLAB 直接保存。

## 已验证流程

以 `examples/exp2` 为例：

1. 运行 MATLAB 实验脚本，生成文本输出和曲线图。
2. 将命令行输出按题号拆分。
3. 渲染成类似 MATLAB 命令窗口的白底输出图。
4. 将输出图和 MATLAB 曲线图排版进 A4 竖版 `.docx` 报告。

## 环境要求

- Windows
- MATLAB，且 `matlab.exe` 可从命令行调用
- Python 3.10+
- Python 依赖见 `requirements.txt`

## 快速运行实验二示例

在仓库根目录执行：

```powershell
matlab -batch "run('examples/exp2/experiment2_run.m')"
python examples/exp2/build_exp2_report.py
```

生成的报告位于：

```text
examples/exp2/reports/2300810617李俊明_实验二_A4示例报告_修正版.docx
```

## 目录结构

```text
examples/exp2/
├─ experiment2_run.m          # MATLAB 实验二脚本
├─ build_exp2_report.py       # 生成 A4 Word 报告
├─ experiment2_output.txt     # MATLAB 运行输出示例
├─ figures/                   # MATLAB 直接保存的曲线图
├─ output_images/             # MATLAB 风格输出图
└─ reports/                   # 生成的 Word 报告

skills/matlab-lab-report/
└─ SKILL.md                   # 给 Codex / Claude Code 使用的 skill 草案
```

## 设计原则

- 报告必须是 A4 竖版，方便直接打印。
- 结果必须来自 MATLAB 真实运行，不手写伪造输出。
- 命令窗口结果默认使用 MATLAB 风格渲染图，必要时可额外补一张真实 MATLAB 窗口截图。
- 不把课程指导书、PPT、大量临时文件作为项目核心内容上传。

