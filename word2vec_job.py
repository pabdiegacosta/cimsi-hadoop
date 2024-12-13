from pyspark.sql import SparkSession
from pyspark.ml.feature import Word2Vec
from pyspark.ml.linalg import DenseVector
from pyspark.sql.functions import col, concat_ws, udf
from pyspark.sql.types import DoubleType
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Initialize Spark Session
spark = SparkSession.builder \
    .appName("Distributed Word2Vec") \
    .getOrCreate()

# TODO: CAMBIAR COMO PARAMETROS DE ENTRADA
input_text = "text2.txt"
output_csv = "text2.csv"
output_image = "text2.png"
output_image_base = "/home/hadoop"
hdfs_base = "hdfs://master:9000/user/hadoop/word2vec"

# Load Data from HDFS
data = spark.read.text(f"{hdfs_base}/input/{input_text}").rdd.map(lambda r: r[0].split())

# Convert to DataFrame
df = spark.createDataFrame(data.map(lambda x: (x,)), ["words"])

# Configure Word2Vec
word2Vec = Word2Vec(vectorSize=2, minCount=1, numPartitions=4, inputCol="words", outputCol="result")

# Train Model
model = word2Vec.fit(df)

# Show vectors
model = word2Vec.fit(df)

# Show vectors
vectors_df = model.getVectors()
vectors_df.show(truncate = False)

# Convert Spark DataFrame to Pandas
vectors_pd = vectors_df.toPandas()

# Extract words and vectors
vectors_pd['x'] = vectors_pd['vector'].apply(lambda vec: vec[0])
vectors_pd['y'] = vectors_pd['vector'].apply(lambda vec: vec[1])

# Plotting
plt.figure(figsize=(10, 8))
sns.scatterplot(x='x', y='y', data=vectors_pd)

# Annotate points with words
for i, row in vectors_pd.iterrows():
	plt.text(row['x'] + 0.01, row['y'] + 0.01, row['word'], fontsize=9)

plt.title("Visualizado Word Vectors")
plt.xlabel("Eje X")
plt.ylabel("Eje Y")
plt.grid(True)


#plt.save(f'{hdfs_base}/output/{output_image}')
#plt.savefig(f'{hdfs_base}/output/{output_image}')
plt.savefig(f'{output_image_base}/{output_image}')

def extract_vector_element(vector,index):
	if isinstance(vector, DenseVector):
		return float(vector[index])
	return None

extract_vector_udf_x = udf(lambda v: extract_vector_element(v,0), DoubleType())
extract_vector_udf_y = udf(lambda v: extract_vector_element(v,1), DoubleType())


df_with_xy = vectors_df.withColumn("x", extract_vector_udf_x(col("vector"))) \
			.withColumn("y", extract_vector_udf_y(col("vector"))) \
			.drop("vector")

df_with_xy.write.option("header","true").mode("overwrite").csv(f"{hdfs_base}/output/{output_csv}")

plt.show()
spark.stop()
