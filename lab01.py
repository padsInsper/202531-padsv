import pandas as pd
import seaborn as sns

olist = pd.read_parquet("data-raw/parquet/olist_items.parquet")

contagens = olist.value_counts('types').reset_index()

contagens = contagens[contagens['count'] > 100]
contagens['count'] = contagens['count'] / 1000

sns.countplot(olist, y = 'types')
