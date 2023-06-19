# function for splitting out moderator stauses: takes Hive export (my_table) and max possible moderator judgements (Maximum Worker Count) as parameters
def extract_statuses(my_table, n_statuses):
    import json
    def parse_json(value):
        try:
            return json.loads(value)
        except (json.JSONDecodeError, TypeError):
            return None
    my_table['json_loads'] = my_table['statuses'].apply(lambda x: parse_json(str(x)))
    for i in range(n_statuses):
        colname = 'mod' + str(i + 1)
        my_table[colname] = my_table['json_loads'].str[0].str['statuses'].str[i].str['status']
    return my_table

