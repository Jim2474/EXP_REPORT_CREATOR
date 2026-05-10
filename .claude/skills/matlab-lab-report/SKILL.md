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

## Compatibility Notes

- Keep scripts runnable from a normal shell so the workflow works in both Codex and Claude Code.
- Avoid Codex-only APIs in the core report pipeline.
- Use paths relative to the script location where possible.
- Do not upload course PDFs, PPTs, or unrelated temporary files unless the user explicitly asks.
