import secrets  # Importa la librería para generar un token aleatorio
from flask import Flask, render_template, request, url_for, flash, redirect
from flask_mysqldb import MySQL
from views.user_views import user_views
from views.index_views import index_views
from views.errors_views import pagina_no_encontrada, pagina_protegida
from config import config
from models.model_usuario import ModelUser
from models.entiti.User import Usuario
from flask_login import LoginManager, login_user, logout_user, current_user
from flask_wtf.csrf import CSRFProtect

app = Flask(__name__)
db = MySQL(app)
login_manager_app = LoginManager(app)
csrf = CSRFProtect()

@login_manager_app.user_loader
def load_user(id):
    return ModelUser.get_by_id(db, id)

app.config['SECRET_KEY'] = 'my secret key'

app.register_blueprint(user_views)
app.register_blueprint(index_views)

@app.route('/login/', methods=('GET', 'POST'))
def login():
    if request.method == 'POST':
        username = request.form['username']
        tipeuser = request.form['tipeuser']
        password = request.form['contrasena']

        usuario = Usuario(0, 0, 0, 0, username, tipeuser, 0, 0, password, 0)
        logged_user = ModelUser.login(db, usuario)

        if logged_user is not None:
            if logged_user.contrasena:
                if logged_user.tipo_usuario == 'admin':
                    login_user(logged_user)
                    return redirect(url_for('user.index_admin'))  # Redirigir a la página del Admin
                elif logged_user.tipo_usuario == 'cajero':
                    login_user(logged_user)
                    return redirect(url_for('user.index_cajero'))  # Redirigir a la página del Cajero
                else:
                    flash("Tipo de usuario desconocido ...")
            else:
                flash("Contraseña no válida ...")
            return render_template('users/inicio_sesión.html', token=secrets.token_urlsafe(16))
        else:
            flash("Usuario no encontrado ...")
            return render_template('users/inicio_sesión.html', token=secrets.token_urlsafe(16))
    else:
        return render_template('users/inicio_sesión.html', token=secrets.token_urlsafe(16))

@app.route('/logout/', methods=['POST'])
def logout():
    if current_user.is_authenticated:
        logout_user()
    return redirect(url_for('login'))

# Función para evitar el caché del navegador
@app.after_request
def add_header(response):
    response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
    return response

if __name__ == "__main__":
    csrf.init_app(app)
    app.register_error_handler(404, pagina_no_encontrada)
    app.register_error_handler(401, pagina_protegida)
    app.config.from_object(config['development'])
    app.run(debug=True, port=5000)
