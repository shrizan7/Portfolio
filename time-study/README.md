# Time Study & Line Balance

Tool #1 of a small "digital IE toolkit". You enter each **process**, its **station** and the **times you observed**, set a few **constants** (rating, allowances, accuracy), and it works out standard times the textbook way. It then compares each station with takt time and can suggest a better split of work.

It handles both kinds of work:
- **Long processes**, such as a 12–14 hour padmount build with hundreds of processes. Type or paste the times in minutes or hours.
- **Short cycles**, such as cable assembly. Use the built-in stopwatch, in seconds.

It's **one HTML file that works offline**: no install, no account, no internet, and no IT approval. Download `index.html` and double-click it to open it in Chrome or Edge.

All sample numbers are made up. Company data never goes in this repository.

## Tabs

1. **Setup & constants:** study details and the "before" number (baseline). Also the constants used everywhere:
   - time unit (seconds, minutes or hours)
   - default performance rating, with a Westinghouse calculator
   - PF&D allowances
   - confidence and accuracy
   - demand, which gives takt time
2. **Processes & times:** one row per process with its station, type, crew size, "comes after" and observations. Each Obs column is one unit you watched, labelled with its serial number. You can paste hundreds of rows straight from Excel, filter by station, and search. There's also an optional stopwatch for short processes.
3. **Standard times:** average → normal → standard → per unit → labor, grouped by station with subtotals. It flags unusual observations (tap one to leave it out) and says how many observations each process still needs.
4. **Stations & balance:** a yamazumi chart against takt, a station summary, and warnings when a station is over takt. **Suggest** re-splits the processes using ranked positional weight. Nothing changes until you accept it.
5. **Files & links:** save or open the study (.json), and download **one Excel workbook (.xlsx)** with four sheets: Summary, Standard times, Observations and Stations. You can edit the Observations sheet in Excel and paste it back. Single .csv files are still there if you want them. You can also print a PDF report from the offline file and send times to Layout Extruder flow-path stops.

## Formulas

| Result | Formula |
|---|---|
| Normal time | average × rating ÷ 100 |
| Standard time | normal × (1 + allowance ÷ 100) |
| Per unit | standard ÷ "once every N units" |
| Labor per unit | per unit × crew |
| Takt time | available time per day or week ÷ units needed |
| Observations needed | (z ÷ accuracy × √(n·Σx² − (Σx)²) ÷ Σx)², z = 1.645 / 1.96 / 2.576 |
| Westinghouse rating | 100 × (1 + skill + effort + conditions + consistency) |
| Minimum operators | total labor per unit ÷ takt, rounded up |
| Balance efficiency | total work ÷ (stations × slowest station) |

**Rating reasons.** Any rating other than 100 needs a written reason: on Setup for the default rating (the Westinghouse calculator fills in the factors for you), or in the Rating reason column for a single process. The page warns until every non-100 rating has one, and the reasons go into the Excel workbook.

The default allowances are personal 5%, fatigue 4%, delay 6% and other 0%. Replace them with your plant's rule. Machine-paced processes get no rating and no allowance unless you set them.

## Pasting from Excel

Without a header row, columns are read as **Station · Process · Obs 1 · Obs 2 …**

With a header row, these columns are recognised: Station, Process (or Step, Operation, Task), Type, Crew, Every, Comes after. Any other column is an observation, and its header becomes the label, for example a serial number.

Times can be decimals in the chosen unit, or `h:mm:ss`. A `*` after a time means "leave this one out".
