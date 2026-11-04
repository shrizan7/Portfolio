# Time Study & Line Balance

Tool #1 of a small "digital IE toolkit". You enter each **process**, its **station** and the **times you observed**, set a few **constants** (rating, allowances, accuracy), and it works out standard times the textbook way. It handles a line that builds **several models**, compares each station with takt time for every model, and can suggest a better split of work.

It handles both kinds of work:
- **Long processes**, such as a 12–14 hour padmount build with hundreds of processes and several models. Type or paste the times in minutes or hours.
- **Short cycles**, such as cable assembly. Use the built-in stopwatch, in seconds.

It works for both kinds of layout:
- **Flow line:** units move from station to station.
- **Fixed position:** units stay in a bay and each crew moves from unit to unit doing its own phase, with QA **checkpoints** between phases.

It's **one HTML file that works offline**: no install, no account, no internet, and no IT approval. Download `index.html` and double-click it to open it in Chrome or Edge.

All sample numbers and model names are made up. Company data never goes in this repository.

## Tabs

1. **Setup & models:**
   - study details and the "before" number (baseline)
   - **models and demand**, for example 6 / 4 / 2 units per week. The mix is worked out for you, and takt time uses the total of all models.
   - **how the line works**: flow line or fixed position, and whether work on a unit stops at a checkpoint until it's signed off (if you're not sure, choose "stops")
   - the constants used everywhere: time unit, default performance rating with its written reason and a Westinghouse calculator, PF&D allowances, and confidence and accuracy
2. **Processes & times:**
   - One row per process with its station, type, crew, **Qty per model** (0 = not used, 1 = once, 2 = twice), Every (only for occasional work, like a setup every 4 units) and "comes after".
   - Each Obs column is one unit you watched, with its serial number and model. If a process was done twice on that unit, type both times in one cell: `33; 41`.
   - Change the order by dragging a row by its ⠿ handle, or with ↑ ↓. Press ＋ on a row to add a new process right below it.
   - Paste hundreds of rows from Excel, filter by station, search, or use the stopwatch, which asks for a repeated process each time it happens.
3. **Standard times:**
   - labor and time per unit for each model, plus the weighted average across the mix
   - for each process: average → normal → standard per occurrence → weighted per unit → labor, grouped by station
   - **Preliminary** until a process has enough observations
   - **Same work?** when two models, or the 1st and 2nd time on a unit, look like different work
   - rating reasons, with a warning for any rating other than 100 that has no reason
4. **Stations & balance:**
   - a yamazumi chart you can switch between the weighted average and each model
   - a table of station time per model, with every model over takt shown in red
   - warnings when one model overloads a station, even if the average fits
   - **Suggest** re-splits the processes using ranked positional weight. Nothing changes until you accept it.
   - **Fixed position:** the tab becomes **Phases & balance**.
     - Each phase is one crew's work. Phase time = crew work ÷ people in the crew. A crew must finish its phase within one takt to move on to the next unit.
     - Type the real crew size for each phase. Until you do, it suggests the fewest people that fit takt.
     - The **Checkpoints** table shows the check time, the average wait for the inspector, rework found, and how much each checkpoint adds to the build time.
     - Results: **build time** from start to finish, **bays needed** (build time ÷ takt), and the inspector's load.
     - Suggest keeps every checkpoint where it is. Work is only moved between phases on the same side of a checkpoint.
5. **Delays:**
   - log interruptions (unit, station, reason, how long) separately, so standard times stay clean
   - two reasons used by checkpoints: "Waiting for inspection" and "Rework found at checkpoint". Put the checkpoint's name in the place box.
   - totals by reason and by station, for example "Waiting for parts: 66 min across 2 units"
6. **Files & links:**
   - save or open the study (.json)
   - download **one Excel workbook** with seven sheets: Summary, Models & mix, Standard times, Process × model, Observations, Stations per model (or **Phases & checkpoints** for a fixed-position layout) and Delays
   - you can edit the Observations sheet in Excel and paste it back
   - print a PDF report (offline file only), and send times to Layout Extruder flow-path stops

## Checkpoints

Add one process for each check, with Type **Checkpoint**, in the phase it checks. The check happens at the end of that phase. Its time is the inspector's, so it isn't counted in the crew's work or in the builders needed.

Studies saved before layouts existed open as a flow line. Studies saved before models existed open as a single model with every quantity set to 1. Nothing is lost.

## Formulas

| Result | Formula |
|---|---|
| Normal time | average × rating ÷ 100 |
| Standard time (per occurrence) | normal × (1 + allowance ÷ 100) |
| Time per unit for a model | standard × Qty for that model ÷ Every |
| Labor per unit | time per unit × crew |
| Mix | model demand ÷ total demand |
| Weighted per unit | Σ mix × model time per unit |
| Takt time | available time per day or week ÷ total units needed (all models) |
| Observations needed | (z ÷ accuracy × √(n·Σx² − (Σx)²) ÷ Σx)², z = 1.645 / 1.96 / 2.576 |
| Same work? | two models, or 1st vs 2nd time, differ by more than 15% and by more than twice the normal spread |
| Westinghouse rating | 100 × (1 + skill + effort + conditions + consistency) |
| Phase time (fixed position) | crew work per unit ÷ people in the crew, but never shorter than its longest single process |
| Build time (fixed position) | Σ phase times + Σ checkpoints (check + average wait, if work stops) + average rework |
| Bays needed | build time ÷ takt, rounded up |
| Inspector load | checkpoint work per unit ÷ takt |
| Minimum operators | weighted labor per unit ÷ takt, rounded up |
| Balance efficiency | total work ÷ (stations × slowest station) |

**Rating reasons.** Any rating other than 100 needs a written reason: on Setup for the default rating (the Westinghouse calculator fills in the factors for you), or, for a single process with its own rating, in the box that appears under its name on the Standard times tab. The page warns until every non-100 rating has one, and the reasons go into the Excel workbook.

The default allowances are personal 5%, fatigue 4%, delay 6% and other 0%. Replace them with your plant's rule. Machine-paced processes get no rating and no allowance unless you set them.

## Pasting from Excel

Without a header row, columns are read as **Station · Process · Obs 1 · Obs 2 …**

With a header row, these columns are recognised:
- Station (or Phase), Process (or Step, Operation, Task), Type, Crew, Every and Comes after
- Own rating %, Rating reason and Own allowance %
- Type: "Checkpoint", "Inspection", "QC" or "Sign-off" become checkpoints
- **Qty** followed by a model name, for example `Qty Model C`

Any other column is an observation. Put its model in square brackets after the serial number, for example `105 [Model C]`. A model that doesn't exist yet is added.

Times can be decimals in the chosen unit, or `h:mm:ss`. Two times in one cell (`33; 41`) mean the process was done twice on that unit. A `*` after a time means "leave this one out".
