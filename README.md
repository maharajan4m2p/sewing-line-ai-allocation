# Sewing Line AI Operator Allocation — Serial Number Edition

## Features
- Upload only the daily punching file (.xlsx, .xls, .csv, .ods).
- Master employee/skill/efficiency files are bundled; no Supabase required.
- Uses `02_Line_Machine_Details.xlsx` → `Machine Register` as the source of physical machine slots.
- One employee per machine slot and no employee duplication across selected lines.
- Outputs employee name, ID, efficiency, machine serial number, line, operation, and qualification verification status.
- Shows separate line tabs and CSV/Excel downloads.
- Provisional assignments are visibly flagged when skill records or approved machine-to-skill mappings are not verified. A supervisor must verify them before production use.

## Run locally
```bash
pip install -r requirements.txt
streamlit run app.py
```

## Deploy on Render
1. Upload/replace the project files in the GitHub repository root.
2. Keep the Excel master files in the repository root.
3. Commit the changes.
4. In Render, deploy the latest commit.

## Important
- The `Machine Register` sheet has one row per machine slot from the line-count master. If the supplied inventory has no serial number for a slot, it says `Not recorded in machine inventory`; do not treat this as a real serial number.
- The `Machine Skill Mapping` sheet is a template. Add only factory-approved skill-operation mappings.
- The app may assign provisional employees to reduce unfilled slots, but provisional assignment is not proof of qualification. Verify before the operator runs the machine.


## Employee details and name matching
- Employee IDs are normalized before matching (for example, `U2-0024` and `U20024` are treated as the same ID).
- Employee names are sourced in this order: employee master, efficiency file, skill file, then daily punching data.
- Efficiency is shown as blank when no matching efficiency record exists; it is not falsely shown as 0%.
- If a name is absent from all supplied sources, the report explicitly says `Name not found in master data` instead of pretending the employee ID is a name.
- Department and employment status come from the employee master; designation can fall back to the efficiency file.

## Upload handling fix
- The daily upload is snapshotted as bytes in Streamlit session state, so widget reruns do not lose the selected workbook or depend on a file cursor position.
- Excel `.xlsx` uploads are read explicitly with `openpyxl`; `.xls` uploads use `xlrd`; CSV uploads retry with Latin-1 if UTF-8 decoding fails.
- Upload parsing errors are shown in the page with the filename and exception instead of silently appearing as if no file was uploaded.
- `render.yaml` supplies a Render web-service start command using Render's `$PORT`.


## Run the corrected local version (Windows)
1. Extract the complete ZIP into a new folder.
2. Open that folder and double-click `RUN_LOCAL.bat`.
3. The browser should open at `http://localhost:8501`.
4. Confirm the page shows `Build: upload-fix-v2`. If it does not, stop the old Streamlit terminal (Ctrl+C) and launch `RUN_LOCAL.bat` from this folder.
5. Upload the daily punching workbook. The page should show `Punching file loaded`, a punch-date selector, and the `APPLY & ANALYSE SELECTED LINES` button.

Do not launch `app.py` from an older extracted folder or an old VS Code terminal.
