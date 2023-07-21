from flask import Flask, render_template, request, url_for, flash, redirect
from flask_mysqldb import MySQL
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

@app.route('/login/', methods=('GET', 'POST'))
def login():
    if request.method == 'POST':
        username = request.form['username']
        tipeuser = request.form['tipeuser']
        password = request.form['contrasena']

        usuario = Usuario(0, username, tipeuser, password)
        logged_user = ModelUser.login(db, usuario)

        if logged_user is not None:
            if logged_user.contrasena:
                if logged_user.tipo_usuario == 'admin':
                    return redirect(url_for('user.home'))  # Redirigir a la página del Admin
                elif logged_user.tipo_usuario == 'cajero':
                    return redirect(url_for('user.homecajero'))  # Redirigir a la página del Cajero
                else:
                    flash("Tipo de usuario desconocido ...")
            else:
                flash("Contraseña no válida ...")
            return render_template('users/inicio_sesión.html')
        else:
            flash("Usuario no encontrado ...")
            return render_template('users/inicio_sesión.html')
    else:
        return render_template('users/inicio_sesión.html')

if __name__ == "__main__":
    app.register_error_handler(404, pagina_no_encontrada)
    app.config.from_object(config['development'])
    app.run(debug=True, port=5000)
