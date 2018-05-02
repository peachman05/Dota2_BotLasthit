from flask import Flask, jsonify, request
from DQN import DQNAgent
import os
 

app = Flask(__name__)

num_state = 6
num_action = 2

### if you want to change the number of node in hidden, you must change it in build_model() in DQN.py and here both.
num_hidden_node = [120,120]

dqn_agent = DQNAgent(num_state,num_action,num_hidden_node)

@app.route('/model', methods=['GET'])
def get_model():
    return jsonify(dqn_agent.get_model())

@app.route('/update', methods=['POST'])
def update():

    dqn_agent.run(request.json)
    print("finish run")
    return jsonify(dqn_agent.get_model())

if __name__ == '__main__':  
    app.run(debug=False)