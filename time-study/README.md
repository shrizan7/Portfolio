# Time Study

Tool #1 of a small "digital IE toolkit". It turns observed times into standard times the textbook way, and nothing more.

It's **one HTML file that works offline**: no install, no account, no internet, and no IT approval. Download `index.html` and double-click it to open it in Chrome or Edge.

All sample numbers are made up. Company data never goes in this repository.

## How to use it

1. **Settings:** study name, date, the time unit (seconds, minutes or hours), one **rating %**, one **allowance %**, and the accuracy (±5% usual, ±10% for long jobs). If the rating isn't 100, write why in Notes.
2. **Processes and times:** one row per process, with its **phase** and the **times you observed** (one Obs column per time you watched it). Average, Normal, Standard and "Enough?" fill in on their own.
   - Press Enter to move down a column.
   - Drag ⠿ to change the order. ＋ adds a row below.
   - Paste hundreds of rows from Excel: Phase · Process · time · time · …
3. **Totals:** standard time per phase and per unit, in your unit and in hours. **Download Excel** gives a workbook with two sheets, Standard times and Summary.

Save the study as a `.json` file to keep it or hand it on. Studies saved by the earlier, bigger version of this page still open: phases, processes, times, rating and allowance carry over.

## Formulas

| Result | Formula |
|---|---|
| Average | mean of the times entered |
| Normal | Average × Rating ÷ 100 |
| Standard | Normal × (1 + Allowance ÷ 100) |
| Times needed | (1.96 ÷ accuracy × √(n·Σx² − (Σx)²) ÷ Σx)², at 95% confidence |
| Enough? | Yes when the times entered ≥ times needed |
| Phase total | sum of the standard times in the phase |

The textbook allowance is 15% (personal 5 + fatigue 4 + delay 6). Use your plant's figure if it has one.

The earlier version, with models, quantities, crews, checkpoints and line balancing, is in this repository's history if it's ever needed again.
