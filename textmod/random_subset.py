import pandas as pd

hive_export = pd.read_csv('/Users/smarshall/Desktop/hive_export.csv')

# print(hive_export.head())

# print(hive_export.status.value_counts())

def binary_audit_subset(export, n_yes, n_no):
    yes_sample = export.loc[export['status'] == '["yes"]'].sample(n=n_yes)
    no_sample  = export.loc[export['status'] == '["no"]'].sample(n=n_no)
    stacked_audit = pd.concat([yes_sample, no_sample], ignore_index=True, axis=0)
    audit_table = stacked_audit[['text_data', 'status']]
    audit_table.to_csv('/Users/smarshall/Desktop/audit_subset.csv', index=False)

binary_audit_subset(hive_export, 342, 2000)