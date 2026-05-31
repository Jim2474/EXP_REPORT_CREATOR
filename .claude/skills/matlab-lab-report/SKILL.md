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

## SIMULINK Workflow (for experiments using SIMULINK)

For experiments that require SIMULINK, use MATLAB command-line API to programmatically create and run SIMULINK models:

### Key Commands
- `new_system(name)` — Create a new SIMULINK model
- `add_block('lib/path', 'model/name', 'Position', [...])` — Add block with position
- `add_line(model, 'src/1', 'dst/1', 'autorouting', 'on')` — Connect blocks with auto-routing
- `set_param('model/block', 'Param', 'Value')` — Set block parameters
- `sim(model)` — Run simulation
- `save_system(model, path)` — Save as .slx file

### Block Libraries
| Block | Library Path |
|-------|--------------|
| Step | `simulink/Sources/Step` |
| Transfer Fcn | `simulink/Continuous/Transfer Fcn` |
| Mux | `simulink/Signal Routing/Mux` |
| Scope | `simulink/Sinks/Scope` |
| To Workspace | `simulink/Sinks/To Workspace` |

### Layout Best Practices
- Use `Position` parameter `[x1, y1, x2, y2]` to place blocks整齐
- Use `'autorouting', 'on'` in `add_line` for clean wire routing
- Space blocks 150-200px apart horizontally
- Space parallel blocks 80-100px apart vertically

### Example: Creating a SIMULINK Model
```matlab
modelName = 'my_model';
new_system(modelName);

% Add blocks with positions
add_block('simulink/Sources/Step', [modelName '/Step'], ...
    'Position', [50, 150, 150, 190]);
add_block('simulink/Continuous/Transfer Fcn', [modelName '/G'], ...
    'Position', [300, 150, 450, 190]);
set_param([modelName '/G'], 'Numerator', '[1]', 'Denominator', '[1 2 1]');

% Connect with auto-routing
add_line(modelName, 'Step/1', 'G/1', 'autorouting', 'on');

% Run and save
simOut = sim(modelName);
save_system(modelName, fullfile(outDir, [modelName '.slx']));
close_system(modelName, 0);
```

## Report Rules

- Always use A4 portrait pages unless the user explicitly asks otherwise.
- Prefer 2 x 2 image tables for result pages so the report remains printable.
- Label every result image with the exercise number and a short description.
- Report exercise labels must match the verification checklist.
- Use MATLAB-generated plot images for curves.
- Use rendered MATLAB-style output images for command-window results.
- If the user worries about authenticity, add one real MATLAB window screenshot as supplemental evidence, but keep the main report using readable rendered images.
- **NEVER** add sentences like "以下结果由MATLAB批处理实际运行得到" or any meta-comment about how results were generated. The report should read as if the student wrote it directly — no AI-generated boilerplate, no explanations of the toolchain.
- Write in a natural student voice. Avoid generic filler sentences. Each paragraph should contain specific data, observations, or reasoning.

## Compatibility Notes

- Keep scripts runnable from a normal shell so the workflow works in both Codex and Claude Code.
- Avoid Codex-only APIs in the core report pipeline.
- Use paths relative to the script location where possible.
- Do not upload course PDFs, PPTs, or unrelated temporary files unless the user explicitly asks.
