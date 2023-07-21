from flask import Flask, render_template, request, url_for, flash, redirect
from flask_mysqldb import  MySQL

from views.user_views import user_views
from views.index_views import index_views
from views.errors_views import pagina_no_encontrada
from config import config


from models.model_usuario import ModelUser
from models.entiti.User import Usuario

app = Flask(__name__)
db = MySQL(app)
app.config['SECRET_KEY'] = 'my secret key'

app.register_blueprint(user_views)
app.register_blueprint(index_views)

@app . route('/login/', methods=('GET', 'POST'))
def login():
    if  request.method == 'POST':
        # print(request.form['username'])
        # print(request.form['contrasena'])

        usuario= Usuario (0,request.form['username'],request.form['contrasena'])
        logged_user=ModelUser.login(db,usuario)
        if logged_user != None:
            if logged_user.contrasena:
                return redirect(url_for('user.home'))
            else:
                flash("Contraseña no valida ...")
            return render_template('users/inicio_sesión.html')
        else:
            flash("Usuario no encontrado ...")
            return render_template('users/inicio_sesión.html')
    else:
        return render_template('users/inicio_sesión.html')

if __name__ == __name__:
    app.register_error_handler(404,pagina_no_encontrada)
    app.config.from_object(config['development'])
    app.run(debug=True, port=5000)