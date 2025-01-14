from flask import Flask, jsonify
import subprocess
import json

app = Flask(__name__)

@app.route("/", methods=["GET"])
def run_python_script():
    try:
        # Exécute le script Python et capture la sortie
        python_process = subprocess.run(
            ['python3', './request_reports.py'],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        result = python_process.stdout.strip()
        error = python_process.stderr.strip()

        if error:
            return jsonify({"error": error}), 500

        formatted_result = result.replace("'", "\"").split("\n")
        return jsonify([json.loads(item) for item in formatted_result if item])

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    port = 8126
    app.run(host="0.0.0.0", port=port, debug=True)
