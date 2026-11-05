"""Reconcile all saved native cleaned cells and EDA aggregates to raw CSVs."""
import collections,csv,hashlib,json,math
from pathlib import Path
from prepare_excel_eda import clean
ROOT=Path(__file__).resolve().parents[2];OUT=ROOT/'_analyst_workspace/outputs/excel_cleaning_eda'
def read(path):
    with path.open(encoding='utf-8-sig',newline='') as stream:return list(csv.DictReader(stream))
def equal(actual,expected):
    if expected is None:return actual==''
    if isinstance(expected,bool):return actual.lower()==str(expected).lower()
    if isinstance(expected,(float,int)):
        try:return math.isclose(float(actual),expected,rel_tol=1e-11,abs_tol=1e-9)
        except ValueError:return False
    return actual==expected
def main():
    contract=json.loads((OUT/'contract.json').read_text(encoding='utf-8'));expected=json.loads((OUT/'expected.json').read_text(encoding='utf-8'));eda=json.loads((OUT/'native_eda.json').read_text(encoding='utf-8'));assert eda['Passed'],'Native EDA incomplete'
    errors=[];checks=0;cells=0;counts={};raw={};groups={};sources={s['Table']:s for s in contract['Sources']}
    def check(name,condition,detail=None):
        nonlocal checks
        checks+=1
        if not condition:
            errors.append(dict(Check=name,Detail=detail))
            if len(errors)>=12:raise AssertionError('Multiple native reconciliation failures; inspect verification.json')
    for source in contract['Sources']:
        path=Path(contract['SourceFolder'])/source['File'];check('Original hash '+source['Table'],hashlib.sha256(path.read_bytes()).hexdigest()==source['Sha256'])
        raw[source['Table']]=read(path);groups[source['Table']]=collections.defaultdict(list)
        for row in raw[source['Table']]:groups[source['Table']][row[source['PrimaryKey']].strip()].append(row)
    def parent(table,key):return groups[table].get(key.strip(),[])
    try:
        for source in contract['Sources']:
            name=source['Table'];native=read(ROOT/'Data Source/In Progress/Cleaned'/source['File']);counts[name]=len(native)
            check('Every source row preserved: '+name,len(native)==len(raw[name]))
            for ordinal,(original,row) in enumerate(zip(raw[name],native),1):
                wanted={};issues=[]
                for field in source['Fields']:
                    value,status=clean(original[field['Name']],field);wanted[field['Name']]=value
                    if status!='Valid':issues.append(field['Name']+': '+status)
                wanted.update(_source_row=ordinal,_key_status='Repeated declared key' if len(parent(name,original[source['PrimaryKey']]))>1 else 'Unique declared key',_issue_count=len(issues),_issues='; '.join(issues))
                if name=='fact_health_performance':
                    ns=[len(parent(t,original[k])) for t,k in [('dim_country','country_id'),('dim_date','date_id'),('dim_health_system','system_id'),('dim_workforce','workforce_id')]]
                    system=parent('dim_health_system',original['system_id']);workforce=parent('dim_workforce',original['workforce_id'])
                    wanted['_join_status']='Missing parent' if 0 in ns else 'Ambiguous parent' if any(n>1 for n in ns) else 'Single parents'
                    wanted['_attribution_status']='Not testable' if len(system)!=1 or len(workforce)!=1 else 'Conflict' if system[0]['country_id'].strip()!=original['country_id'].strip() or workforce[0]['system_id'].strip()!=original['system_id'].strip() else 'Agrees'
                elif name=='dim_country':
                    prefixes=[original[c].strip().split(' -> ')[0].lower() for c in ['region','income_group'] if ' -> ' in original[c].strip()]
                    wanted['_attribute_status']='Conflicting supplied attributes' if any(p!=original['country_name'].strip().lower() for p in prefixes) else 'No prefix conflict detected'
                check('Exact prepared schema '+name, set(row)==set(wanted)) if ordinal==1 else None
                for field,value in wanted.items():
                    cells+=1
                    if not equal(row.get(field,''),value):check('Cleaned cell '+name+':'+str(ordinal)+':'+field,False,dict(Actual=row.get(field),Expected=value))
            check('Every cell reconciled: '+name,True)
        profile=read(OUT/'native_tables/ColumnProfiles.csv');by_field={(r['Source'],r['Field']):r for r in profile}
        check('Every field profiled',len(profile)==len(expected['Profiles'])==65)
        for e in expected['Profiles']:
            r=by_field[e['Source'],e['Field']]
            for field,value in e.items():check('Profile '+e['Source']+'.'+e['Field']+':'+field,equal(r.get(field,''),value),dict(Actual=r.get(field),Expected=value) if not equal(r.get(field,''),value) else None)
            check('Profile accounting '+e['Source']+'.'+e['Field'],sum(int(float(r[k])) for k in ['Valid','Missing','Invalid','Review'])==int(float(r['Records'])))
        hist=read(OUT/'native_tables/Summary_Histograms.csv');actual={(r['Metric'],float(r['BinStart'])):int(float(r['Records'])) for r in hist};wanted={(r['Metric'],r['BinStart']):r['Records'] for r in expected['Histograms']}
        check('Every native histogram bin reconciles',actual==wanted)
        check('Histogram labels reconcile', {(r['Metric'],float(r['BinStart'])):r['Bin'] for r in hist}=={(r['Metric'],r['BinStart']):r['Bin'] for r in expected['Histograms']})
        actual_validity={(r['Source'],r['Metric'],r['Status']):int(float(r['Records'])) for r in read(OUT/'native_tables/Summary_Validity.csv')}
        wanted_validity={(r['Source'],r['Metric'],status):r[status] for r in expected['Profiles'] for status in ['Valid','Missing','Invalid','Review'] if r['Kind'] in ['number','integer']}
        check('All eligibility chart populations reconcile',actual_validity==wanted_validity)
        for filename,key,exp in [('Summary_KeyGroups.csv','Source',expected['KeyGroups'])]:
            rows=read(OUT/'native_tables'/filename);actual={(r[key],r['Group']):int(float(r['Records'])) for r in rows}
            check('Declared key group counts',all(actual.get((r[key],r['Group']),0)==r['Records'] for r in exp) and sum(actual.values())==40524)
        for dataset,exp in [('JoinGroups',expected['JoinGroups']),('AttributionGroups',expected['AttributionGroups'])]:
            actual={r['Group']:int(float(r['Records'])) for r in read(OUT/'native_tables'/('Summary_'+dataset+'.csv'))};check(dataset+' counts',actual==exp)
        pairs={r['Pair']:r for r in read(OUT/'native_tables/PairStatistics.csv')}
        for e in expected['Pairs']:
            for field,value in e.items():check('Pair '+e['Pair']+':'+field,equal(pairs[e['Pair']].get(field,''),value))
        chart_rows=read(OUT/'native_tables/Summary_CorrelationChartData.csv');check('Low-N correlations omitted from charts',len(chart_rows)==sum(r['Correlation'] is not None for r in expected['Pairs']))
        native_systems={r['SystemType']:int(float(r['Records'])) for r in read(OUT/'native_tables/Summary_SystemTypes.csv')};wanted_systems=dict(collections.Counter(r['system_type'].strip() for r in raw['dim_health_system']));check('System-type records reconciled',native_systems==wanted_systems)
        check('Seven native charts verified',len(eda['Charts'])==7 and all(c['Passed'] for c in eda['Checks']))
    finally:
        receipt=dict(Passed=not errors,Checks=checks,CleanedCellsCompared=cells,SourceRows=counts,Errors=errors,Method='All saved native cleaned cells and flags compared to unchanged raw CSVs; independently recomputed profiles, bins, groups and pairwise correlations. Native chart/filter/reopen checks recorded separately.',ClinicalValidity='Not established by this reconciliation')
        (OUT/'verification.json').write_text(json.dumps(receipt,indent=2,ensure_ascii=False),encoding='utf-8')
    print(json.dumps(receipt))
    if errors:raise SystemExit(1)
if __name__=='__main__':main()
