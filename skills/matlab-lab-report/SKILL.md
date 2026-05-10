---
name: matlab-lab-report
description: Generate printable A4 Word lab reports for MATLAB control-system experiments by running real MATLAB scripts, rendering MATLAB-style output images, saving MATLAB figures, and assembling a complete .docx report. Use when the user asks to create an experiment report, run MATLAB exercises, avoid manual screenshots, or produce reports compatible with Codex and Claude Code workflows.
---

# MATLAB Lab Report

Use this skill to generate a complete MATLAB experiment report from an experiment guide and `.m` code.

## Workflow

1. Read the experiment guide and identify exercise numbers, formulas, and required outputs.
2. Create or update a MATLAB script that runs every exercise.
3. Run MATLAB in batch mode, for example:

   ```powershell
   matlab -batch "run('examples/exp2/experiment2_run.m')"
   ```

4. Save command-window output with `diary(...)`.
5. Save MATLAB plot figures with `saveas(...)` or `exportgraphics(...)`.
6. Render command-window output into MATLAB-style white-background images.
7. Build an A4 portrait `.docx` report with:
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
- Use MATLAB-generated plot images for curves.
- Use rendered MATLAB-style output images for command-window results.
- If the user worries about authenticity, add one real MATLAB window screenshot as supplemental evidence, but keep the main report using readable rendered images.

## Compatibility Notes

- Keep scripts runnable from a normal shell so the workflow works in both Codex and Claude Code.
- Avoid Codex-only APIs in the core report pipeline.
- Use paths relative to the script location where possible.
- Do not upload course PDFs, PPTs, or unrelated temporary files unless the user explicitly asks.

