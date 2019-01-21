from flask import Flask, render_template, session, redirect, url_for
from flask_session import Session
from tempfile import mkdtemp

app = Flask(__name__)
app.config['SESSION_FILE_DIR'] = mkdtemp()
app.config['SESSION_PERMANENT'] = False
app.config['SESSION_TYPE'] = 'filesystem'
app.config['TEMPLATES_AUTO_RELOAD'] = True

Session(app)

@app.route('/')
def index():
    if 'board' not in session:
        session['board'] = [[None, None, None], [None, None, None], [None, None, None]]
        session['turn'] = 'X'
        session['message'] = ''

    return render_template('index.html', game = session['board'], turn =
            session['turn'], message = session['message'])

@app.route('/play/<int:row>/<int:col>')
def play(row, col):
    session['board'][row][col] = session['turn']
    if session['board'][0][0] != None and session['board'][0][0] == session['board'][0][1] and session['board'][0][0] == session['board'][0][2] \
    or session['board'][1][0] != None and session['board'][1][0] == session['board'][1][1] and session['board'][1][0] == session['board'][1][2] \
    or session['board'][2][0] != None and session['board'][2][0] == session['board'][2][1] and session['board'][2][0] == session['board'][2][2] \
    or session['board'][0][0] != None and session['board'][0][0] == session['board'][1][0] and session['board'][0][0] == session['board'][2][0] \
    or session['board'][0][1] != None and session['board'][0][1] == session['board'][1][1] and session['board'][0][1] == session['board'][2][1] \
    or session['board'][0][2] != None and session['board'][0][2] == session['board'][1][2] and session['board'][0][2] == session['board'][2][2] \
    or session['board'][0][0] != None and session['board'][0][0] == session['board'][1][1] and session['board'][0][0] == session['board'][2][2] \
    or session['board'][0][2] != None and session['board'][0][2] == session['board'][1][1] and session['board'][0][2] == session['board'][2][0]:
        session['message'] = session['turn'] + ' won the game!!!'
        for i in range(3):
            for j in range(3):
                if session['board'][i][j] == None:
                    session['board'][i][j] = ''

        return redirect(url_for('index'))
    if session['turn'] == 'X':
        session['turn'] = 'O'
    else:
        session['turn'] = 'X'
    return redirect(url_for('index'))

@app.route('/reset')
def reset():
    session.clear()
    return redirect(url_for('index'))
