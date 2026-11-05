"""Small source contract and independent expectations for native Excel cleaning/EDA."""
import collections,csv,hashlib,json,math,re,statistics
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
OUT=ROOT/'_analyst_workspace/outputs/excel_cleaning_eda'
PACKAGE=ROOT/'DataDNA Dataset Challenge - 2026- 11 - Health System Performance'
PERCENT=set('vacancy_rate_pct international_recruit_pct ae_4hr_target_pct hospital_mortality_rate_pct readmission_rate_30d_pct surgical_success_rate_pct cardiovascular_prevalence_pct diabetes_prevalence_pct respiratory_prevalence_pct primary_care_spend_pct secondary_care_spend_pct tertiary_care_spend_pct'.split())
UNITS={'population_millions':'million people','number_of_hospitals':'hospitals','doctors_per_1000_pop':'per 1,000 people','nurses_per_1000_pop':'per 1,000 people','burnout_index_score':'score 0–100','avg_weekly_hours_worked':'hours/week','staff_satisfaction_score':'score 1–10','training_spend_per_staff_usd':'USD/staff','total_beds_per_1000':'beds/1,000 people','ae_avg_wait_minutes':'minutes','elective_wait_weeks':'weeks','mortality_rate_per_1000':'per 1,000 people','avg_length_of_stay_days':'days','bed_turnover_rate':'turnovers/year','diagnostic_turnaround_days':'days','cancer_incidence_per_100k':'per 100,000 people','health_spend_per_capita_usd':'USD/person','health_spend_pct_gdp':'% GDP; meaning unconfirmed','covid_excess_mortality_per_100k':'per 100,000 people','pandemic_icu_surge_pct':'% change; base unconfirmed','icu_occupancy_rate_pct':'% stated capacity'}
LABELS={'ae_avg_wait_minutes':'A&E average wait','elective_wait_weeks':'Elective waiting time','health_spend_per_capita_usd':'Health spending per person','vacancy_rate_pct':'Workforce vacancy','burnout_index_score':'Workforce burnout','hospital_mortality_rate_pct':'Hospital mortality','ae_4hr_target_pct':'A&E 4-hour target','icu_occupancy_rate_pct':'ICU occupancy','readmission_rate_30d_pct':'30-day readmissions','staff_satisfaction_score':'Staff satisfaction'}
HIST={'ae_avg_wait_minutes':50,'elective_wait_weeks':50,'health_spend_per_capita_usd':50,'vacancy_rate_pct':10,'burnout_index_score':10,'hospital_mortality_rate_pct':10,'icu_occupancy_rate_pct':10}
PAIRS=[('fact_health_performance','health_spend_per_capita_usd','ae_avg_wait_minutes','Spending vs A&E wait'),('fact_health_performance','health_spend_per_capita_usd','elective_wait_weeks','Spending vs elective wait'),('fact_health_performance','icu_occupancy_rate_pct','ae_4hr_target_pct','ICU occupancy vs A&E target'),('fact_health_performance','hospital_mortality_rate_pct','readmission_rate_30d_pct','Mortality vs readmissions'),('dim_workforce','vacancy_rate_pct','burnout_index_score','Vacancy vs burnout'),('dim_workforce','burnout_index_score','staff_satisfaction_score','Burnout vs staff satisfaction')]
def number(value):
    try:
        if ',' in value and not re.fullmatch(r'[+-]?\d{1,3}(,\d{3})*(\.\d+)?',value.strip()):return None
        n=float(value.strip().replace(',',''));return n if math.isfinite(n) else None
    except (ValueError,TypeError):return None
def clean(value,field):
    text=value.strip();kind=field['Kind']
    if text.lower() in ('','null','none','nan','n/a','na'):return None,'Missing'
    if kind=='identifier':return (text,'Valid') if re.fullmatch(r'-?\d+',text) else (text,'Invalid identifier')
    if kind=='boolean':return (text.lower()=='true','Valid') if text.lower() in ('true','false') else (None,'Invalid boolean')
    if kind=='year':return (int(text),'Valid') if re.fullmatch(r'\d{4}',text) and 2018<=int(text)<=2024 else (None,'Invalid calendar')
    if kind=='quarter':return (int(text),'Valid') if text in ('1','2','3','4') else (None,'Invalid calendar')
    if kind=='quarter_label':return (text,'Valid') if re.fullmatch(r'(201[89]|202[0-4])-Q[1-4]',text) else (None,'Invalid calendar')
    if kind=='iso3':return (text.upper(),'Valid') if re.fullmatch(r'[A-Za-z]{3}',text) else (None,'Invalid code format')
    if kind in ('integer','number'):
        n=number(text)
        if n is None or (kind=='integer' and not n.is_integer()):return None,'Invalid number'
        if field['Minimum'] is not None and n<field['Minimum'] or field['Maximum'] is not None and n>field['Maximum']:return None,'Outside domain'
        if field['ReviewMaximum'] is not None and n>field['ReviewMaximum']:return None,'Review capacity definition'
        return int(n) if kind=='integer' else n,'Valid'
    return text,'Valid'
def quantile(values,p):
    if not values:return None
    ordered=sorted(values);index=(len(ordered)-1)*p;lo=math.floor(index);hi=math.ceil(index)
    return ordered[lo]+(index-lo)*(ordered[hi]-ordered[lo])
def main():
    OUT.mkdir(parents=True,exist_ok=True)
    schema=json.loads((PACKAGE/'docs/SCHEMA_BLUEPRINT.json').read_text(encoding='utf-8'))['tables'];sources=[];data={};profiles=[];hist=[]
    for table,definition in schema.items():
        path=ROOT/'Data Source/Original'/f'{table}.csv';given=PACKAGE/'data-copy'/path.name
        if hashlib.sha256(path.read_bytes()).digest()!=hashlib.sha256(given.read_bytes()).digest():raise ValueError('Canonical input differs from the specified organizer file: '+table)
        with path.open(encoding='utf-8-sig',newline='') as stream:reader=csv.DictReader(stream);columns=reader.fieldnames;rows=list(reader)
        fields=[]
        for name,c in definition['columns'].items():
            kind='identifier' if name.endswith('_id') else 'boolean' if c['data_type']=='boolean' else 'integer' if c['data_type']=='integer' else 'number' if c['data_type'] in ('float','decimal','number') else 'text'
            kind={'year':'year','quarter':'quarter','year_quarter_label':'quarter_label','country_code_iso3':'iso3'}.get(name,kind)
            minimum=0 if kind in ('integer','number') and name not in ('covid_excess_mortality_per_100k','pandemic_icu_surge_pct') else None;maximum=None;review=None
            if name in PERCENT or name=='burnout_index_score':minimum=0;maximum=100
            if name=='staff_satisfaction_score':minimum=1;maximum=10
            if name=='avg_weekly_hours_worked':minimum=0;maximum=168
            if name=='icu_occupancy_rate_pct':review=100
            unit='%' if name in PERCENT else UNITS.get(name,'')
            label=LABELS.get(name,name.replace('_',' ').capitalize())+(' | '+unit if unit else '')
            fields.append(dict(Name=name,Kind=kind,Minimum=minimum,Maximum=maximum,ReviewMaximum=review,Unit=unit,Label=label,Nullable=c['nullable'],HistogramWidth=HIST.get(name)))
        source=dict(Table=table,File=path.name,PrimaryKey=definition['primary_key'],Rows=len(rows),Columns=columns,Fields=fields,Sha256=hashlib.sha256(path.read_bytes()).hexdigest())
        sources.append(source);data[table]=rows
        for field in fields:
            values=[clean(r[field['Name']],field) for r in rows];counts=collections.Counter(s for v,s in values)
            numeric=[v for v,s in values if s=='Valid' and field['Kind'] in ('integer','number')]
            q1=quantile(numeric,.25);q3=quantile(numeric,.75);iqr=q3-q1 if numeric else None
            profiles.append(dict(Source=table,Field=field['Name'],Metric=field['Label'],Unit=field['Unit'],Records=len(rows),Valid=counts['Valid'],Missing=counts['Missing'],Invalid=sum(n for s,n in counts.items() if s not in ('Valid','Missing','Review capacity definition')),Review=counts['Review capacity definition'],Minimum=min(numeric) if numeric else None,P25=q1,Median=statistics.median(numeric) if numeric else None,P75=q3,Maximum=max(numeric) if numeric else None,IqrOutliers=sum(v<q1-1.5*iqr or v>q3+1.5*iqr for v in numeric) if numeric else 0,Kind=field['Kind']))
            if field['HistogramWidth']:
                width=field['HistogramWidth'];buckets=collections.Counter()
                for v in numeric:
                    bucket=math.floor(v/width)
                    if field['Maximum'] is not None and v==field['Maximum']:bucket=max(0,bucket-1)
                    buckets[bucket]+=1
                for b,count in sorted(buckets.items()):hist.append(dict(Metric=field['Label'],BinStart=b*width,Bin=f'{b*width:04g} to {(b+1)*width:04g}',Records=count))
    lookup={s['Table']:{k:g for k,g in ((key,[r for r in data[s['Table']] if r[s['PrimaryKey']].strip()==key]) for key in {r[s['PrimaryKey']].strip() for r in data[s['Table']]})} for s in sources if s['Table']!='fact_health_performance'}
    structure=[]
    for s in sources:
        counts=collections.Counter(r[s['PrimaryKey']].strip() for r in data[s['Table']]);shared=sum(n for n in counts.values() if n>1)
        structure.extend([dict(Source=s['Table'],Group='Unique declared key',Records=len(data[s['Table']])-shared),dict(Source=s['Table'],Group='Repeated declared key',Records=shared)])
    joins=collections.Counter();attribution=collections.Counter()
    for r in data['fact_health_performance']:
        ns=[len(lookup[t].get(r[k].strip(),[])) for t,k in [('dim_country','country_id'),('dim_date','date_id'),('dim_health_system','system_id'),('dim_workforce','workforce_id')]]
        joins['Missing parent' if 0 in ns else 'Ambiguous parent' if any(n>1 for n in ns) else 'Single parents']+=1
        systems=lookup['dim_health_system'].get(r['system_id'].strip(),[]);workforce=lookup['dim_workforce'].get(r['workforce_id'].strip(),[])
        attribution['Not testable' if len(systems)!=1 or len(workforce)!=1 else 'Conflict' if systems[0]['country_id'].strip()!=r['country_id'].strip() or workforce[0]['system_id'].strip()!=r['system_id'].strip() else 'Agrees']+=1
    pairs=[]
    source_map={s['Table']:s for s in sources}
    for table,x,y,label in PAIRS:
        fs={f['Name']:f for f in source_map[table]['Fields']};xy=[]
        for r in data[table]:
            vx,sx=clean(r[x],fs[x]);vy,sy=clean(r[y],fs[y])
            if sx==sy=='Valid':xy.append((vx,vy))
        correlation=statistics.correlation([a for a,b in xy],[b for a,b in xy]) if len(xy)>=30 else None
        pairs.append(dict(Source=table,X=x,Y=y,Pair=label,Pairs=len(xy),Correlation=correlation,Status='Exploratory only' if len(xy)>=30 else 'Too few eligible pairs (<30)'))
    contract=dict(SourceFolder=str((ROOT/'Data Source/Original').resolve()),Sources=sources,Pairs=[dict(Source=t,X=x,Y=y,Pair=l) for t,x,y,l in PAIRS],Interpretation='Generated organizer data; preserve raw files. Accepted cells meet declared cleaning rules, not verified clinical or entity semantics.')
    expected=dict(Profiles=profiles,Histograms=hist,KeyGroups=structure,JoinGroups=dict(joins),AttributionGroups=dict(attribution),Pairs=pairs)
    (OUT/'contract.json').write_text(json.dumps(contract,indent=2,ensure_ascii=False),encoding='utf-8');(OUT/'expected.json').write_text(json.dumps(expected,indent=2,ensure_ascii=False),encoding='utf-8')
    print(json.dumps(dict(Sources=[dict(Table=s['Table'],Rows=s['Rows']) for s in sources],JoinGroups=dict(joins),AttributionGroups=dict(attribution),Pairs=pairs)))
if __name__=='__main__':main()
