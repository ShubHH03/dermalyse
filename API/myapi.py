from flask import Flask, request, jsonify
import tensorflow as tf
import numpy as np
from PIL import Image as image
from keras.preprocessing import image
from io import BytesIO


app = Flask(__name__)

# Load your model
model = tf.keras.models.load_model('API/classification_model/xception.keras')

class_labels = {'Acne': 0, 'Actinic keratosis': 1, 'Basal Cell Carcinoma': 2, 'Benign keratosis': 3, 'Dermatofibroma': 4, 'Eczema': 5, 'Fungal Infections ': 6, 'Melanocytic Nevi': 7, 'Melanoma': 8, 'Normal Skin': 9, 'Rosacea': 10, 'Squamous cell carcinoma': 11, 'Urticaria Hives': 12, 'Vascular Tumors': 13, 'Warts Molluscum and other Viral Infections': 14}

@app.route('/', methods=['GET'])
def hello():
    return jsonify({'message': 'hello'})



@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
    if file:
        file_stream = BytesIO(file.read())
        img = image.load_img(file_stream, target_size=(299, 299))
        img_array = image.img_to_array(img)
        img_array = np.expand_dims(img_array, axis=0) / 255.

        predictions = model.predict(img_array)
        instance_predictions = predictions[0]
        flattened_predictions = instance_predictions.flatten()
        sorted_indices = np.argsort(flattened_predictions)[::-1]

        top3_indices = sorted_indices[:3]
        top3_predictions = {}

        for index in top3_indices:
            class_name = list(class_labels.keys())[index]
            # Convert float32 to float
            probability = float(flattened_predictions[index])
            top3_predictions[class_name] = probability

        return jsonify(top3_predictions)


if __name__ == '__main__':
    app.run(debug=True)
