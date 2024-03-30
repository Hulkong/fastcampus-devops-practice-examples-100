from flask import Flask
import numpy as np
import pandas as pd

app = Flask(__name__)

@app.route('/')
def home():
    data = np.array([1, 2, 3, 4, 5])
    df = pd.DataFrame(data, columns=['Numbers'])
    return df.to_html()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)