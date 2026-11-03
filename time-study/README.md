# Time Study & Line Balance

Tool #1 of a small "digital IE toolkit". It turns stopwatch readings into standard times, compares them with takt time, and splits the work across stations.

It's **one HTML file that works offline**: no install, no account, no internet, and no IT approval. Download `index.html` and double-click it to open it in Chrome or Edge, on a laptop, tablet or phone.

All numbers in the built-in sample are made up. Company data never goes in this repository.

## What it does

1. **Setup**: list the steps of one cycle, set demand (to get takt time) and allowances, and write down your "before" number.
2. **Time it**: a big **Next** button for continuous stopwatch timing. It also has Skip (for steps that don't happen every cycle), Flag interruption, and Undo. On phones and tablets that allow it, the screen stays on while you time. On a laptop, Space works as Next.
3. **Standard times**: average → normal time (× rating) → standard time (× allowances), per unit. It also shows how many more readings you need for ±5% accuracy at 95% confidence, and highlights unusual readings so you can leave them out.
4. **Balance**: auto-balances the steps into stations using the ranked positional weight method, keeping the "comes after" order. It shows a yamazumi chart against takt, the bottleneck, units per day, and balance efficiency. You can also move steps between stations by hand.
5. **Files & links**: save or open the study (.json), download spreadsheets (.csv), print a PDF report, and **send times to Layout Extruder**. That last one fills the waits at each flow-path stop with the measured station or step times.

## Formulas

| Result | Formula |
|---|---|
| Normal time | average × rating ÷ 100 |
| Standard time | normal × (1 + allowance ÷ 100) |
| Per unit | standard ÷ "once every N units" |
| Takt time | available seconds per day ÷ units needed per day |
| Readings needed (95%, ±5%) | (40 × √(n·Σx² − (Σx)²) ÷ Σx)² |
| Minimum stations | total per-unit standard ÷ takt, rounded up |
| Balance efficiency | total work ÷ (stations × slowest station) |

The default allowances are personal 5%, fatigue 4% and delay 6%, for 15% in total. Replace them with your plant's rule. Machine-paced steps get no rating and no allowance unless you set them.
