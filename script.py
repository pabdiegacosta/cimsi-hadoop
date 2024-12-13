import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from pyspark.sql import SparkSession
from pyspark.ml.feature import Word2Vec
from pyspark.sql.functions import col, concat_ws

# Initialize Spark Session
spark = SparkSession.builder \
    .appName("Distributed Word2Vec") \
    .getOrCreate()

# Load Data from HDFS
data = spark.read.text("hdfs://master:9000/user/hadoop/word2vec/input/text2.txt").rdd.map(lambda r: r[0].split())

# Convert to DataFrame
df = spark.createDataFrame(data.map(lambda x: (x,)), ["words"])

# Configure Word2Vec
word2Vec = Word2Vec(vectorSize=2, minCount=1, numPartitions=4, inputCol="words", outputCol="result")

# Train Model
model = word2Vec.fit(df)

# Show vectors
vectors_df = model.getVectors()
vectors_df.show(truncate = False)

# Save in parquet format
vectors_df.write.mode("overwrite").parquet("hdfs://master:9000/user/hadoop/word2vec/output/vectors.parquet")
vectors_df_parquet = spark.read.parquet('hdfs://master:9000/user/hadoop/word2vec/output/vectors.parquet')


# Save the word vectors DataFrame as a CSV file
#vectors_df.write.csv('hdfs://master:9000/user/hadoop/output/vectors.csv', header=True, mode='overwrite')

# Step 4: Save the Word Vectors to Parquet
#vectors_df.write.format("csv").mode("overwrite").options(header='True', delimiter=',').save("hdfs://master:9000/user/hadoop/word2vec/output/vectors.csv")
# Stop Spark Session

# Convert Spark DataFrame to Pandas
vectors_pd = vectors_df.toPandas()
print(vectors_pd.head())
# Extract words and vectors
vectors_pd['x'] = vectors_pd['vector'].apply(lambda vec: vec[0])  # First dimension
vectors_pd['y'] = vectors_pd['vector'].apply(lambda vec: vec[1])  # Second dimension

# Plotting
plt.figure(figsize=(10, 8))
sns.scatterplot(x='x', y='y', data=vectors_pd)

# Annotate points with words
for i, row in vectors_pd.iterrows():
    plt.text(row['x'] + 0.01, row['y'] + 0.01, row['word'], fontsize=9)

plt.title("Word Vectors Visualization")
plt.xlabel("Dimension 1")
plt.ylabel("Dimension 2")
plt.grid(True)
plt.show()

spark.stop()
