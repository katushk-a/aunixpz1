from flask import Flask

app = Flask(__name__)

@app.route("/run-script")
def hello_world():
    return "<p style='color:blue'>Server was successfully runned!</p>"

if __name__ == 'main':
    app.run(host='0.0.0.0')


