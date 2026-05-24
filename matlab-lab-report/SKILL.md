---
name: matlab-lab-report
description: Generate printable A4 Word lab reports for MATLAB control-system experiments by running real MATLAB scripts, rendering MATLAB-style output images, saving MATLAB figures, and assembling a complete .docx report. Use when the user asks to create an experiment report, run MATLAB exercises, avoid manual screenshots, or produce reports compatible with Codex and Claude Code workflows.
---

# MATLAB Lab Report

Use this skill to generate a complete MATLAB experiment report from an experiment guide and `.m` code.

## Source-of-Truth Rules

- The experiment guide/reference book is the only authoritative source for exercise requirements.
- PPT files, lecture slides, prior reports, and generated examples are auxiliary references only. Use them to understand commands or formatting, but never let them override the guide/reference book.
- Before writing MATLAB code or report text, create an exercise verification checklist with:
  - exercise number
  - exact formula or task statement
  - required output
  - source file and page number, when available
- If a formula is unclear because PDF extraction is messy, inspect the rendered page image or ask the user to confirm instead of guessing.
- If an exercise is procedural, such as "read this function and write a main program to call it", do not invent a new independent problem. Label it as a function-call or verification exercise.
- Do not silently substitute a similar example from PPT or another experiment.

## Workflow

1. Read the experiment guide/reference book and identify exercise numbers, formulas, and required outputs.
2. Produce an exercise verification checklist and keep it aligned with the report/code.
3. Use PPT or slides only to clarify MATLAB commands or plotting style.
4. Create or update a MATLAB script that runs every required exercise from the checklist.
5. Run MATLAB in batch mode, for example:

   ```powershell
   matlab -batch "run('examples/exp2/experiment2_run.m')"
   ```

6. Save command-window output with `diary(...)`.
7. Save MATLAB plot figures with `saveas(...)` or `exportgraphics(...)`.
8. Render command-window output into MATLAB-style white-background images.
9. Build an A4 portrait `.docx` report with:
   - experiment title
   - student information
   - purpose
   - environment
   - experiment content
   - result images labeled by exercise number
   - result analysis
   - summary

## Report Rules

- Always use A4 portrait pages unless the user explicitly asks otherwise.
- Prefer 2 x 2 image tables for result pages so the report remains printable.
- Label every result image with the exercise number and a short description.
- Report exercise labels must match the verification checklist.
- Use MATLAB-generated plot images for curves.
- Use rendered MATLAB-style output images for command-window results.
- If the user worries about authenticity, add one real MATLAB window screenshot as supplemental evidence, but keep the main report using readable rendered images.

## Anti-AI-Writing Rules (CRITICAL)

Lab reports must read like a student wrote them, not like an AI generated them. Follow these rules strictly:

### Banned Phrases

Never include these or similar AI-sounding meta-descriptions:
- "以下结果由MATLAB批处理实际运行得到"
- "命令行类结果采用MATLAB命令窗口风格渲染"
- "曲线图由MATLAB直接保存"
- "本文档由AI自动生成"
- "使用ChatGPT/Claude等工具辅助完成"
- Any sentence describing how the report was produced rather than what the experiment found

### Writing Style

- Write in first person ("本次实验"、"我观察到")，不要用被动语态堆砌
- 句式要有变化，避免"通过...掌握了...加深了..."的模板句式
- 分析部分要结合具体数值，不要只说"结果显示系统稳定"
- 不要用"首先...其次...最后..."的三段式结构
- 每段分析要有具体的参数值、频率值、增益值等数据支撑

### Content Density Requirements

**实验目的：** 写明具体要掌握的函数名、分析方法名称、要观察的物理量。不要只写"了解频域分析"。

**实验内容：** 每个练习写明：
- 具体的传递函数表达式
- 使用的MATLAB命令
- 要观察的具体内容（如"观察低频段幅频特性斜率"、"判断曲线是否包围(-1,j0)点"）

**实验结果与分析：** 这是最重要部分，必须包含：
- 从diary输出中提取的具体数值（幅值裕度、相角裕度、截止频率、超调量等）
- 对数值的物理解释（如"相角裕度25.39°，数值较小说明稳定程度不高"）
- 理论与实验结果的对应关系（如"低频段-20dB/dec斜率对应积分环节"）
- 不同练习结果之间的联系（如"根轨迹分析预测的不稳定增益与阶跃响应数据一致"）

**实验总结：** 总结各方法的特点和适用场景，不要只说"掌握了XXX"。

### Data Extraction Pattern

从MATLAB diary输出中提取关键数据并写入报告：

```
幅值裕度 Gm = X.XX (即 Y.YY dB)
相角裕度 Pm = XX.XX°
相角交接频率 wg = X.XXX rad/s
截止频率 wp = X.XXX rad/s
闭环极点: s1 = -X.XXX, s2,3 = -X.XXX ± X.XXXj
超调量 σ = XX.XX%
上升时间 tr = X.XX s
调整时间 ts = X.XX s
峰值时间 tp = X.XX s
```

## Compatibility Notes

- Keep scripts runnable from a normal shell so the workflow works in both Codex and Claude Code.
- Avoid Codex-only APIs in the core report pipeline.
- Use paths relative to the script location where possible.
- Do not upload course PDFs, PPTs, or unrelated temporary files unless the user explicitly asks.
