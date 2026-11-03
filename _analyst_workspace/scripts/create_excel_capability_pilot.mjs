import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { Workbook, SpreadsheetFile } from '@oai/artifact-tool';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..');
const out = path.join(root, '_analyst_workspace/outputs/capability/excel');
const destination = path.join(out, 'native_excel_capability.xlsx');
try { await fs.access(destination); throw new Error('Pilot already exists; preserve native features and inspect before editing.'); }
catch (error) { if (error.code !== 'ENOENT') throw error; }
await fs.mkdir(out, { recursive: true });
const baseline = JSON.parse(await fs.readFile(path.join(root, '_analyst_workspace/outputs/initial_review/evidence_report.json'), 'utf8'));
const domain = (table, column) => baseline.domain_checks.find(d=>d.table===table && d.column===column);
const rows = [['Family', 'Rule', 'Failed', 'Tested']];
rows.push(['Identity', 'Performance records sharing a key', 40000, 40000]);
for (const [table, field, family, label] of [
  ['dim_date','year','Calendar','Calendar year domain'],
  ['dim_date','quarter','Calendar','Quarter domain'],
  ['dim_date','year_quarter_label','Calendar','Year-quarter label domain'],
  ['fact_health_performance','ae_4hr_target_pct','Domain','A&E four-hour percentage domain'],
  ['dim_workforce','vacancy_rate_pct','Domain','Vacancy percentage domain'],
  ['dim_workforce','burnout_index_score','Domain','Burnout score domain'],
]) { const d = domain(table, field); if(!d) throw new Error('Missing baseline rule'); rows.push([family,label,d.failed,d.tested_nonmissing]); }
const wb = Workbook.create();
const sheet = wb.worksheets.add('Pilot Data');
sheet.showGridLines = false;
sheet.getRange(`A1:D${rows.length}`).values = rows;
sheet.getRange(`A1:D${rows.length}`).format.font = { name:'Arial', size:11, color:'#172B4D' };
sheet.getRange('A1:D1').format = { fill:'#172B4D', font:{name:'Arial',size:11,bold:true,color:'#FFFFFF'},rowHeight:25 };
sheet.getRange('A:A').format.columnWidth = 15;
sheet.getRange('B:B').format.columnWidth = 45;
sheet.getRange('C:D').format.columnWidth = 14;
sheet.getRange(`C2:D${rows.length}`).setNumberFormat('#,##0');
sheet.getRange(`A2:D${rows.length}`).format.rowHeight = 23;
sheet.tables.add(`A1:D${rows.length}`,true,'PilotRules');
sheet.freezePanes.freezeRows(1);
sheet.getRange('F1').values=[['Source: existing full-file review; this is a capability fixture, not final EDA.']];
sheet.getRange('F1').format.font={name:'Arial',size:10,color:'#425466'};
sheet.getRange('F:F').format.columnWidth=85;
wb.recalculate();
const inspect=await wb.inspect({kind:'table',range:`'Pilot Data'!A1:D${rows.length}`,include:'values,formulas',tableMaxRows:10,tableMaxCols:4,maxChars:2500});
await fs.writeFile(path.join(out,'base_inspection.ndjson'),inspect.ndjson);
const preview=await wb.render({sheetName:'Pilot Data',range:'A1:D8',scale:1,format:'png'});
await fs.writeFile(path.join(out,'base_preview.png'),new Uint8Array(await preview.arrayBuffer()));
const xlsx=await SpreadsheetFile.exportXlsx(wb); await xlsx.save(destination);
console.log(JSON.stringify({destination,rows:rows.length-1,table:'PilotRules',native_queries_pivots_and_charts:'Not yet created or verified'}));
